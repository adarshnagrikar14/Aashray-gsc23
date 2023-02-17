// ignore_for_file: use_build_context_synchronously

import 'package:aashray/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? user = FirebaseAuth.instance.currentUser;
  late String _name;
  late String _email;
  late String _profile;
  late String _number;

  // init
  @override
  void initState() {
    super.initState();

    setState(() {
      _name = user!.displayName!;
      _email = user!.email!;
      _profile = user!.photoURL!;
      _number = "";
    });

    getUserNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text("Profile"),
        actions: [
          // settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: GestureDetector(
              child: const Tooltip(
                triggerMode: TooltipTriggerMode.longPress,
                message: "Send Feedback",
                child: Icon(
                  Icons.feedback_rounded,
                  size: 25.0,
                ),
              ),
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Sending feedback",
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
            // Profile Image
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 15.0,
              ),
              child: CircleAvatar(
                radius: 30.0,
                child: CircleAvatar(
                  radius: 29.0,
                  child: ClipOval(
                    child: Image.network(
                      _profile,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Name
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Name",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
              child: Text(
                _name,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),

            // Gmail
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Gmail",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
              child: Text(
                _email,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),

            // Gmail
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Mo. Number",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
              child: Text(
                _number,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),

            const Spacer(),

            const Center(
              child: Text(
                "Logout from this specific device.\n",
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: ElevatedButton(
                  onPressed: (() async {
                    GoogleSignIn googleSignIn = GoogleSignIn();

                    await FirebaseAuth.instance.signOut();
                    await googleSignIn.signOut();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Splashscreen(),
                      ),
                      ModalRoute.withName("/Classes"),
                    );

                    // Toast msg
                    Fluttertoast.showToast(
                      msg: "Logout Successful",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                        textAlign: TextAlign.center,
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

  void getUserNumber() {
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
        });
      }
    }).onError((error, stackTrace) => null);
  }
}
