// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aashray/Classes/provide_food/provide_food_four.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProvideFoodThree extends StatefulWidget {
  const ProvideFoodThree({super.key});

  @override
  State<ProvideFoodThree> createState() => _ProvideFoodThreeState();
}

class _ProvideFoodThreeState extends State<ProvideFoodThree> {
  TextEditingController dateinputInitial = TextEditingController();
  TextEditingController dateinputEnd = TextEditingController();
  DateTime dateTime = DateTime(2023);

  late bool _loading = false;

  @override
  void initState() {
    super.initState();
    dateinputInitial.text = "";
    dateinputEnd.text = "";
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
                "Select the suitable Duration",
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                bottom: 30.0,
              ),
              child: Text(
                "Select the approximate range of dates.",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),

            // initial date:
            TextField(
              controller: dateinputInitial,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Enter Beginning date",
              ),
              readOnly: true,
              style: TextStyle(
                fontSize: 18.0,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2024),
                    initialEntryMode: DatePickerEntryMode.calendarOnly);

                if (pickedDate != null) {
                  String convertedDateTime =
                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year.toString()}";

                  setState(() {
                    dateinputInitial.text = convertedDateTime;
                    dateTime = pickedDate;
                  });
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ),
              child: Center(
                child: Icon(
                  Icons.keyboard_double_arrow_down_sharp,
                  size: 50.0,
                  color: Colors.grey,
                ),
              ),
            ),

            // end date:
            TextField(
              controller: dateinputEnd,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Enter End date",
              ),
              enabled: dateinputInitial.text.isEmpty ? false : true,
              readOnly: true,
              style: TextStyle(
                fontSize: 18.0,
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: dateTime,
                    lastDate: DateTime(2024),
                    initialEntryMode: DatePickerEntryMode.calendarOnly);

                if (pickedDate != null) {
                  String convertedDateTime =
                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year.toString()}";

                  setState(() {
                    dateinputEnd.text = convertedDateTime;
                  });
                }
              },
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 35.0,
                bottom: 15.0,
              ),
              child: Text(
                "The dates selected can be changed later.",
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
                    saveandnext(dateinputInitial.text, dateinputEnd.text);
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

  void saveandnext(String initialDate, String endDate) {
    String userId;
    final User? user = FirebaseAuth.instance.currentUser;

    userId = user!.uid;

    if (initialDate.isNotEmpty && endDate.isNotEmpty) {
      setState(() {
        _loading = !_loading;
      });

      FirebaseFirestore.instance
          .collection("Food Providers")
          .doc(userId)
          .update({
        "Initial Date": initialDate,
        "End Date": endDate,
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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProvideFoodFour(),
          ),
        );
      }).onError((error, stackTrace) => null);
    } else {
      Fluttertoast.showToast(
        msg: "Select proper option",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
