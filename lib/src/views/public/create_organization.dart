import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:univents/src/views/public/organization_details.dart';

class CreateOrganization extends StatefulWidget {
  const CreateOrganization({super.key});

  @override
  State<CreateOrganization> createState() => _CreateOrganizationState();
}

class _CreateOrganizationState extends State<CreateOrganization> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _acronymController = TextEditingController();
  final _categoryController = TextEditingController();
  final _statusController = TextEditingController();
  final _emailController = TextEditingController();
  final _facebookController = TextEditingController();
  final _mobileController = TextEditingController();

  Uint8List? _bannerBytes;
  Uint8List? _logoBytes;

  Future<void> _pickImage(bool isBanner) async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file == null) return;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((_) {
        setState(() {
          if (isBanner) {
            _bannerBytes = reader.result as Uint8List;
          } else {
            _logoBytes = reader.result as Uint8List;
          }
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

  Future<void> _createOrganization() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Creation'),
          content: const Text('Are you sure you want to create this organization?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm')),
          ],
        ),
      );

      if (confirm != true) return;

      final String newId = const Uuid().v4();
      String bannerUrl = '';
      String logoUrl = '';

      if (_bannerBytes != null) {
        bannerUrl = await _uploadImage(_bannerBytes!, 'Organization - Banner/$newId.jpg');
      }
      if (_logoBytes != null) {
        logoUrl = await _uploadImage(_logoBytes!, 'Organization - Logo/$newId.jpg');
      }

      final data = {
        'uid': newId,
        'name': _nameController.text.trim(),
        'acronym': _acronymController.text.trim(),
        'category': _categoryController.text.trim(),
        'status': _statusController.text.trim(),
        'email': _emailController.text.trim(),
        'facebook': _facebookController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'banner': bannerUrl,
        'logo': logoUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('organizations').doc(newId).set(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Organization created successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewOrganization(
            uid: newId,
            name: _nameController.text.trim(),
            acronym: _acronymController.text.trim(),
            category: _categoryController.text.trim(),
            status: _statusController.text.trim(),
            email: _emailController.text.trim(),
            facebook: _facebookController.text.trim(),
            mobile: _mobileController.text.trim(),
            banner: bannerUrl,
            logo: logoUrl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Organization'),
        backgroundColor: const Color(0xFF182C8C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Banner", style: TextStyle(fontSize: 20)),
              _bannerBytes != null
                  ? Image.memory(_bannerBytes!, height: 150)
                  : const Placeholder(fallbackHeight: 150),
              TextButton(
                onPressed: () => _pickImage(true),
                child: const Text("Upload Banner"),
              ),
              const SizedBox(height: 20),
              const Text("Logo", style: TextStyle(fontSize: 20)),
              _logoBytes != null
                  ? Image.memory(_logoBytes!, height: 100)
                  : const Placeholder(fallbackHeight: 100),
              TextButton(
                onPressed: () => _pickImage(false),
                child: const Text("Upload Logo"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _acronymController,
                decoration: const InputDecoration(labelText: 'Acronym'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _facebookController,
                decoration: const InputDecoration(labelText: 'Facebook'),
              ),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: 'Mobile'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _createOrganization,
                child: const Text('Create Organization'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
