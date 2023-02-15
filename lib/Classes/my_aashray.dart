import 'package:flutter/material.dart';

class MyAashray extends StatefulWidget {
  const MyAashray({super.key});

  @override
  State<MyAashray> createState() => _MyAashrayState();
}

class _MyAashrayState extends State<MyAashray> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("My Aashray"),
      ),
    );
  }
}
