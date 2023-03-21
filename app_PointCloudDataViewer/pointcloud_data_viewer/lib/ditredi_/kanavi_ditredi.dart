import 'package:ditredi/src/controller/ditredi_controller.dart';
import 'package:ditredi/src/model/ditredi_config.dart';
import 'package:ditredi/src/model/model_3d.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:pointcloud_data_viewer/ditredi_/karnavi_canvas_model_painter.dart';
import 'package:vector_math/vector_math_64.dart';

export 'package:ditredi/src/extensions/double_extensions.dart';
export 'package:ditredi/src/extensions/iterable_extensions.dart';
export 'package:ditredi/src/extensions/vector_extensions.dart';
export 'package:ditredi/src/model/axis.dart';
export 'package:ditredi/src/model/model_3d.dart';
export 'package:ditredi/src/model/ditredi_config.dart';
export 'package:ditredi/src/model/modifier_3d.dart';
export 'package:ditredi/src/model/vertices/line_3.dart';
export 'package:ditredi/src/model/vertices/poly_line3.dart';
export 'package:ditredi/src/parser/csv_parser.dart';
export 'package:ditredi/src/parser/obj_parser.dart';
export 'package:ditredi/src/controller/ditredi_controller.dart';

/// A widget that displays a 3D objects.
class KDiTreDi extends StatelessWidget {
  /// List of [Model3D] to display.
  final List<Model3D> figures;

  /// Bounds of the 3D space.
  final Aabb3? bounds;
  final Aabb3 sBounds = Aabb3();

  /// The [DitrediConfig] to use.
  final DiTreDiConfig config;

  /// The controller to controll the camera.
  final DiTreDiController controller;

  final KModelPainter mPainter;

  /// Creates a [DiTreDi] widget.
  KDiTreDi({
    Key? key,
    required this.figures,
    DiTreDiController? controller,
    this.config = const DiTreDiConfig(),
    this.bounds,
    KModelPainter? painter,
  })  : controller = controller ?? DiTreDiController(),
        mPainter =
            painter ?? KModelPainter(figures, bounds, controller!, config),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        size: Size.infinite,
        // painter: CanvasModelPainter(
        painter: mPainter,
      ),
    );
  }
}

/// A widget that controls the [DiTreDi] camera with gestures.
class KDiTreDiDraggable extends StatefulWidget {
  /// The [DiTreDiController] to control.
  /// Should be the same as the one used in the [DiTreDi] widget.
  final DiTreDiController controller;

  /// The [DiTreDi] widget or its container.
  final Widget child;

  /// If true, the camera will be rotated with the finger.
  final bool rotationEnabled;

  /// If true, the zoom will be changed with the mouse scroll.
  final bool scaleEnabled;

  /// Creates a [KDiTreDiDraggable] widget.
  const KDiTreDiDraggable({
    Key? key,
    required this.controller,
    required this.child,
    this.rotationEnabled = true,
    this.scaleEnabled = true,
  }) : super(key: key);

  @override
  State<KDiTreDiDraggable> createState() => _KDiTreDiDraggableState();
}

class _KDiTreDiDraggableState extends State<KDiTreDiDraggable> {
  var _lastX = 0.0;
  var _lastY = 0.0;
  var _scaleBase = 0.0;

  @override
  void initState() {
    print('check KDiTreDi-KDiTreDiDraggable init');
    super.initState();
  }

  @override
  void dispose() {
    print('check KDiTreDi-KDiTreDiDraggable dispose');
    super.dispose();
  }

  //rotation X limit release
  double _calculateRotationX(double x, double dy) {
    return (x - dy / 2).clamp(-100, 130);
  }

  @override
  Widget build(BuildContext context) {
    print('check KDiTreDi-KDiTreDiDraggable build');

    return Listener(
      onPointerSignal: (pointerSignal) {
        if (widget.scaleEnabled && pointerSignal is PointerScrollEvent) {
          final scaledDy =
              pointerSignal.scrollDelta.dy / widget.controller.viewScale;
          widget.controller.update(
            userScale: widget.controller.userScale - scaledDy,
          );
        }
      },
      child: GestureDetector(
        onScaleStart: (data) {
          _scaleBase = widget.controller.userScale;
          _lastX = data.localFocalPoint.dx;
          _lastY = data.localFocalPoint.dy;
        },
        onScaleUpdate: (data) {
          final controller = widget.controller;

          final dx = data.localFocalPoint.dx - _lastX;
          final dy = data.localFocalPoint.dy - _lastY;

          _lastX = data.localFocalPoint.dx;
          _lastY = data.localFocalPoint.dy;

          controller.update(
            userScale: _scaleBase * data.scale,
            rotationX: widget.rotationEnabled
                // ? (controller.rotationX - dy / 2).clamp(-90, -20)
                // ? _calculateRotationX(controller.rotationX, dy)
                ? (controller.rotationX - dy / 2)
                : null,
            rotationY: widget.rotationEnabled
                ? ((controller.rotationY - dx / 2 + 360) % 360).clamp(0, 360)
                : null,
          );
        },
        child: widget.child,
      ),
    );
  }
}
