// import 'package:ditredi/ditredi.dart';

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pointcloud_data_viewer/ditredi_/kanavi_ditredi.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/gird_3d.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/guid_axis_3d.dart';
import 'package:flutter/src/material/colors.dart' as colorcode;
import 'package:pointcloud_data_viewer/ditredi_/model/point_cloud_3d.dart';
import 'package:vector_math/vector_math_64.dart';
// import 'package:flutter/src/material/colors.dart' as colorcode;

class PcdVisualizer extends StatefulWidget {
  List<Point3D> outputPointCloud = [];
  final bool checkedUpdateCloud;
  PcdVisualizer({
    super.key,
    required this.outputPointCloud,
    this.checkedUpdateCloud = false,
  });

  bool checkedUpdatePointCloud = false;
  void updatedPointCloud(List<Point3D> pc) {
    outputPointCloud = pc;
    checkedUpdatePointCloud = true;
  }

  // late Timer timerUpdate;

  @override
  State<PcdVisualizer> createState() => _PcdVisualizerState();
}

class _PcdVisualizerState extends State<PcdVisualizer> {
  late Timer timerUpdate;
  List<Point3D> vsPc = [];

  final _controller = DiTreDiController(
    rotationX: 0,
    rotationY: 180,
    rotationZ: 0,
    // light: vector.Vector3(-0.5, -0.5, 0.5),
    maxUserScale: 5.0,
    minUserScale: 0.05,
  );

  late KanaviDiTreDi mViewer;

  @override
  void initState() {
    super.initState();
    if (widget.checkedUpdateCloud) {
      _timerInit();
    } else {
      vsPc = widget.outputPointCloud;
    }
    // pointcloudModel = widget.outputPointCloud;
  }

  void _onTimerFunc(Timer timer) {
    // mount check
    if (mounted) {
      setState(() {
        print("pcdVisual Timer active");
        vsPc = widget.outputPointCloud;
      });
    } else {
      print('unmounted Timer cancel');
      timer.cancel();
    }
  }

  void _timerInit() {
    timerUpdate = Timer.periodic(
        const Duration(microseconds: 40), (timer) => _onTimerFunc(timer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Point Cloud Data Visualization"),
      ),
      body: Container(
        color: const Color.fromARGB(255, 2, 2, 80), //set background
        child: SafeArea(
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              Expanded(
                child: DiTreDiDraggable(
                    controller: _controller,
                    rotationEnabled: true,
                    scaleEnabled: true,
                    child: mViewer = KanaviDiTreDi(
                      figures: [
                        PointCloud3D(vsPc, Vector3(0, 0, 0), pointWidth: 3),
                        Grid3D(const Point(10, 15), const Point(-10, 0), 1,
                            lineWidth: 1,
                            color: colorcode.Colors.white.withOpacity(0.6)),
                        GuideAxis3D(1, lineWidth: 10),
                      ],
                      controller: _controller,
                      // bounds: Aabb3(),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
