import 'dart:async';
import 'dart:math';

import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart' as colorcode;

class HomeSecond extends StatelessWidget {
  HomeSecond({super.key});

  final _controller = DiTreDiController(
    rotationX: 0,
    rotationY: 0,
    rotationZ: 0,
  );

  bool gButtonPressed = false;

  late List<Point3D> gPointcloud = _generatePoints();

  List<Point3D> _generatePoints() {
    List<Point3D> lists = [];
    print('generate points');
    double x;
    double y;
    double z;
    Color colors;
    int num = 10000;

    if (gTimer != null) {
      if (gTimer!.tick.toInt() % 2 == 0) {
        num = 5000;
      }
    } else {}
    for (var i = 0; i < num; i++) {
      x = Random().nextDouble();
      y = Random().nextDouble();
      z = Random().nextDouble();
      if (((x * 100).toInt() + (y * 100).toInt() + (z * 100).toInt()) % 2 ==
          0) {
        colors = colorcode.Colors.green;
      } else if (((x * 100).toInt() + (y * 100).toInt() + (z * 100).toInt()) %
              3 ==
          0) {
        colors = colorcode.Colors.yellow;
      } else {
        colors = colorcode.Colors.white;
      }

      lists.add(Point3D(
        Vector3(x, y, z),
        color: colors,
        width: 10,
      ));
    }
    return lists;
  }

  Timer? gTimer;

  void timerInit() {
    gTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        timerFunc(timer);
      },
    );
    print('timer active');
  }

  void timerFunc(Timer timer) {
    print('timer...${timer.tick}');
    gPointcloud = _generatePoints();
    print('update point cloud ${gPointcloud.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DYnamic Test'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 5, 5, 58),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                color: colorcode.Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        gButtonPressed = !gButtonPressed;
                        print('pressed $gButtonPressed');

                        if (gButtonPressed) {
                          timerInit();
                        } else {
                          if (gTimer!.isActive) gTimer!.cancel();
                        }
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return colorcode.Colors.red.withOpacity(0.8);
                            }
                            return colorcode.Colors.transparent;
                          },
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        backgroundColor:
                            MaterialStateProperty.all(colorcode.Colors.blue),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            gButtonPressed
                                ? Icons.play_circle_fill_outlined
                                : Icons.pause_circle_outline_outlined,
                            size: 50,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DiTreDiDraggable(
                  controller: _controller,
                  child: DiTreDi(
                    controller: _controller,
                    figures: [
                          Point3D(Vector3(0, 0, 0),
                              color: colorcode.Colors.red, width: 30),
                        ] +
                        gPointcloud,
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
