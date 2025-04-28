import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:univents/src/views/public/dashboard.dart';
// import 'package:univents/src/views/public/sign_In_Page.dart';
import 'package:univents/src/services/auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options: FirebaseOptions(
        apiKey: "AIzaSyAgV4s8MHNajQcvkQclWo2ltnMlXj7PsCY",
        authDomain: "cse1-teamf2.firebaseapp.com",
        projectId: "cse1-teamf2",
        storageBucket: "cse1-teamf2.firebasestorage.app",
        messagingSenderId: "524171464130",
        appId: "1:524171464130:web:1d862814cdf48b6d099a5b"
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    print(uid);
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Web",
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}