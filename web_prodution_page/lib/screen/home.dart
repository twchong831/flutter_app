import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_prodution_page/database/production/production_inform.dart';
import 'package:web_prodution_page/dynamicDitredi/dynamic_ditredi.dart';
import 'package:web_prodution_page/screen/prodution_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // timer for check
  late Timer timer;
  // sensor modeling
  late Mesh3D modelSensor;
  // sensor detail information
  List<LiDARInformation> itemDetailList = [];

  bool checker = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checker = false;
    // get modeling data from file
    getModeling();

    // read json for lidar sensor detail information
    readJsonConfig();

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      checkAllParameterLoading(timer);
    });
  }

  Future<void> getModeling() async {
    modelSensor =
        Mesh3D(await ObjParser().loadFromResources("model/sensor_ex.obj"));
  }

  Future<void> readJsonConfig() async {
    final String result = await rootBundle.loadString('sensors.json');
    // print('check 2 : $result');
    setState(() {
      if (result.isNotEmpty) {
        // checker = true;
        itemDetailList = ProductionInformList.fromJson(result).lists ?? [];
        // timer.cancel();
      } else {
        itemDetailList = [];
      }
    });
  }

  void checkAllParameterLoading(Timer timer_) {
    setState(() {
      if (itemDetailList.isNotEmpty && modelSensor.figures.isNotEmpty) {
        // return true;
        checker = true;
        timer_.cancel();
      } else {
        // return false;
        checker = false;
      }
    });
  }

  bool checkOddEven(int i) {
    if (i % 2 == 0) {
      return true;
    } else {
      return false;
    }
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
                  for (int i = 0; i < itemDetailList.length; i++)
                    Container(
                      color: checkOddEven(i)
                          ? Colors.lightBlueAccent[100]!.withAlpha(40)
                          : Colors.grey[100],
                      child: ProductionPage(
                        model: modelSensor,
                        inform: itemDetailList[i],
                        evens_: checkOddEven(i),
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
