import 'dart:async';
import 'dart:math';

import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart' as colorcode;
import 'package:vector_math/vector_math_64.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = DiTreDiController(
    rotationX: 0,
    rotationY: 0,
    rotationZ: 0,
  );

  PointPlane3D mPlane =
      PointPlane3D(1, Axis3D.y, 0.1, Vector3(0, 0, 0), pointWidth: 5);

  late List<Point3D> gPointcloud;

  double gPressedCount = 0;

  bool gButtonPressed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init');
    gPointcloud = [];
  }

  //timer
  late Timer gTimer;
  void initTimer() {
    gTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateForTimer(timer);
    });
    // setState(() {});
  }

  List<Point3D> _generatePoints() {
    List<Point3D> lists = [];
    print('generate points');
    double x;
    double y;
    double z;
    Color colors;
    for (var i = 0; i < 10000; i++) {
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

  void updateForTimer(Timer timer) {
    // gPointcloud.clear();
    // if (gPointcloud.isNotEmpty) gPointcloud.clear();
    gPointcloud = _generatePoints();
    print('check size : ${gPointcloud.length}');
    setState(() {});
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
                        print('pressed');
                        // gPressedCount++;
                        setState(() {
                          gButtonPressed = !gButtonPressed;
                          if (gButtonPressed) {
                            initTimer();
                          } else {
                            if (gTimer.isActive) {
                              gTimer.cancel();
                            }
                          }
                        });
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
                          // mPlane,
                          // PointCloud3D(gPointcloud, Vector3(0, 0, 0),
                          //     color: colorcode.Colors.green, pointWidth: 5),
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
