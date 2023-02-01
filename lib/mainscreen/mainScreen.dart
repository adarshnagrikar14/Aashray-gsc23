// ignore_for_file: file_names

import 'package:aashray/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: (() async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              await googleSignIn.signOut();
              await FirebaseAuth.instance.signOut();

              // Toast msg
              Fluttertoast.showToast(
                msg: "Logout Successful",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              // start activity
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Splashscreen(),
                ),
              );
            }),
            child: const Text("Signout")),
      ),
    );
  }
}
