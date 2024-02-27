import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'package:object_3d/object_3d.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ProductionPage extends StatefulWidget {
  final String name;

  const ProductionPage({
    super.key,
    required this.name,
  });

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final _controller = DiTreDiController(
    rotationX: -20,
    rotationY: 30,
    light: vector.Vector3(-0.5, -0.5, 0.5),
  );

  late final List<Face3D> chairModel;

  late final Iterable<Cube3D> _cubes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // chairModel = await ObjParser().loadFromResources('model/chair.obj').timeout(const Duration(seconds: 1),);
    // print('check ${chairModel.length}');

    // _cubes = _generateCubes();
  }

  Iterable<Cube3D> _generateCubes() sync* {
    final colors = [
      Colors.grey.shade200,
      Colors.grey.shade300,
      Colors.grey.shade400,
      Colors.grey.shade500,
      Colors.grey.shade600,
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade900,
    ];
    const count = 8;
    for (var x = count; x > 0; x--) {
      for (var y = count; y > 0; y--) {
        for (var z = count; z > 0; z--) {
          yield Cube3D(
            0.9,
            vector.Vector3(
              x.toDouble() * 2,
              y.toDouble() * 2,
              z.toDouble() * 2,
            ),
            color: colors[(colors.length - y) % colors.length],
          );
        }
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Flex(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       direction: Axis.vertical,
  //       children: [
  //         Expanded(
  //           child: DiTreDiDraggable(
  //             controller: _controller,
  //             child: DiTreDi(
  //               figures: _cubes.toList(),
  //             ),
  //           ),
  //         ),
  //       ]);
  // }

  @override
  Widget build(BuildContext context) {
    // return O3D(
    //   src: 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
    //   controller: O3DController(),
    // );
    return Object3D(
      size: Size(400, 400),
      path: 'model/chair2.obj',
    );
  }
}
