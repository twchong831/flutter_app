import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:object_3d/object_3d.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:web_prodution_page/production_detail.dart';

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
  late ProductionDetailWidget tableWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tableWidget = ProductionDetailWidget(
      name: const [
        'Num. of Channels',
        'Light Source',
        'HFoV & Resolution',
        'VFoV & Resolution',
        'Scanning Frequency',
        'Detection Range',
        'Operating Temperature',
        'Input Voltage',
        'Dimension[mm]',
        'Field of Application'
      ],
      value: const [
        '2 Channels',
        '905nm Eye-Safety Class 1',
        '120',
        '3',
        '15Hz (Max)',
        '0.25 ~ 70.0 m (Max)',
        '-40 ~ 85',
        '10 ~ 32 V DC',
        '102 x 65 x 57',
        'ADAS, Safety, SLAM, Drone, Robot',
      ],
      background_: Colors.grey,
    );

    print('check size ${tableWidget.getWidgetSize()}');
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

  @override
  Widget build(BuildContext context) {
    final cubes_ = _generateCubes();
    final controller_ = DiTreDiController(
      rotationX: -20,
      rotationY: 30,
      light: vector.Vector3(-0.5, -0.5, 0.5),
    );

    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.grey,
              child: SizedBox(
                height: 350,
                width: 200,
                child: DiTreDiDraggable(
                  controller: controller_,
                  child: DiTreDi(
                    figures: cubes_.toList(),
                    controller: controller_,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          children: [
            SizedBox(
              // width: tableWidget.getWidgetSize()!.width,
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.red,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            tableWidget,
          ],
        ),
      ],
    );
  }
}
