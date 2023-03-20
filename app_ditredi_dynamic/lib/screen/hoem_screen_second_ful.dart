import 'dart:async';
import 'dart:math';

import 'package:app_ditredi_dynamic/ditredi_/kanavi_ditredi.dart';
import 'package:app_ditredi_dynamic/ditredi_/karnavi_canvas_model_painter.dart';
import 'package:app_ditredi_dynamic/td_widget.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart' as colorcode;

class HomeSecondFUl extends StatefulWidget {
  const HomeSecondFUl({super.key});

  @override
  State<HomeSecondFUl> createState() => _HomeSecondFUlState();
}

class _HomeSecondFUlState extends State<HomeSecondFUl> {
  final _controller = DiTreDiController(
    rotationX: 0,
    rotationY: 0,
    rotationZ: 0,
    maxUserScale: 4.0,
    minUserScale: 0.1,
  );

  bool gButtonPressed = false;

  final DiTreDiConfig gConfig = const DiTreDiConfig();
  final Aabb3 gBounds = Aabb3.minMax(Vector3(0, 0, 0), Vector3(1, 1, 1));

  late List<Point3D> gPointcloud;

  int timerTickCount = 0;

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

  KModelPainter? gModelPainter;

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
    setState(() {
      print('update state');
      gModelPainter!.figures = gPointcloud; // how? check no memory increase!!
      timerTickCount = timer.tick;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gPointcloud = _generatePoints();
    gModelPainter = KModelPainter(
      gPointcloud,
      gBounds,
      _controller,
      gConfig,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DYnamic Test $timerTickCount'),
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
                        setState(() {
                          gButtonPressed = !gButtonPressed;
                          print('pressed $gButtonPressed');

                          if (gButtonPressed) {
                            timerInit();
                          } else {
                            if (gTimer!.isActive) gTimer!.cancel();
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
                child: TdWidget(
                  // figures: gPointcloud,
                  // bounds: Aabb3.minMax(Vector3(0, 0, 0), Vector3(1, 1, 1)),
                  controller: _controller,
                  mPainter: gModelPainter!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
