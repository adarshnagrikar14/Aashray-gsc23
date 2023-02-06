// ignore_for_file: use_build_context_synchronously

import 'package:aashray/Classes/mobilenumber.dart';
import 'package:aashray/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Initialize vars:
  final FirebaseAuth _authFirebase = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result =
          await _authFirebase.signInWithCredential(authCredential);
      // User? user = result.user;

      // ignore: unnecessary_null_comparison
      if (result != null) {
        // Toast msg
        Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // start activity
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileNumberAdd(),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Error occurred",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Customisation
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
        systemNavigationBarColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Login/Sign Up",
          style: TextStyle(
            fontSize: 22.0,
          ),
        ),
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 50.0,
          left: 10.0,
          right: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image

            Image.asset(
              "assets/images/login_image.jpg",
              height: 220.0,
            ),

            // Continue:

            const Text(
              "SIGN UP\nTo continue with Aashray",
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Button-login

            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                top: 150.0,
              ),
              child: ElevatedButton(
                onPressed: () => signup(context),
                style: ElevatedButton.styleFrom(
                  elevation: 2.0,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: SizedBox(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: const Center(
                    child: Text(
                      'Continue SignUp',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Text:
            const Spacer(),
            const Text(
              "Login/ Sign up with a specific Google account to continue with the application.\n",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
