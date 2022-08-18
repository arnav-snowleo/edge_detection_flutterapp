import 'package:flutter/material.dart';
import 'package:opencv_canny_test/home.dart';

void main() {
  runApp(const PlotlineApp());
}

class PlotlineApp extends StatelessWidget {
  const PlotlineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edge detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Home(title: 'Edge detection'),
    );
  }
}
