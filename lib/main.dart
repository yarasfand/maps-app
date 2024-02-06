import 'package:flutter/material.dart';
import 'package:mapsdoing/home/openMaps.dart';
import 'package:mapsdoing/home/homebody.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
