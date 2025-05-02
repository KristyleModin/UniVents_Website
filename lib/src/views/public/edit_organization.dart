import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:univents/src/views/public/organization_details.dart';

class EditOrganization extends StatefulWidget {
  final String uid;
  final String name;
  final String acronym;
  final String category;
  final String status;
  final String email;
  final String facebook;
  final String mobile;
  final String banner;
  final String logo;

  const EditOrganization({
    super.key,
    required this.uid,
    required this.name,
    required this.acronym,
    required this.category,
    required this.status,
    required this.email,
    required this.facebook,
    required this.mobile,
    required this.banner,
    required this.logo,
  });

  @override
  State<EditOrganization> createState() => _EditOrganizationState();
}

class _EditOrganizationState extends State<EditOrganization> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _acronymController;
  late TextEditingController _categoryController;
  late TextEditingController _statusController;
  late TextEditingController _emailController;
  late TextEditingController _facebookController;
  late TextEditingController _mobileController;
  late TextEditingController _uidController;

  Uint8List? _bannerBytes;
  Uint8List? _logoBytes;
  late String _banner;
  late String _logo;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _acronymController = TextEditingController(text: widget.acronym);
    _categoryController = TextEditingController(text: widget.category);
    _statusController = TextEditingController(text: widget.status);
    _emailController = TextEditingController(text: widget.email);
    _facebookController = TextEditingController(text: widget.facebook);
    _mobileController = TextEditingController(text: widget.mobile);
    _uidController = TextEditingController(text: widget.uid);
    _banner = widget.banner;
    _logo = widget.logo;
  }

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

  Future<void> _editOrganization() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Update'),
          content: const Text('Are you sure you want to update the organization details?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm')),
          ],
        ),
      );

      if (confirm != true) return;

      String newBannerUrl = _banner;
      String newLogoUrl = _logo;

      if (_bannerBytes != null) {
        newBannerUrl = await _uploadImage(_bannerBytes!, 'Organization - Banner/${widget.uid}_${DateTime.now()}.jpg');
      }

      if (_logoBytes != null) {
        newLogoUrl = await _uploadImage(_logoBytes!, 'Organization - Logo/${widget.uid}_${DateTime.now()}.jpg');
      }

      await FirebaseFirestore.instance.collection('organizations').doc(widget.uid).update({
        'name': _nameController.text.trim(),
        'acronym': _acronymController.text.trim(),
        'category': _categoryController.text.trim(),
        'status': _statusController.text.trim(),
        'email': _emailController.text.trim(),
        'facebook': _facebookController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'banner': newBannerUrl,
        'logo': newLogoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Organization updated successfully!")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewOrganization(
            acronym: _acronymController.text.trim(),
            banner: newBannerUrl,
            status: _statusController.text.trim(),
            category: _categoryController.text.trim(),
            email: _emailController.text.trim(),
            facebook: _facebookController.text.trim(),
            logo: newLogoUrl,
            mobile: _mobileController.text.trim(),
            name: _nameController.text.trim(),
            uid: _uidController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Organization'),
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
                  : Image.network(_banner, height: 150),
              TextButton(
                onPressed: () => _pickImage(true),
                child: const Text("Change Banner"),
              ),
              const SizedBox(height: 20),
              const Text("Logo", style: TextStyle(fontSize: 20)),
              _logoBytes != null
                  ? Image.memory(_logoBytes!, height: 100)
                  : Image.network(_logo, height: 100),
              TextButton(
                onPressed: () => _pickImage(false),
                child: const Text("Change Logo"),
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
                onPressed: _editOrganization,
                child: const Text('Update Organization'),
              )
            ],
          ),
        ),
      ),
    );
  }
}