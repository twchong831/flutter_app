import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:web_prodution_page/database/production/production_inform.dart';
import 'package:web_prodution_page/dynamicDitredi/dynamic_canvas_model_painter.dart';
import 'package:web_prodution_page/dynamicDitredi/dynamic_ditredi.dart';
import 'package:web_prodution_page/dynamicDitredi/model/gird_3d.dart';
import 'package:web_prodution_page/dynamicDitredi/model/guid_axis_3d.dart';
import 'package:flutter/material.dart' as colorcode;
import 'package:web_prodution_page/widget/production_detail.dart';

class ProductionPage extends StatefulWidget {
  // final String name;
  final Mesh3D model;
  final LiDARInformation inform;
  final bool evens;

  const ProductionPage({
    super.key,
    // required this.name,
    required this.model,
    required this.inform,
    final bool? evens_,
  }) : evens = evens_ ?? false;

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  static double miniumScreenSizeWidth = 450;
  late ProductionDetailWidget tableWidget;

  // visualize target using ditredi
  List<Model3D<Model3D<dynamic>>> outputObject = [
    Grid3D(const Point(2, 2), const Point(-2, -2), 1,
        lineWidth: 1, color: colorcode.Colors.black),
    GuideAxis3D(1, lineWidth: 5),
  ];

  // define basic output
  final gridObj = Grid3D(const Point(2, 2), const Point(-2, -2), 1,
      lineWidth: 1, color: colorcode.Colors.black);
  final guidAxisObj = GuideAxis3D(1, lineWidth: 5);

  // define base size
  final vector.Vector3 size3D = vector.Vector3(1, 1, 0.7);

  // check dimension button is pushed
  late bool checkedDemisionFunc;
  late bool checkedVFoV;
  late bool checkedHFoV;

  DiTreDiController controller_ = DiTreDiController(
    rotationX: 60,
    rotationY: 180,
    rotationZ: 220,
    light: vector.Vector3(0.3, 0.3, 0.8),
    maxUserScale: 7.0,
    userScale: 5.0,
  );

  DiTreDiConfig viewConfig = const DiTreDiConfig();
  // set viewPoint Start
  final vector.Aabb3 initViewPoint = vector.Aabb3.minMax(
    vector.Vector3(-2, -2, 0),
    vector.Vector3(2, 2, 0),
  );

  // generate base output object
  void generateBaseObj() {
    if (outputObject.isNotEmpty) {
      outputObject.clear();
    }

    outputObject = [gridObj, guidAxisObj];
    outputObject.add(widget.model);

    checkedDemisionFunc = false;
    checkedVFoV = false;
    checkedHFoV = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    generateBaseObj();
    checkedDemisionFunc = false;
    checkedVFoV = false;
    checkedHFoV = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size baseSize = const Size(450, 450);
    const double baseFontSize = 45;
    // const double fontsizeName = 45;
    // const double fontsizeDetail = 28;

    DynamicCanvasModelPainter canvasModelPainter = DynamicCanvasModelPainter(
      outputObject,
      initViewPoint,
      controller_,
      viewConfig,
    );

    // Dimension Draw
    void drawDimension() {
      final dW = Line3D(
        vector.Vector3(size3D.x / 2, size3D.y / 2, 0),
        vector.Vector3(-size3D.x / 2, size3D.y / 2, 0),
        color: Colors.red,
        width: 3,
      );
      final dD = Line3D(
        vector.Vector3(size3D.x / 2, -size3D.y / 2, 0),
        vector.Vector3(size3D.x / 2, size3D.y / 2, 0),
        color: Colors.green,
        width: 3,
      );
      final dH = Line3D(
        vector.Vector3(size3D.x / 2, 0, size3D.z),
        vector.Vector3(size3D.x / 2, 0, 0),
        color: Colors.blue,
        width: 3,
      );

      if (!checkedDemisionFunc) {
        outputObject.add(dW);
        outputObject.add(dH);
        outputObject.add(dD);

        checkedDemisionFunc = true;
        controller_.update(
          rotationX: 60,
          rotationY: 180,
          rotationZ: 220,
          userScale: 5.0,
        );
      } else {
        generateBaseObj();
        checkedDemisionFunc = false;
      }

      setState(() {
        // update
        canvasModelPainter.update(
          control: controller_,
          fig: outputObject,
        );
      });
    }

    void drawHFoV() {
      Face3D fov = Face3D(
        vector.Triangle.points(
          vector.Vector3(0, 0, 0.3),
          vector.Vector3(0 - 2, 0 + 2, 0.3),
          vector.Vector3(0 + 2, 0 + 2, 0.3),
        ),
        color: Colors.amber,
      );

      if (!checkedHFoV) {
        outputObject.add(fov);

        checkedHFoV = true;
        controller_.update(
          rotationX: 180,
          rotationY: 0,
          rotationZ: 180,
          // viewScale: 0.5,
          userScale: 0.5,
        );
      } else {
        generateBaseObj();
        checkedHFoV = false;
      }

      setState(() {
        // update
        canvasModelPainter.update(
          control: controller_,
          fig: outputObject,
        );
      });
    }

    void drawVFoV() {
      Face3D fov = Face3D(
        vector.Triangle.points(
          vector.Vector3(0, 0, 0.3),
          vector.Vector3(0, 0 + 3, 0.5),
          vector.Vector3(0, 0 + 3, 0.2),
        ),
        color: Colors.amber,
      );

      if (!checkedVFoV) {
        outputObject.add(fov);

        checkedVFoV = true;
        controller_.update(
          rotationX: -90,
          rotationY: 0,
          rotationZ: 90,
          userScale: 0.5,
        );
      } else {
        generateBaseObj();
        checkedVFoV = false;
      }

      setState(() {
        // update
        canvasModelPainter.update(
          control: controller_,
          fig: outputObject,
        );
      });
    }

    Container generate3Dviewer(Size size) {
      return Container(
        width: size.width,
        height: size.width,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.grey[400],
        ),
        child: DynamicDiTreDiDraggable(
          rotationEnabled: false,
          scaleEnabled: false,
          controller: controller_,
          figs: outputObject,
          canvasModelPainter: canvasModelPainter,
          child: DynamicDiTreDi(
            figures: outputObject,
            controller: controller_,
            canvasModelPainter: canvasModelPainter,
          ),
        ),
      );
    }

    Container generateIconRegion(Size size) {
      return Container(
        // color: Colors.blueGrey,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: SizedBox(
          width: size.width,
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  // dimension
                  onPressed: () => drawDimension(),
                  icon: SvgPicture.asset(
                    'icon/dimensions.svg',
                    height: size.width / 8,
                    fit: BoxFit.contain,
                  ),
                ),
                const VerticalDivider(
                  width: 10,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5,
                  color: Colors.grey,
                ),
                IconButton(
                  // V FoV
                  onPressed: () => drawVFoV(),
                  icon: Image.asset(
                    'icon/fov.png',
                    fit: BoxFit.contain,
                    height: size.width / 8,
                  ),
                ),
                const VerticalDivider(
                  width: 10,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5,
                  color: Colors.grey,
                ),
                IconButton(
                  // H FoV
                  onPressed: () => drawHFoV(),
                  icon: Image.asset(
                    'icon/fov.png',
                    fit: BoxFit.contain,
                    height: size.width / 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Column generate3DViewerContain(Size size) {
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          generate3Dviewer(size),
          const SizedBox(
            height: 10,
          ),
          generateIconRegion(size),
        ],
      );
    }

    bool checkScreenSize() {
      if (MediaQuery.of(context).size.width <
          (miniumScreenSizeWidth + miniumScreenSizeWidth * 1.5)) {
        print('screen size is small to base');
        return false;
      } else {
        return true;
      }
    }

    Column generateTebleWidget(Size size, double fontSize) {
      return Column(
        children: [
          SizedBox(
            // color: Colors.blue,
            width: checkScreenSize() ? size.width * 1.3 : size.width,
            child: Text(
              widget.inform.name ?? 'LiDAR',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: checkScreenSize() ? size.width * 1.3 : size.width * 0.9,
            child: Text(
              'Kanavi-Mobility Industrial/Safety LiDAR Sensor',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize * 0.55,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ProductionDetailWidget(
            name: const [
              'Num. of Channels',
              'Light Source',
              'HFoV & Resolution',
              'VFoV & Resolution',
              'Scanning Frequency',
              'Detection Range',
              'Operating Temperature',
              'Input Voltage',
              'Dimension',
              'Field of Application'
            ],
            value: [
              '${widget.inform.numOfChs}',
              '${widget.inform.lightSource} Eye-Safety Class 1',
              '${widget.inform.hFoV} º & ${widget.inform.hResolution} º',
              '${widget.inform.vFoV} º & ${widget.inform.vResolution} º',
              '${widget.inform.freq}Hz (Max)',
              '${widget.inform.rangeMin} ~ ${widget.inform.rangeMax} m (Max)',
              '${widget.inform.tempMin} ~ ${widget.inform.tempMax} ℃',
              '${widget.inform.voltageMin} ~ ${widget.inform.voltageMax} V DC',
              '${widget.inform.width} x ${widget.inform.height} x ${widget.inform.depth} mm',
              '${widget.inform.application}',
            ],
            background_: Colors.grey,
            baseFontSize_:
                checkScreenSize() ? fontSize * 0.62 : fontSize * 0.45,
          ),
        ],
      );
    }

    return checkScreenSize()
        ? Row(
            children: [
              const SizedBox(
                width: 50,
              ),
              widget.evens
                  ? generate3DViewerContain(baseSize)
                  : generateTebleWidget(baseSize, baseFontSize),
              Flexible(child: Container()),
              widget.evens
                  ? generateTebleWidget(baseSize, baseFontSize)
                  : generate3DViewerContain(baseSize),
              const SizedBox(
                width: 50,
              ),
            ],
          )
        : Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                generate3Dviewer(MediaQuery.of(context).size * 0.9),
                const SizedBox(
                  height: 10,
                ),
                generateIconRegion(MediaQuery.of(context).size * 0.9),
                const SizedBox(
                  height: 10,
                ),
                generateTebleWidget(
                    MediaQuery.of(context).size * 0.8, baseFontSize * 0.7),
              ],
            ),
          );
  }
}
