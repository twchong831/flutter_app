import 'package:app_ditredi_dynamic/screen/hoem_screen_second_ful.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // home: const HomeScreen(), // increase memory when dynamic Update
      home: const HomeSecondFUl(), // not Increase memory when dynamic Update.
    );
  }
}
