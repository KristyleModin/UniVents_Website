import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditEventPage extends StatefulWidget {
  final DocumentReference eventRef;
  final Map<String, dynamic> initialData;

  const EditEventPage({
    super.key,
    required this.eventRef,
    required this.initialData,
  });

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  bool _bannerChanged = false;

  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  late TextEditingController _statusController;
  late TextEditingController _typeController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  late DateTime _startDate;
  late DateTime _endDate;

  File? _bannerImageFile;
  Uint8List? _webImageBytes;
  String? _currentBannerUrl;

  final List<String> _statusOptions = ['Upcoming', 'Ongoing', 'Done'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData['title'] ?? '');
    _locationController = TextEditingController(text: widget.initialData['location'] ?? '');
    _descriptionController = TextEditingController(text: widget.initialData['description'] ?? '');
    _tagsController = TextEditingController(text: widget.initialData['tags'] ?? '');
    _typeController = TextEditingController(text: widget.initialData['type'] ?? '');

    // Fix for status field: normalize and validate
    final rawStatus = (widget.initialData['status'] ?? '').toString().toLowerCase();
    final matchedStatus = _statusOptions.firstWhere(
      (opt) => opt.toLowerCase() == rawStatus,
      orElse: () => '',
    );
    _statusController = TextEditingController(text: matchedStatus);

    final rawStart = widget.initialData['datetimestart'];
    final rawEnd = widget.initialData['datetimeend'];

    _startDate = (rawStart is Timestamp)
        ? rawStart.toDate()
        : (rawStart is DateTime)
            ? rawStart
            : DateTime.now();

    _endDate = (rawEnd is Timestamp)
        ? rawEnd.toDate()
        : (rawEnd is DateTime)
            ? rawEnd
            : DateTime.now();

    _startDateController = TextEditingController(
      text: DateFormat('MMMM d, y h:mm a').format(_startDate),
    );
    _endDateController = TextEditingController(
      text: DateFormat('MMMM d, y h:mm a').format(_endDate),
    );

    _currentBannerUrl = widget.initialData['banner'] ?? '';
  }

  Future<void> _pickBannerImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _bannerChanged = true;
      });

      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _bannerImageFile = null;
        });
      } else {
        setState(() {
          _bannerImageFile = File(pickedFile.path);
          _webImageBytes = null;
        });
      }
    }
  }

  Future<void> updateEvent() async {
    if (_formKey.currentState!.validate()) {
      // Parse controller values only if not empty
      try {
        _startDate = DateFormat('MMMM d, y h:mm a').parse(_startDateController.text.trim());
        _endDate = DateFormat('MMMM d, y h:mm a').parse(_endDateController.text.trim());
      } catch (e) {
        // If parsing fails, notify user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid date format. Please reselect the date.')),
        );
        return;
      }

      String bannerUrl = _currentBannerUrl ?? '';

      if (_bannerChanged && (_bannerImageFile != null || _webImageBytes != null)) {
        // (upload banner code unchanged)
      } else if (!_bannerChanged && (bannerUrl.isEmpty || bannerUrl == '')) {
        final snapshot = await widget.eventRef.get();
        bannerUrl = snapshot['banner'] ?? '';
      }

      // Save updated event
      await widget.eventRef.update({
        'title': _titleController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'tags': _tagsController.text.trim(),
        'status': _statusController.text.trim(),
        'type': _typeController.text.trim(),
        'datetimestart': _startDate,
        'datetimeend': _endDate,
        'banner': bannerUrl,
      });

      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }


  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final initialDate = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          if (isStart) {
            _startDate = selectedDateTime;
            _startDateController.text = DateFormat('MMMM d, y h:mm a').format(selectedDateTime);
          } else {
            _endDate = selectedDateTime;
            _endDateController.text = DateFormat('MMMM d, y h:mm a').format(selectedDateTime);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Event")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Banner Image", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (kIsWeb && _webImageBytes != null)
                Image.memory(_webImageBytes!, height: 200, fit: BoxFit.cover)
              else if (!kIsWeb && _bannerImageFile != null)
                Image.file(_bannerImageFile!, height: 200, fit: BoxFit.cover)
              else if (_currentBannerUrl != null && _currentBannerUrl!.isNotEmpty)
                Image.network(_currentBannerUrl!, height: 200, fit: BoxFit.cover)
              else
                const Text("No banner selected"),
              TextButton.icon(
                onPressed: _pickBannerImage,
                icon: const Icon(Icons.image),
                label: const Text("Change Banner"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) => value!.isEmpty ? "Title is required" : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (value) => value!.isEmpty ? "Location is required" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? "Description is required" : null,
              ),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(labelText: "Tags"),
              ),
              DropdownButtonFormField<String>(
                value: _statusController.text.isNotEmpty ? _statusController.text : null,
                items: _statusOptions.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _statusController.text = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Status"),
                validator: (value) => value == null || value.isEmpty ? "Status is required" : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: "Type"),
                validator: (value) => value!.isEmpty ? "Type is required" : null,
              ),
              GestureDetector(
                onTap: () => _selectDateTime(context, true),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _startDateController,
                    decoration: const InputDecoration(labelText: "Start Date and Time"),
                    validator: (value) => value!.isEmpty ? "Start Date is required" : null,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDateTime(context, false),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _endDateController,
                    decoration: const InputDecoration(labelText: "End Date and Time"),
                    validator: (value) => value!.isEmpty ? "End Date is required" : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: updateEvent, child: const Text("Save")),
            ],
          ),
        ),
      ),
    );
  }
}
