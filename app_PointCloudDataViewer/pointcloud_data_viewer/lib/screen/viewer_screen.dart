import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointcloud_data_viewer/ditredi_/kanavi_ditredi.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/gird_3d.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/guid_axis_3d.dart';
import 'package:pointcloud_data_viewer/ditredi_/model/point_cloud_3d.dart';
import 'package:pointcloud_data_viewer/files/pcd_reader.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/src/material/colors.dart' as colorcode;

enum ReadMode {
  udp,
  fileList,
}

class ViewScreen extends StatefulWidget {
  final String? ip;
  final int? port;
  final List<String>? pcdList;
  final DiTreDiController _ditreControl;

  ViewScreen({
    super.key,
    this.ip,
    this.port,
    this.pcdList,
    DiTreDiController? ditreControl,
  }) : _ditreControl = ditreControl ??
            DiTreDiController(
              rotationX: 0,
              rotationY: 180,
              rotationZ: 0,
              // light: vector.Vector3(-0.5, -0.5, 0.5),
              maxUserScale: 5.0,
              minUserScale: 0.05,
            );

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  // point cloud view config
  PCDReader pcdReader = PCDReader(path: '');
  late Timer mTimerPlay;
  bool checkedTimer = false;
  int gTimerCount = 0;

  late final ReadMode? readMode;
  String selectFile = '';

  List<Point3D> gPointCloud = [];

  void _updatePointCloud(List<Point3D> input) {
    if (mounted) {
      setState(() {
        gPointCloud = input;
      });
    }
  }

  void _loadPcdFile(String path) async {
    List<Point3D> pc = await pcdReader.read(path);
    _updatePointCloud(pc);
  }

  void _playTimer(Timer time) async {
    // print("timer active");
    List<Point3D> pc = await pcdReader.read(widget.pcdList![gTimerCount]);
    _updatePointCloud(pc);
    gTimerCount++;

    if (gTimerCount > widget.pcdList!.length - 1) {
      gTimerCount = 0;
    }
  }

  void _timerActive() {
    print('timer active for play');

    if (!checkedTimer) {
      mTimerPlay = Timer.periodic(
        const Duration(milliseconds: 30),
        (timer) => _playTimer(timer),
      );
      checkedTimer = true;
    }
  }

  void _cancelTimer() {
    if (checkedTimer) {
      print('timer cancel');
      mTimerPlay.cancel();
      checkedTimer = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.ip != null && widget.port != null) {
      readMode = ReadMode.udp;
    } else if (widget.pcdList != null) {
      readMode = ReadMode.fileList;
      selectFile = widget.pcdList![0];
      if (widget.pcdList!.length == 1) {
        _loadPcdFile(selectFile);
      } else if (widget.pcdList!.length > 1) {
        _timerActive();
      } else {}
    } else {
      // printError('Please Resetting parameters');
      // print("re parameter");
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (readMode == ReadMode.fileList) {
      _cancelTimer();
    }
    // print('return val');
    // Get.back(result: widget._ditreControl);
    super.dispose();
  }

  String setTitle() {
    String val;

    if (readMode == ReadMode.udp) {
      val = 'UDP [${widget.ip}/${widget.port}]';
    } else if (readMode == ReadMode.fileList) {
      if (widget.pcdList?.length == 1) {
        List sp = selectFile.split('/');
        val = 'File [ ${sp[sp.length - 1]} ]';
      } else {
        val = 'File [Count : $gTimerCount/${widget.pcdList?.length}]';
      }
    } else {
      val = 'none';
    }

    return val;
  }

  _visualizer(
    BuildContext contex, {
    required figure,
    required controller,
  }) {
    return KDiTreDi(
      figures: figure,
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(setTitle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back(result: widget._ditreControl);
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 2, 2, 80), //set background
        child: SafeArea(
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              Expanded(
                child: KDiTreDiDraggable(
                  controller: widget._ditreControl,
                  rotationEnabled: true,
                  scaleEnabled: true,
                  child: _visualizer(
                    context,
                    figure: [
                      PointCloud3D(gPointCloud, Vector3(0, 0, 0),
                          pointWidth: 3),
                      Grid3D(const Point(10, 15), const Point(-10, 0), 1,
                          lineWidth: 1,
                          color: colorcode.Colors.white.withOpacity(0.6)),
                      GuideAxis3D(1, lineWidth: 10),
                    ],
                    controller: widget._ditreControl,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
