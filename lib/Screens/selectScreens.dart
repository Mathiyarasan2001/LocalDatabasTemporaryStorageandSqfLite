import 'package:flutter/material.dart';
import 'package:testtask1/Screens/homeScreen.dart';
import 'package:testtask1/Screens/sqfLite.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => sqfLite(),
                    ));
              },
              child: Text("SQFLITE")),
          const SizedBox(height: 50,),
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
              child: Text("LOCALDATABASE")),
        ],
      ),
    );
  }
}
