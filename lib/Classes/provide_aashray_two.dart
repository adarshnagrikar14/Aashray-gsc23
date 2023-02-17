// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aashray/Classes/provide_aashray_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProvideAashrayTwo extends StatefulWidget {
  const ProvideAashrayTwo({super.key});

  @override
  State<ProvideAashrayTwo> createState() => _ProvideAashrayTwoState();
}

class _ProvideAashrayTwoState extends State<ProvideAashrayTwo> {
  int? _valueMale = 1, _valueFemale = 1;
  late bool _loading;

  @override
  void initState() {
    super.initState();

    setState(() {
      _loading = false;
    });
  }

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
                "Enter Family Details",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "We are asking this information to accomodate appropriate person to live in your Aashray.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "No. of Male",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Name edittext
            Padding(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              child: Wrap(
                // list of length 3
                children: List.generate(
                  8,
                  (int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: ChoiceChip(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 12.0,
                        ),
                        backgroundColor: Colors.grey.shade200,
                        label: Text(
                          getLabel(index),
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        selectedColor: Colors.green.shade400,
                        selected: _valueMale == index,
                        // selected: false,
                        onSelected: (bool selected) {
                          setState(() {
                            _valueMale = selected ? index : null;
                            // selected = true;
                          });
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "No. of Female",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Name edittext
            Padding(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              child: Wrap(
                // list of length 3
                children: List.generate(
                  8,
                  (int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: ChoiceChip(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 12.0,
                        ),
                        backgroundColor: Colors.grey.shade200,
                        label: Text(
                          getLabel(index),
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        selectedColor: Colors.green.shade400,
                        selected: _valueFemale == index,
                        // selected: false,
                        onSelected: (bool selected) {
                          setState(() {
                            _valueFemale = selected ? index : null;
                            // selected = true;
                          });
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
            ),

            // Button
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
            )
          ],
        ),
      ),
    );
  }

  String getLabel(int index) {
    switch (index) {
      case 0:
        return "Zero";
      case 1:
        return "One";
      case 2:
        return "Two";
      case 3:
        return "Three";
      case 4:
        return "Four";
      case 5:
        return "Five";
      case 6:
        return "Six";
      case 7:
        return "Seven";
      default:
        return "Null";
    }
  }

  uploadData(BuildContext context) {
    String userId;
    final User? user = FirebaseAuth.instance.currentUser;

    userId = user!.uid;

    if (_valueMale == 0 && _valueFemale == 0) {
      Fluttertoast.showToast(
        msg: "Check choices again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        _loading = true;
      });

      FirebaseFirestore.instance.collection("Aashrays").doc(userId).update({
        "Male": _valueMale,
        "Female": _valueFemale,
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

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProvideAashrayThree(),
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
  }
}
