// ignore_for_file: use_build_context_synchronously

import 'package:aashray/MainScreen/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  var location = Location();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Permission Needed",
          style: TextStyle(
            fontSize: 22.0,
          ),
        ),
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Location permission needed for continuing with the application.",
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),

            // Image
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Image.asset(
                "assets/images/location-perm.jpg",
                height: 300.0,
              ),
            ),

            // Button
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: ElevatedButton(
                  onPressed: (() {
                    getPermission();
                  }),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                        ),
                        child: Text(
                          "Give Permission",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getPermission() async {
    PermissionStatus permission = await location.requestPermission();
    if (permission == PermissionStatus.granted) {
      // Permission granted
      Fluttertoast.showToast(
        msg: "Permission granted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      openMainscreen();
    } else {
      // Permission denied
      Fluttertoast.showToast(
        msg: "Location access denied",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void openMainscreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        // Main
        builder: (context) => MainScreen(
          screenName: "AashrayDefault",
        ),
      ),
    );
  }
}
