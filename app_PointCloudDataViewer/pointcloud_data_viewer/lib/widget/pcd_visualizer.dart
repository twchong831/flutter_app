// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:pointcloud_data_viewer/ditredi_/kanavi_ditredi_stateful.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/gird_3d.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/guid_axis_3d.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/point_cloud_3d.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/src/material/colors.dart' as colorcode;
// import 'package:flutter/src/material/colors.dart' as colorcode;

class ReactiveController extends GetxController {
  static ReactiveController get to => Get.find();
}

class PcdVisualizer extends StatefulWidget {
  List<Point3D> pointCloud;
  final bool checkedUpdateCloud;
  final DiTreDiController controller;

  PcdVisualizer({
    super.key,
    required this.pointCloud,
    DiTreDiController? controller,
    this.checkedUpdateCloud = false,
  }) : controller = controller ??
            DiTreDiController(
              rotationX: 0,
              rotationY: 180,
              rotationZ: 0,
              // light: vector.Vector3(-0.5, -0.5, 0.5),
              maxUserScale: 5.0,
              minUserScale: 0.05,
            );

  late KanaviDiTreDiFul mViewer;

  DiTreDiController getBeforeViewPoint() {
    // return List.empty();
    return mViewer.getBeforeViewPoint();
  }

  // @override
  // State<PcdVisualizer> createState() => _PcdVisualizerState();

  @override
  State<PcdVisualizer> createState() => _PcdVisualizerState();

  // void updatedPointCloud(List<Point3D> pc) =>
  //     pcdVisualizerState.updatedPointCloud(pc);
  // void updatedPointCloud(List<Point3D> pc) {
  //   pointCloud = pc;
  // }
}

class _PcdVisualizerState extends State<PcdVisualizer> {
  late Timer timerUpdate;
  List<Point3D> vsPc = [];

  @override
  void initState() {
    super.initState();
    if (widget.checkedUpdateCloud) {
      // _timerInit();
    }
    vsPc = widget.pointCloud;
    print('pcdVisual : init : ${widget.pointCloud.length}');
  }

  _visualizer(
    BuildContext contex, {
    required figure,
    required controller,
  }) {
    return widget.mViewer = KanaviDiTreDiFul(
      figures: figure,
      controller: controller,
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }

  void updatedPointCloud(List<Point3D> pc) {
    print('update $mounted ${pc.length}');
    if (mounted) {
      setState(() {
        vsPc = pc;
      });
    } else {
      print("unmounted,..");
    }
  }

  void _onTimerFunc(Timer timer) {
    // mount check
    // if (mounted) {
    //   setState(() {
    //     print("pcdVisual Timer active");
    //     vsPc = widget.pointCloud;
    //   });
    // } else {
    //   print('unmounted Timer cancel');
    //   timer.cancel();
    // }
    if (mounted) {
      setState(() {
        print('only check mounted? $mounted');
      });
    }
  }

  void _timerInit() {
    timerUpdate = Timer.periodic(
      // const Duration(microseconds: 40),
      const Duration(seconds: 1),
      (timer) => _onTimerFunc(timer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 2, 2, 80), //set background
      child: SafeArea(
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            Expanded(
              child: DiTreDiDraggable(
                controller: widget.controller,
                rotationEnabled: true,
                scaleEnabled: true,
                child: _visualizer(
                  context,
                  figure: [
                    PointCloud3D(vsPc, Vector3(0, 0, 0), pointWidth: 3),
                    Grid3D(const Point(10, 15), const Point(-10, 0), 1,
                        lineWidth: 1,
                        color: colorcode.Colors.white.withOpacity(0.6)),
                    GuideAxis3D(1, lineWidth: 10),
                  ],
                  controller: widget.controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
