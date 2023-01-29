import 'package:aashray/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializing the firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // status bar color
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarIconBrightness: Brightness.light,
  //     statusBarColor: Colors.black,
  //     systemNavigationBarColor: Colors.black87,
  //   ),
  // );

  // Running app:
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aashray',
      home: const Splashscreen(), // Splashscreen First
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
