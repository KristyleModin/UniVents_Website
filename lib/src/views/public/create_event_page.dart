import 'dart:html' as html; // Add this import for web-based file picking
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _tagsController = TextEditingController();
  final _typeController = TextEditingController();

  String _status = 'Upcoming';
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  List<String> _organizations = [];
  String? _selectedOrganization;

  Uint8List? _bannerBytes;
  String? _bannerUrl;

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('organizations').get();
      setState(() {
        _organizations = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load organizations: $e")),
      );
    }
  }

    Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final fullDateTime = DateTime(
      date.year, date.month, date.day,
      time.hour, time.minute,
    );

    setState(() {
      if (isStart) {
        _startDateTime = fullDateTime;
      } else {
        _endDateTime = fullDateTime;
      }
    });
  }


  Future<void> _pickImage() async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file == null) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((_) {
        setState(() {
          _bannerBytes = reader.result as Uint8List;
        });
      });
    });
  }

  Future<String> _uploadImage(Uint8List bytes, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putData(bytes, metadata);
    return await ref.getDownloadURL();
  }

  Future<void> _createEvent() async {
    if (_formKey.currentState!.validate() &&
        _startDateTime != null &&
        _endDateTime != null &&
        _selectedOrganization != null) {
      if (_bannerBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload a banner image.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Creation'),
          content: const Text('Are you sure you want to create this event?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm')),
          ],
        ),
      );

      if (confirm != true) return;

      try {
        final orgQuery = await FirebaseFirestore.instance
            .collection('organizations')
            .where('name', isEqualTo: _selectedOrganization)
            .limit(1)
            .get();

        if (orgQuery.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Selected organization not found.")),
          );
          return;
        }

        final orgDoc = orgQuery.docs.first.reference;

        final docRef = FirebaseFirestore.instance.collection('events').doc();
        String bannerUrl = '';

        if (_bannerBytes != null) {
          bannerUrl = await _uploadImage(_bannerBytes!, 'Event - Banner/${docRef.id}.jpg');
        }

        await docRef.set({
          'uid': docRef.id,
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'location': _locationController.text.trim(),
          'orguid': orgDoc,
          'status': _status,
          'tags': _tagsController.text.trim(),
          'type': _typeController.text.trim(),
          'datetimestart': _startDateTime,
          'datetimeend': _endDateTime,
          'banner': bannerUrl,
          'isVisible': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event created successfully")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create event: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields properly")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Event"),
        backgroundColor: const Color(0xFF182C8C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Event Banner", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        image: _bannerBytes != null
                            ? DecorationImage(
                                image: MemoryImage(_bannerBytes!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _bannerBytes == null
                          ? const Center(child: Text("Tap to select image"))
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              _buildTextField(_titleController, "Title"),
              _buildTextField(_descriptionController, "Description"),
              _buildTextField(_locationController, "Location"),
              _buildDropdownOrganization(),
              _buildDropdownStatus(),
              _buildTextField(_typeController, "Type"),
              _buildTextField(_tagsController, "Tags"),
              const SizedBox(height: 20),
              _buildDateTimePicker("Start Time", _startDateTime, () => _pickDateTime(true)),
              _buildDateTimePicker("End Time", _endDateTime, () => _pickDateTime(false)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createEvent,
                child: const Text("Create Event"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _buildDropdownOrganization() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: _selectedOrganization,
        items: _organizations.map((org) {
          return DropdownMenuItem(value: org, child: Text(org));
        }).toList(),
        onChanged: (value) {
          setState(() => _selectedOrganization = value);
        },
        decoration: const InputDecoration(labelText: "Organization"),
        validator: (value) => value == null || value.isEmpty ? 'Please select an organization' : null,
      ),
    );
  }

  Widget _buildDropdownStatus() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: _status,
        items: ['Upcoming', 'Ongoing', 'Done']
            .map((status) => DropdownMenuItem(value: status, child: Text(status)))
            .toList(),
        onChanged: (value) => setState(() => _status = value!),
        decoration: const InputDecoration(labelText: "Status"),
      ),
    );
  }

  Widget _buildDateTimePicker(String label, DateTime? value, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value != null ? value.toString() : 'Select $label'),
      trailing: const Icon(Icons.calendar_today),
      onTap: onTap,
    );
  }
}