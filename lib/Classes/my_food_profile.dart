// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:aashray/Classes/provide_food/provide_food_one.dart';
import 'package:aashray/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFoodProfile extends StatefulWidget {
  const MyFoodProfile({super.key});

  @override
  State<MyFoodProfile> createState() => _MyFoodProfileState();
}

class _MyFoodProfileState extends State<MyFoodProfile> {
  final User? user = FirebaseAuth.instance.currentUser;
  // uid
  late String _userId;
  late bool _valueSwitch = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _userId = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Food Providers")
              .where("userID", isEqualTo: _userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.green,
                ),
              );
            } else if (snapshot.data?.size == 0) {
              return const Center(
                  child: Text("No Food provider details found!"));
            } else {
              return ListView(
                shrinkWrap: true,
                primary: false,
                children: snapshot.data!.docs.map(
                  (documents) {
                    return Card(
                      color: Colors.grey.shade100,
                      elevation: 3.0,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/teamwork-in-homeless-shelter-royalty-free-image-1608327313.?crop=1.00xw:0.755xh;0,0.142xh&resize=1200:*",
                                  ),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 10.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: ListTile(
                                  leading: null,
                                  title: Text(
                                    "\t\tProvide Food",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: CupertinoSwitch(
                                    value: _valueSwitch,
                                    activeColor: Colors.green.shade300,
                                    trackColor: Colors.white,
                                    thumbColor: _valueSwitch
                                        ? Colors.green.shade900
                                        : Colors.red,
                                    onChanged: (value) {
                                      setState(() {
                                        _valueSwitch = !_valueSwitch;
                                      });
                                    },
                                  ),
                                  contentPadding: EdgeInsets.all(2.0),
                                  onTap: () {
                                    setState(
                                      () {
                                        _valueSwitch = !_valueSwitch;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "Food Provider:\t\t" +
                                    documents["Name"].toString(),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "Mobile No.:\t\t" +
                                    documents["Mobile"].toString(),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 15.0,
                              ),
                              child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "Address:\t\t" +
                                    documents["Address"].toString(),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "Meal type:\t\t" +
                                    documents["Meal Type"].toString(),
                                style: const TextStyle(
                                  fontSize: 17.5,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "Average capacity to feed:\t\t" +
                                    documents["Average"].toString() +
                                    "\t people",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "Preferred Dates:\n" +
                                    documents["Initial Date"].toString() +
                                    " to " +
                                    documents["End Date"].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 28.0,
                                  bottom: 10.0,
                                  // left: 10.0,
                                  // right: 10.0,
                                ),
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        // Login
                                        builder: (context) =>
                                            const ProvideFoodOne(),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 2.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      "Edit Details",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  // left: 10.0,
                                  // right: 10.0,
                                ),
                                child: OutlinedButton(
                                  onPressed: () => deleteFoodProfile(),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 2.0,
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      "Delete Food Profile",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
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
                  },
                ).toList(),
              );
            }
          },
        ),
      ),
    );
  }

  deleteFoodProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Your food profile?"),
          content: const Text("Confirm deleting the Profile."),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  width: 2.0,
                  color: Colors.green,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                var docRef = FirebaseFirestore.instance
                    .collection("Food Providers")
                    .doc(_userId);

                docRef.delete().whenComplete(
                  () async {
                    final sharedPrefs = await SharedPreferences.getInstance();
                    await sharedPrefs.setString("screenName", "AashrayDefault");

                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        // Main
                        builder: (context) => const Splashscreen(),
                      ),
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  width: 2.0,
                  color: Colors.red,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
