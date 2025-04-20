import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _otpFieldController = TextEditingController();

  @override
  void dispose() {
    _otpFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF182C8C), elevation: 0),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 32.0, top: 150.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Verification",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const SizedBox(height: 12),
            const Text(
              "We have sent a verification code to dodonglaboriki@gmail.com.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                SizedBox(
                  height: 64,
                  width: 64,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin) {},
                    decoration: InputDecoration(
                      hintText: "0",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF182C8C)), // Blue border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF182C8C), width: 2), // Blue border when focused
                      ),
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 64,
                  width: 64,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin) {},
                    decoration: InputDecoration(
                      hintText: "0",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF182C8C)), // Blue border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF182C8C), width: 2), // Blue border when focused
                      ),
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 64,
                  width: 64,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin) {},
                    decoration: InputDecoration(
                      hintText: "0",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF182C8C)), // Blue border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF182C8C), width: 2), // Blue border when focused
                      ),
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 64,
                  width: 64,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    onSaved: (pin) {},
                    decoration: InputDecoration(
                      hintText: "0",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF182C8C)), // Blue border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF182C8C), width: 2), // Blue border when focused
                      ),
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 280,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final otp = _otpFieldController.text.trim();

                  if (otp.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill in your otp number"),
                      ),
                    );
                    return;
                  }
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
                        "CONTINUE",
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
            SizedBox(height: 30),
            Row(
              children: [
                const Text(
                  "Resend code in ",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Text(
                  "0:20",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF182C8C)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


