import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  // Initialize
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
      ),
    );

    User? user = FirebaseAuth.instance.currentUser;

    // Timer for splashscreen
    Timer(
      const Duration(seconds: 3),
      () {
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // Main
              builder: (context) => const Scaffold(
                backgroundColor: Colors.amber,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // Login
              builder: (context) => const Scaffold(
                backgroundColor: Colors.redAccent,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.network(
            "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Letter_a.svg/800px-Letter_a.svg.png",
            scale: 5.0,
          ),
          const Text(
            "Aashray",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
