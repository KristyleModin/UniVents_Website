import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univents/src/views/public/sign_In_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:univents/src/views/public/dashboard.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? uid;
String? name;
String? userEmail;
String? imageUrl;

Future<User?> signInWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('auth', true);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Incorrect password.');
    } else {
      print("FirebaseAuthException: ${e.message}");
    }
  } catch (e) {
    print("Error: $e");
  }

  return user;
}

Future<void> signInWithGoogle(BuildContext context) async {
  await Firebase.initializeApp();
  User? user;

  try {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider()
        ..setCustomParameters({'prompt': 'select_account'});

      final UserCredential userCredential =
          await _auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } else {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign In Cancelled")),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      user = userCredential.user;
    }

    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('auth', true);

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        String role = doc.get('role');
        if (role.toLowerCase() == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logged in successfully!")),
          );
        } else {
          await _auth.signOut();
          await googleSignIn.signOut();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('auth', false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Access denied. Only admins can access this site.",
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        }
      } else {
        await _auth.signOut();
        await googleSignIn.signOut();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auth', false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No account record found. Please contact an administrator.",
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    }
  } catch (e) {
    print("Sign in error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Something went wrong. Please try again.")),
    );
  }
}

Future<User?> registerWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;
    }
  } on FirebaseAuthException catch (e) {
    print('FirebaseAuthException: ${e.message}');
  }

  return user;
}

Future<String> signOut() async {
  try {
    await _auth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('auth', false);

    uid = null;
    userEmail = null;
    name = null;
    imageUrl = null;

    return 'User Signed Out';
  } catch (e) {
    print('Sign out error: $e');
    return 'Error signing out';
  }
}

Future<bool> getUser() async {
  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool authSignedIn = preferences.getBool('auth') ?? false;

  final User? user = _auth.currentUser;

  if (authSignedIn && user != null) {
    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;
    return true;
  } else {
    return false;
  }
}

class AuthService {
  Future<void> sendPasswordResetLink(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
