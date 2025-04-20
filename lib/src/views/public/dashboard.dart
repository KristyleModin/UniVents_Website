import 'package:flutter/material.dart';
import 'package:univents/src/views/public/Sign_In_Page.dart';
import 'package:univents/src/views/public/auth.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("homepage"),
            SizedBox(height: 30),
            SizedBox(
              height: 55,
              width: 280,
              child: ElevatedButton(
                onPressed: () async {
                  final user = await signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Signed out successfully!"))
                    );
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text("Sign out")
              ),
            ),
          ],
        )
      ),
    );
  }
}