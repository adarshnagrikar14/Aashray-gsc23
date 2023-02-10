// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aashray/Classes/permission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MobileNumberAdd extends StatefulWidget {
  const MobileNumberAdd({super.key});

  @override
  State<MobileNumberAdd> createState() => _MobileNumberAddState();
}

class _MobileNumberAddState extends State<MobileNumberAdd> {
  final TextEditingController _controllerNumber = TextEditingController();

  late bool _loading;
  late String _userId;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    setState(() {
      _userId = user!.uid;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text("Enter Mobile Number"),
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Mobile Number",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Number edittext
            Padding(
              padding: EdgeInsets.only(
                top: 25.0,
              ),
              child: TextField(
                keyboardType: TextInputType.phone,
                enabled: !_loading,
                controller: _controllerNumber,
                autofillHints: [
                  AutofillHints.telephoneNumberNational,
                ],
                maxLength: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter mobile number',
                ),
              ),
            ),

            // Button
            const Spacer(),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: ElevatedButton(
                  onPressed: (() {
                    if (_controllerNumber.value.text.length != 10) {
                      showToast("Please enter correct number");
                    } else {
                      setState(() {
                        _loading = true;
                      });
                      uploadNumber(_controllerNumber.value.text);
                    }
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
                                "Submit",
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

  void uploadNumber(String mNumber) {
    var docRef = FirebaseFirestore.instance
        .collection('Mobile Numbers')
        .doc(_userId)
        .collection("Mobile Number: $_userId")
        .doc(_userId);

    docRef.set({"Number": mNumber}).whenComplete(() {
      showToast("Number uploaded");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PermissionScreen(),
        ),
      );
    }).onError((error, stackTrace) {
      setState(() {
        _loading = false;
      });

      showToast("Error occurred");
    });
  }

  void showToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
