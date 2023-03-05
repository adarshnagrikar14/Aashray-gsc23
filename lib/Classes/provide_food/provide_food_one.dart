// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:aashray/Classes/provide_food/provide_food_two.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProvideFoodOne extends StatefulWidget {
  const ProvideFoodOne({super.key});

  @override
  State<ProvideFoodOne> createState() => _ProvideFoodOneState();
}

class _ProvideFoodOneState extends State<ProvideFoodOne> {
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNumber = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  late Future<PickedFile?> pickedFile = Future.value(null);

  late bool _ifEnabled;
  late bool _loading;

  // Strings
  late String _name;
  late String _number;
  late double _coordinatesLong, _coordinatesLat;

  late String _path;

  @override
  void initState() {
    super.initState();

    setState(() {
      _ifEnabled = false;
      _name = user!.displayName!;
      _number = "";
      _coordinatesLong = 0.0;
      _coordinatesLat = 0.0;
      _path = "";
      _loading = false;

      _controllerName.text = _name;
    });

    getNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text("Provide Food"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Enter Name",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Name edittext
              Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                ),
                child: TextField(
                  keyboardType: TextInputType.name,
                  autofillHints: [
                    AutofillHints.name,
                  ],
                  controller: _controllerName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Name',
                  ),
                ),
              ),

              // Name
              Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: Text(
                  "Enter Address",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Name edittext
              Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                ),
                child: TextField(
                  keyboardType: TextInputType.streetAddress,
                  autofillHints: [
                    AutofillHints.addressCityAndState,
                  ],
                  enabled: _ifEnabled,
                  controller: _controllerAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Address',
                  ),
                ),
              ),

              // Detect loc
              Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: GestureDetector(
                  onTap: () => detectMyLocation(context),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_searching_sharp,
                        size: 17.0,
                        color: Colors.blue[800],
                      ),
                      Text(
                        "\tDetect Current Location",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Name
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Text(
                  "Enter Mobile Number",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // mobile edittext
              Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                ),
                child: TextField(
                  keyboardType: TextInputType.streetAddress,
                  autofillHints: [
                    AutofillHints.addressCityAndState,
                  ],
                  controller: _controllerNumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Mobile Number',
                  ),
                ),
              ),

              // Name
              Padding(
                padding: EdgeInsets.only(
                  top: 25.0,
                  bottom: 10.0,
                ),
                child: Text(
                  "Add any valid documnent",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Card(
                elevation: 2.0,
                child: Padding(
                  padding: EdgeInsets.all(
                    8.0,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      if (await Permission.storage.request().isGranted) {
                        pickedFile = ImagePicker()
                            // ignore: deprecated_member_use
                            .getImage(source: ImageSource.gallery)
                            .whenComplete(
                              () => {
                                setState(() {
                                  pickedFile.then((value) {
                                    _path = value!.path;
                                  });
                                }),
                              },
                            );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Please grant Permission",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black87,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Image.asset(
                      "assets/images/up-arrow.png",
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                ),
              ),

              FutureBuilder<PickedFile?>(
                future: pickedFile,
                builder: (context, snap) {
                  if (snap.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        right: 5.0,
                        left: 5.0,
                      ),
                      child: Container(
                        color: Colors.green.shade200,
                        child: Image.file(
                          File(snap.data!.path),
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    );
                  }
                  return Container(
                    height: 0.0,
                  );
                },
              ),

              SizedBox(
                height: 100.0,
              ),

              Center(
                child: ElevatedButton(
                  onPressed: (() {
                    saveAndNext(
                      _controllerName.text,
                      _controllerAddress.text,
                      _controllerNumber.text,
                      _coordinatesLat,
                      _coordinatesLong,
                      _path,
                    );
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

              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  detectMyLocation(BuildContext context) {
    getLocationAndAdd();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError(
      (error, stackTrace) async {
        await Geolocator.requestPermission();
      },
    );
    return await Geolocator.getCurrentPosition();
  }

  void getLocationAndAdd() {
    getUserCurrentLocation().then(
      (value) async {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          value.latitude,
          value.longitude,
        );
        setState(() {
          String myAddress = placemarks[0].subLocality as String;
          String postalCode = placemarks[0].postalCode as String;
          String cityName = placemarks[0].locality as String;

          setState(() {
            _controllerAddress.text = "$myAddress - $cityName, $postalCode";
            _ifEnabled = true;

            _coordinatesLat = value.latitude;
            _coordinatesLong = value.longitude;
          });
        });
      },
    );
  }

  void getNumber() {
    final String userID = user!.uid;

    var docRef = FirebaseFirestore.instance
        .collection('Mobile Numbers')
        .doc(userID)
        .collection("Mobile Number: $userID")
        .doc(userID);

    docRef.get().then((value) {
      if (value.exists) {
        setState(() {
          _number = value.get("Number").toString();

          _controllerNumber.text = _number;
        });
      }
    }).onError((error, stackTrace) => null);
  }

  void saveAndNext(String name, String address, String number,
      double coordinatesLat, double coordinatesLong, String path) {
    if (name.isNotEmpty &&
        address.isNotEmpty &&
        number.isNotEmpty &&
        path.isNotEmpty) {
      setState(() {
        _loading = true;
      });
      // Init
      String userId;
      final User? user = FirebaseAuth.instance.currentUser;

      userId = user!.uid;

      FirebaseStorage storage = FirebaseStorage.instance;

      Reference reference = storage.ref().child("$userId-vDocFood.jpg");
      UploadTask uploadTask = reference.putFile(File(path));

      uploadTask.whenComplete(
        () async {
          String url = await reference.getDownloadURL();
          // Map<String, String> data = {};
          FirebaseFirestore.instance
              .collection("Food Providers")
              .doc(userId)
              .set({
            "Name": name,
            "Address": address,
            "Mobile": number,
            "CoordinatesLat": coordinatesLat,
            "CoordinatesLong": coordinatesLong,
            "VerificationDocument": url,
          }).whenComplete(
            () {
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
                  builder: (context) => const ProvideFoodTwo(),
                ),
              );
            },
          ).onError(
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
        },
      );
    } else {
      Fluttertoast.showToast(
        msg: "Please check inputs",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
