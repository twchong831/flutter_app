// import 'package:ditredi/ditredi.dart';
import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';

class PcdVisualizer extends StatefulWidget {
  List<Point3D> outputPointCloud = [];
  PcdVisualizer({
    super.key,
    required this.outputPointCloud,
  });

  @override
  State<PcdVisualizer> createState() => _PcdVisualizerState();
}

class _PcdVisualizerState extends State<PcdVisualizer> {
  final _controller = DiTreDiController(
    rotationX: 0,
    rotationY: 0,
    rotationZ: 0,
    // light: vector.Vector3(-0.5, -0.5, 0.5),
    maxUserScale: 5.0,
    minUserScale: 0.05,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Point Cloud Data Visualization"),
      ),
      body: Container(
        color: const Color.fromARGB(255, 2, 2, 80),
        child: SafeArea(
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              Expanded(
                child: DiTreDiDraggable(
                  controller: _controller,
                  child: DiTreDi(
                    figures: widget.outputPointCloud,
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
