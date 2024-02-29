import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_prodution_page/dynamicDitredi/dynamic_ditredi.dart';
import 'package:web_prodution_page/prodution_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // timer for check
  late Timer timer;
  // checker for modeling file load
  bool checker = false;
  // sensor modeling
  late Mesh3D modelSensor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // get file
    checker = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getModeling(timer);
    });
  }

  void getModeling(Timer timer) async {
    modelSensor =
        Mesh3D(await ObjParser().loadFromResources("model/sensor_ex.obj"));
    setState(() {
      if (modelSensor.figures.isNotEmpty) {
        checker = true;
      }
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Production Page REF."),
        backgroundColor: Colors.blue,
      ),
      body: checker
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // Text('chair'),
                  Container(
                    color: Colors.lightBlueAccent[100]!.withAlpha(40),
                    child: ProductionPage(
                      name: 'LiDAR',
                      model: modelSensor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.grey[100],
                    child: ProductionPage(
                      name: 'LiDAR2',
                      model: modelSensor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          : Center(
              child: LoadingAnimationWidget.beat(
                color: Colors.blue,
                size: 300,
              ),
            ),
    );
  }
}
