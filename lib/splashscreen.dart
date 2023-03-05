// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:aashray/Classes/dashboard_aashray_default.dart';
import 'package:aashray/Classes/dashboard_aashray_home.dart';
import 'package:aashray/Classes/permission.dart';
import 'package:aashray/Login/login.dart';
import 'package:aashray/MainScreen/mainScreen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  var location = Location();

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
          checkPermission();
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

  void checkPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      final sharedPrefs = await SharedPreferences.getInstance();
      final String? screenName = sharedPrefs.getString("screenName");

      switch (screenName) {
        case "AashrayDefault":
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // Main
              builder: (context) => MainScreen(
                screenName: "AashrayDefault",
              ),
            ),
          );
          break;
        case "AashrayHome":
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // Main
              builder: (context) => MainScreen(
                screenName: "AashrayHome",
              ),
            ),
          );
          break;
        case "AashrayFood":
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // Main
              builder: (context) => MainScreen(
                screenName: "AashrayFood",
              ),
            ),
          );
          break;

        case "AashrayEmergency":
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // Main
              builder: (context) => MainScreen(
                screenName: "AashrayEmergency",
              ),
            ),
          );
          break;

        default:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // Main
              builder: (context) => MainScreen(
                screenName: "AashrayDefault",
              ),
            ),
          );
      }
    } else if (status.isDenied) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          // Main
          builder: (context) => const PermissionScreen(),
        ),
      );
    }
  }
}
