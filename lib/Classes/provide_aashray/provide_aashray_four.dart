// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'package:aashray/Classes/provide_aashray/provide_aashray_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvideAashrayFour extends StatefulWidget {
  const ProvideAashrayFour({super.key});

  @override
  State<ProvideAashrayFour> createState() => _ProvideAashrayFourState();
}

class _ProvideAashrayFourState extends State<ProvideAashrayFour> {
  int valuePeriod = 10;
  int valueMaxAcc = 4;

  late bool _loading = false;

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
      body: Padding(
        padding: const EdgeInsets.all(
          10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                "Enter Aashray Availability",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "You are just a step away for providing a helping hand. Provide accurate information to help others in a better way.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Select availability period of your Aashray",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "This is the maximum period you are allowing a seeker to live at your Aashray",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                // horizontal: 5.0,
              ),
              child: Slider(
                value: valuePeriod.toDouble(),
                min: 1,
                max: 100,
                divisions: 100,
                activeColor: Colors.green,
                inactiveColor: Colors.grey.shade400,
                label: '${valuePeriod.round()} Days',
                thumbColor: Colors.black,
                onChanged: (double newValue) {
                  setState(() {
                    valuePeriod = newValue.round();
                  });
                },
                semanticFormatterCallback: (double newValue) {
                  return '${newValue.round()}';
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                // horizontal: 5.0,
              ),
              child: Text(
                '$valuePeriod Days',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Select Maximum no. of members to allow",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "This is the maximum no. of seeker you are allowing to live at your Aashray",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                // horizontal: 5.0,
              ),
              child: Slider(
                value: valueMaxAcc.toDouble(),
                min: 1,
                max: 10,
                divisions: 10,
                activeColor: Colors.green,
                inactiveColor: Colors.grey.shade400,
                label: '${valueMaxAcc.round()} Members',
                thumbColor: Colors.black,
                onChanged: (double newValue) {
                  setState(() {
                    valueMaxAcc = newValue.round();
                  });
                },
                semanticFormatterCallback: (double newValue) {
                  return '${newValue.round()}';
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                // horizontal: 5.0,
              ),
              child: Text(
                '$valueMaxAcc Members',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: (() => uploadData(context)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    child: Center(
                      child: Stack(
                        children: [
                          if (!_loading)
                            Text(
                              "Save and Next",
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            ),

                          // Circular progress bar
                          if (_loading)
                            Center(
                              child: SizedBox(
                                height: 28.0,
                                width: 28.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.8,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
          ],
        ),
      ),
    );
  }

  uploadData(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;

    setState(() {
      _loading = true;
    });

    FirebaseFirestore.instance.collection("Aashrays").doc(userId).update({
      "Maximum Accomodation": "$valueMaxAcc Members",
      "Max Period": "$valuePeriod Days",
      "userID": userId,
    }).whenComplete(() {
      Fluttertoast.showToast(
        msg: "Uploaded Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _loading = false;
      });

      storeState();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProvideAashrayReview(),
        ),
      );
    }).onError(
      (error, stackTrace) {
        Fluttertoast.showToast(
          msg: "Error occurred",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
    );
  }

  void storeState() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString("screenName", "AashrayHome");
  }
}
