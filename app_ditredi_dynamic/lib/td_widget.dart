import 'package:app_ditredi_dynamic/ditredi_/kanavi_ditredi.dart';
import 'package:app_ditredi_dynamic/ditredi_/karnavi_canvas_model_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TdWidget extends StatefulWidget {
  final DiTreDiController controller;
  // final List<Model3D> figures;
  final bool rotationEnabled;
  final bool scaleEnabled;
  final KModelPainter mPainter;

  // final Aabb3? bounds;
  // final DiTreDiConfig config;

  const TdWidget({
    super.key,
    required this.controller,
    // required this.figures,
    // KModelPainter? painter,
    required this.mPainter,
    // this.config = const DiTreDiConfig(),
    // this.bounds,
    this.rotationEnabled = true,
    this.scaleEnabled = true,
  });

  @override
  State<TdWidget> createState() => _TdWidgetState();
}

class _TdWidgetState extends State<TdWidget> {
  var _lastX = 0.0;
  var _lastY = 0.0;
  var _scaleBase = 0.0;

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
            rotationX:
                widget.rotationEnabled ? (controller.rotationX - dy / 2) : null,
            rotationY: widget.rotationEnabled
                ? ((controller.rotationY - dx / 2 + 360) % 360).clamp(0, 360)
                : null,
          );
        },
        child: ClipRect(
          child: CustomPaint(
            size: Size.infinite,
            painter: widget.mPainter,
          ),
        ),
      ),
    );
  }
}
