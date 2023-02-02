import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text("Settings"),
        actions: [
          // settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: GestureDetector(
              child: const Tooltip(
                triggerMode: TooltipTriggerMode.longPress,
                message: "Send Feedback",
                child: Icon(
                  Icons.feedback_rounded,
                  size: 25.0,
                ),
              ),
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Sending feedback",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
