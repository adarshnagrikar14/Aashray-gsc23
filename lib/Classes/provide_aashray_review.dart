// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class ProvideAashrayReview extends StatefulWidget {
  const ProvideAashrayReview({super.key});

  @override
  State<ProvideAashrayReview> createState() => _ProvideAashrayReviewState();
}

class _ProvideAashrayReviewState extends State<ProvideAashrayReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        title: const Text("Review Aashray"),
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
      body: Padding(
        padding: const EdgeInsets.all(
          10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Lottie.asset(
                'assets/animations/thankyou-lottie.json',
                width: 300,
                height: 300,
                fit: BoxFit.fill,
                // repeat: false,
                reverse: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 40.0,
              ),
              child: Text(
                "Summary",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "Your Aashray will be available to the needy people as mentioned by you.\nYou can edit and see your Aashray in 'My Aashray' Section.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: (() => {Navigator.pop(context)}),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    child: Center(
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            )
          ],
        ),
      ),
    );
  }
}
