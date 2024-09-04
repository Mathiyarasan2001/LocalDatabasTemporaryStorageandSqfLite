import 'package:flutter/material.dart';
import 'package:testtask1/Screens/homeScreen.dart';
import 'package:testtask1/Screens/selectScreens.dart';
import 'package:testtask1/Services/sqfLiteHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter TODO LIST',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SelectScreen(),
    );
  }
}
