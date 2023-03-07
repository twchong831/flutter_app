import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointcloud_data_viewer/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PointCloud Data Viewer',
      theme: ThemeData(),
      home: const HomeScreen(),
    );
  }
}
