// import 'package:ditredi/ditredi.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pointcloud_data_viewer/ditredi_/kanavi_ditredi.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/gird_3d.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/guid_axis_3d.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/point_cloud_3d.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/src/material/colors.dart' as colorcode;
// import 'package:flutter/src/material/colors.dart' as colorcode;

class PcdVisualizer extends StatefulWidget {
  List<Point3D> outputPointCloud = [];
  final bool updated;
  PcdVisualizer({
    super.key,
    required this.outputPointCloud,
    required this.updated,
  });

  // void pointCloudUpdate(List<Point3D> pc) {
  //   outputPointCloud = pc;
  // }

  @override
  State<PcdVisualizer> createState() => _PcdVisualizerState();

  void updatedPointCloud(List<Point3D> pointCloud) {
    outputPointCloud = pointCloud;
    print('call pcd_visual updated');
  }
}

class _PcdVisualizerState extends State<PcdVisualizer> {
  bool checkedUpdate = false;

  final _controller = DiTreDiController(
    rotationX: 0,
    rotationY: 180,
    rotationZ: 0,
    // light: vector.Vector3(-0.5, -0.5, 0.5),
    maxUserScale: 5.0,
    minUserScale: 0.05,
  );

  @override
  void initState() {
    super.initState();
    // pointcloudModel = widget.outputPointCloud;
  }

  // void updatedPointCloud(List<Point3D> pc) {
  //   print('call pcd_visual updatedPointCloud');
  //   setState(() {
  //     print("update cloud : ${pc.length}");
  //     widget.outputPointCloud = pc;
  //     checkedUpdate = true;
  //   });
  // }

  bool _checkUpdate() {
    setState(() {});
    return widget.updated;
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
                  child: KanaviDiTreDi(
                    // figures: (widget.outputPointCloud),
                    // output list<point3d>
                    figures: [
                      _checkUpdate()
                          ? PointCloud3D(
                              widget.outputPointCloud,
                              Vector3(0, 0, 0),
                              pointWidth: 4,
                              // color: colorcode.Colors.amber,
                            )
                          : PointCloud3D(
                              widget.outputPointCloud,
                              Vector3(0, 0, 0),
                              pointWidth: 4,
                              // color: colorcode.Colors.amber,
                            ),
                      Grid3D(const Point(10, 15), const Point(-10, 0), 1,
                          lineWidth: 1,
                          color: colorcode.Colors.white.withOpacity(0.6)),
                      GuideAxis3D(1, lineWidth: 10),
                    ],
                    controller: _controller,
                    config: const DiTreDiConfig(
                      defaultPointWidth: 3,
                      supportZIndex: true,
                      perspective: true,
                    ),
                  ),
                ),
              ),
              // Text('visualizer'),
            ],
          ),
        ),
      ),
    );
  }
}
