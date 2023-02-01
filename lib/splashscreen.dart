import 'dart:async';

import 'package:aashray/Login/login.dart';
import 'package:aashray/MainScreen/mainScreen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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

// Customisation
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
        systemNavigationBarColor: Colors.white,
      ),
    );

    User? user = FirebaseAuth.instance.currentUser;

    // Timer for splashscreen
    Timer(
      const Duration(
        seconds: 2,
      ),
      () {
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // Main
              builder: (context) => const MainScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // Login
              builder: (context) => const LoginPage(),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // logo
          Image.asset(
            "assets/images/splash_logo.png",
            height: 180.0,
          ),
        ],
      ),
    );
  }
}
