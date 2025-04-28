// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:univents/src/views/public/Verification_Page.dart';
import 'package:univents/src/services/auth.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _auth = AuthService();
  final TextEditingController _emailFieldController = TextEditingController();

  @override
  void dispose() {
    _emailFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF182C8C),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 32.0, top: 150.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reset Password",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Please enter your email address to request a password reset",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 500,
              child: TextField(
                controller: _emailFieldController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "abc@email.com",
                  contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE4DFDF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE4DFDF), width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 280,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final email = _emailFieldController.text.trim();

                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in your email address")),
                    );
                    return;
                  }

                  // await _auth.sendPasswordResetLink(email); 
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VerificationPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A verification code has been sent to your email.")));
                  // Send Email to DB to get the code
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF182C8C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "SEND",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      bottom: 8,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3D56F0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
