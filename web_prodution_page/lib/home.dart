import 'package:flutter/material.dart';
import 'package:object_3d/object_3d.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('chair'),
            Container(
              color: Colors.grey,
              child: SizedBox(
                height: 500,
                width: 500,
                child: ProductionPage(name: 'chair'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
