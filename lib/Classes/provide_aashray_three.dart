import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProvideAashrayThree extends StatefulWidget {
  const ProvideAashrayThree({super.key});

  @override
  State<ProvideAashrayThree> createState() => _ProvideAashrayThreeState();
}

class _ProvideAashrayThreeState extends State<ProvideAashrayThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text("Provide Aashray"),
        actions: [
          // settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: GestureDetector(
              child: const Tooltip(
                triggerMode: TooltipTriggerMode.longPress,
                message: "Help",
                child: Icon(
                  Icons.help,
                  size: 25.0,
                ),
              ),
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Helping...",
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
