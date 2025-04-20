import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
String? userEmail;
String? imageUrl;

Future<User?> signinWithGoogle() async {
  await Firebase.initializeApp();

  User? user;


  if(kIsWeb) {
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential = await _auth.signInWithPopup(authProvider);

      user = userCredential.user;
    } catch (e) {
      print(e);
    }
  } else {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exist-with-different-credential.') {
          print('The account already exist with a different credential');
        } else if (e.code == 'invalid-credential.'){
          print("Error occurred while accessing credential. Try again.");
        }
      } catch (e) {
        print(e);
      }
    }
  }


  if (user != null) {
    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('auth', true);
  }


  return user;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  await _auth.signOut();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('auth', false);

  uid = null;
  name = null;
  userEmail = null;
  imageUrl = null;

  print("User Sign out of Google Account");
}


final FirebaseAuth _auth = FirebaseAuth.instance;

String? uid;
String? name;


Future<User?> registerWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
  User? user;


  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    user = userCredential.user;

    if(user != null) {
      uid = user.uid;
      userEmail = user.email;
    }
    
  } on FirebaseAuthException catch (e) {
    if(e.code == 'weak-password') {
      print('The password provided is too weak');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exist for the email');
    }
  } catch (e) {
    print(e);
  }

  return user;
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
  User? user;


  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;
    
    if (user != null) {
      uid = user.uid;
      userEmail = user.email;


      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('auth', true);
    }
  } on FirebaseAuthException catch (e) {
    if(e.code == 'user-not-found') {
      print('No User found for that email');
    }else if (e.code == 'strong-password') {
      print("Strong Password Provided");
    }
  }

  return user;
}


Future<String> signOut() async {
  await _auth.signOut();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('auth', false);


  uid = null;
  userEmail = null;

  return'User Signed Out';
}

Future getUser() async {
  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool authSignedIn = preferences.getBool('auth') ?? false;


  final User? user = _auth.currentUser;

  if(authSignedIn == true ) {
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;
    }
  }
}