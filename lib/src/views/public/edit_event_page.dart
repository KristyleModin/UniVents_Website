import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData['title'] ?? '');
    _locationController = TextEditingController(text: widget.initialData['location'] ?? '');
    _descriptionController = TextEditingController(text: widget.initialData['description'] ?? '');
    _tagsController = TextEditingController(text: widget.initialData['tags'] ?? '');
    _statusController = TextEditingController(text: widget.initialData['status'] ?? '');
    _typeController = TextEditingController(text: widget.initialData['type'] ?? '');

    final rawStart = widget.initialData['datetimestart'];
    final rawEnd = widget.initialData['datetimeend'];

    _startDate = (rawStart is Timestamp)
        ? rawStart.toDate()
        : (rawStart is DateTime)
            ? rawStart
            : DateTime.now(); // fallback if null

    _endDate = (rawEnd is Timestamp)
        ? rawEnd.toDate()
        : (rawEnd is DateTime)
            ? rawEnd
            : DateTime.now(); // fallback if null

    _startDateController = TextEditingController(
      text: DateFormat('MMMM d, y h:mm a').format(_startDate),
    );
    _endDateController = TextEditingController(
      text: DateFormat('MMMM d, y h:mm a').format(_endDate),
    );
  }


  Future<void> updateEvent() async {
    if (_formKey.currentState!.validate()) {
      await widget.eventRef.update({
        'title': _titleController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'tags': _tagsController.text.trim(), // Stored as string
        'status': _statusController.text.trim(),
        'type': _typeController.text.trim(),
        'datetimestart': _startDate, // Field name updated
        'datetimeend': _endDate,     // Field name updated
      });
      Navigator.pop(context, true); // Return success
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
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: "Status"),
                validator: (value) => value!.isEmpty ? "Status is required" : null,
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
              ElevatedButton(
                onPressed: updateEvent,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}