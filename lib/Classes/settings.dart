// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 5.0,
        ),
        child: Column(
          children: [
            ListTile(
              title: const Text(
                "App permissions",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20.0,
              ),
              onTap: () => openAppSettings(),
            ),
            Container(
              height: 1.0,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                title: const Text(
                  "Report",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                ),
                onTap: () {},
              ),
            ),
            Container(
              height: 1.0,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                title: const Text(
                  "Feedback",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                ),
                onTap: () {},
              ),
            ),
            Container(
              height: 1.0,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                title: const Text(
                  "About",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                ),
                onTap: () {},
              ),
            ),
            Container(
              height: 1.0,
              color: Colors.grey.shade200,
            ),
          ],
        ),
      ),
    );
  }
}
