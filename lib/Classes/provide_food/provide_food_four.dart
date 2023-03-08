// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aashray/Classes/provide_food/provide_food_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvideFoodFour extends StatefulWidget {
  const ProvideFoodFour({super.key});

  @override
  State<ProvideFoodFour> createState() => _ProvideFoodFourState();
}

class _ProvideFoodFourState extends State<ProvideFoodFour> {
  final TextEditingController _controllerMin = TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerAvg = TextEditingController();

  late bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controllerAvg.text = "";
    _controllerMax.text = "";
    _controllerMin.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text("Volunteer for Food"),
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
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Enter Maximum and average capacity of people you can provide the food.",
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Input
            Padding(
              padding: EdgeInsets.only(
                top: 25.0,
              ),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                controller: _controllerMin,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Minimum No. of People",
                ),
                style: TextStyle(
                  fontSize: 18.0,
                ),
                enabled: false,
              ),
            ),
            // Input
            Padding(
              padding: EdgeInsets.only(
                top: 25.0,
              ),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                controller: _controllerMax,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Maximum No. of People",
                ),
                style: TextStyle(
                  fontSize: 18.0,
                ),
                onChanged: (value) {
                  makeAverage();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 13.0,
                bottom: 15.0,
              ),
              child: Text(
                "Maximum no. of people you can feed.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            // Input
            Padding(
              padding: EdgeInsets.only(
                top: 25.0,
              ),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                controller: _controllerAvg,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Average No. of People",
                ),
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 13.0,
                bottom: 15.0,
              ),
              child: Text(
                "Average no. of people you can feed. The estimated average is calculated for the Max people you provide. You can change it on your own.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                ),
                child: ElevatedButton(
                  onPressed: (() {
                    saveandnext(_controllerMin.text, _controllerMax.text,
                        _controllerAvg.text);
                  }),
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
            ),
          ],
        ),
      ),
    );
  }

  void makeAverage() {
    int avgOne = int.parse(_controllerMax.text);

    int avgTwo = avgOne + 1;

    double avgThree = avgTwo / 2;

    int avg = avgThree.round();

    setState(() {
      _controllerAvg.text = "$avg";
    });
  }

  void saveandnext(String min, String max, String avg) {
    String userId;
    final User? user = FirebaseAuth.instance.currentUser;

    userId = user!.uid;

    if (min.isNotEmpty && max.isNotEmpty && avg.isNotEmpty) {
      setState(() {
        _loading = !_loading;
      });

      FirebaseFirestore.instance
          .collection("Food Providers")
          .doc(userId)
          .update({
        "Minimum": min,
        "Maximum": max,
        "Average": avg,
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

        setScreen();
      }).onError((error, stackTrace) => null);
    } else {
      Fluttertoast.showToast(
        msg: "Select any one option",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void setScreen() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString("screenName", "AashrayFood").then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProvideFoodReview(),
        ),
      );
    });
  }
}
