// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:aashray/Classes/provide_aashray/provide_aashray_four.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProvideAashrayThree extends StatefulWidget {
  const ProvideAashrayThree({super.key});

  @override
  State<ProvideAashrayThree> createState() => _ProvideAashrayThreeState();
}

class _ProvideAashrayThreeState extends State<ProvideAashrayThree> {
  int? _valueRooms = 0;
  int? _valueMeal = 0;
  int? _valueBeds = 1;
  int? _valueAcc = 0;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  "Enter Aashray Details and Facilities",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Provide genuine information to help the people in a better way.",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text(
                  "No. of Rooms available",
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
                child: Wrap(
                  // list of length 3
                  children: List.generate(
                    4,
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
                          selected: _valueRooms == index,
                          // selected: false,
                          onSelected: (bool selected) {
                            setState(() {
                              _valueRooms = selected ? index : null;
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
                  "No. of Beds available",
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
                child: Wrap(
                  // list of length 3
                  children: List.generate(
                    4,
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
                          selected: _valueBeds == index,
                          // selected: false,
                          onSelected: (bool selected) {
                            setState(() {
                              _valueBeds = selected ? index : null;
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
                  "Provide meals",
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
                child: Wrap(
                  // list of length 3
                  children: List.generate(
                    3,
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
                            getMealsLabel(index),
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          selectedColor: Colors.green.shade400,
                          selected: _valueMeal == index,
                          // selected: false,
                          onSelected: (bool selected) {
                            setState(() {
                              _valueMeal = selected ? index : null;
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
                  "Accomodation only for",
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
                child: Wrap(
                  // list of length 3
                  children: List.generate(
                    3,
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
                            getAccLabel(index),
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          selectedColor: Colors.green.shade400,
                          selected: _valueAcc == index,
                          // selected: false,
                          onSelected: (bool selected) {
                            setState(() {
                              _valueAcc = selected ? index : null;
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
                padding: EdgeInsets.only(
                  top: 25.0,
                  bottom: 10.0,
                ),
                child: Text(
                  "Add some photos of Aashray (Max 3)",
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
                        imageFileList?.clear();

                        List<XFile>? selectedImages =
                            await imagePicker.pickMultiImage();
                        if (selectedImages.isNotEmpty) {
                          imageFileList!.addAll(
                            selectedImages,
                          );
                        }
                        // print("Image List Length:" + imageFileList!.length.toString());
                        setState(() {});
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

              SizedBox(
                child: ListView.builder(
                  itemCount:
                      imageFileList!.length < 3 ? imageFileList!.length : 3,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Container(
                        color: Colors.black,
                        height: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.all(
                            1.0,
                          ),
                          child: SizedBox(
                            child: Image.file(
                              File(
                                imageFileList![index].path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: 80.0,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: (() => uploadData(_valueRooms, _valueBeds,
                      _valueAcc, _valueMeal, imageFileList)),
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
            ],
          ),
        ),
      ),
    );
  }

  String getLabel(int index) {
    index++;
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
      default:
        return "Null";
    }
  }

  String getMealsLabel(int index) {
    switch (index) {
      case 0:
        return "No";
      case 1:
        return "Once a day";
      case 2:
        return "Twice a day";
      default:
        return "Null";
    }
  }

  String getAccLabel(int index) {
    switch (index) {
      case 0:
        return "Family only";
      case 1:
        return "Boys only";
      case 2:
        return "Girls only";
      default:
        return "Null";
    }
  }

  uploadData(int? valueRooms, int? valueBeds, int? valueAcc, int? valueMeal,
      List<XFile>? imageFileList) async {
    if (valueRooms != null &&
        valueBeds != null &&
        valueAcc != null &&
        valueMeal != null &&
        imageFileList!.isNotEmpty) {
      setState(() {
        _loading = true;
      });

      List<String> imageList = [];

      for (int i = 0; i < imageFileList.length; i++) {
        imageList.add(imageFileList[i].path);
      }

      // URL
      List<String> imageURLList = [];

      // UID
      final User? user = FirebaseAuth.instance.currentUser;
      String userId = user!.uid;

      for (int i = 0; i < imageList.length; i++) {
        Reference reference =
            FirebaseStorage.instance.ref("$userId/").child("$i.jpg");
        UploadTask uploadTask = reference.putFile(File(imageList[i]));
        TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() {}));
        String url = await downloadUrl.ref.getDownloadURL();
        imageURLList.add(url);
      }

      FirebaseFirestore.instance.collection("Aashrays").doc(userId).update(
        {
          "Rooms": getLabel(valueRooms),
          "Beds": getLabel(valueBeds),
          "Meals": getMealsLabel(valueMeal),
          "Accomodation": getAccLabel(valueAcc),
          "ImageLists": imageURLList,
        },
      ).whenComplete(
        () {
          setState(
            () {
              _loading = false;
            },
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProvideAashrayFour(),
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
    } else {
      Fluttertoast.showToast(
        msg: "Check again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
