import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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
    light: vector.Vector3(-0.5, -0.5, 0.5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Point Cloud Data Visualization"),
      ),
      body: SafeArea(
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
                    defaultPointWidth: 2,
                    supportZIndex: true,
                  ),
                ),
              ),
            ),
            // Text('visualizer'),
          ],
        ),
      ),
    );
  }
}
