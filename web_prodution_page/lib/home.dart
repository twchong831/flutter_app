import 'package:flutter/material.dart';
import 'package:web_prodution_page/prodution_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Production Page"),
        backgroundColor: Colors.blue,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            // Text('chair'),
            ProductionPage(name: 'LiDAR'),
          ],
        ),
      ),
    );
  }
}
