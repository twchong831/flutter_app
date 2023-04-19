import 'package:flutter/material.dart';
import 'package:web_embedded/screen/home_screen_tab.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // return const LoadScreen();
    return const HomeScreenTab();
  }
}
