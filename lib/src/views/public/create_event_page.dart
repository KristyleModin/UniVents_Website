// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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

  Uint8List? _bannerImageBytes;
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

  Future<void> _pickBannerImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        print('No image selected.');
        return;
      }

      final bytes = await pickedFile.readAsBytes();

      setState(() => _bannerImageBytes = bytes);

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('Event - Banner/$fileName.png');
      final metadata = SettableMetadata(contentType: 'image/png');

      final uploadTask = await ref.putData(bytes, metadata);
      final downloadUrl = await ref.getDownloadURL();

      setState(() {
        _bannerUrl = downloadUrl;
      });

      print('Upload complete: $_bannerUrl');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Banner image uploaded")),
      );
    } catch (e, stack) {
      print('Image upload failed: $e');
      print('Stack trace: $stack');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed: $e")),
      );
    }
  }

  Future<void> _createEvent() async {
    if (_formKey.currentState!.validate() &&
        _startDateTime != null &&
        _endDateTime != null &&
        _selectedOrganization != null) {
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
          'banner': _bannerUrl ?? '',
          'isVisible': true,
          'createdAt': FieldValue.serverTimestamp(),
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
                    onTap: _pickBannerImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        image: _bannerImageBytes != null
                            ? DecorationImage(
                                image: MemoryImage(_bannerImageBytes!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _bannerImageBytes == null
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