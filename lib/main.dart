import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:univents/src/services/auth.dart'; // your auth file
import 'package:univents/src/views/public/dashboard.dart';
import 'package:univents/src/views/public/sign_In_Page.dart';
// import 'package:univents/src/views/public/sign_In_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAgV4s8MHNajQcvkQclWo2ltnMlXj7PsCY",
      authDomain: "cse1-teamf2.firebaseapp.com",
      projectId: "cse1-teamf2",
      storageBucket: "cse1-teamf2.firebasestorage.app",
      messagingSenderId: "524171464130",
      appId: "1:524171464130:web:1d862814cdf48b6d099a5b",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool loading = true; // <--- Add a loading flag

  Future<void> getUserInfo() async {
    bool userLoggedIn = await getUser();
    setState(() {
      isLoggedIn = userLoggedIn;
      loading = false; // <--- After checking, stop loading
    });
    print("User ID: $uid");
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Web",
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      home: loading 
          ? Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : isLoggedIn 
            ? Dashboard() 
            : SignInPage(),
    );
  }
}

// @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Flutter Web",
//       theme: ThemeData(brightness: Brightness.light),
//       debugShowCheckedModeBanner: false,
//       home: Dashboard(), // Directly go to Dashboard
//     );
//   }
// }