import 'package:flutter/material.dart';

class ViewerConfigController extends ChangeNotifier {
  RangeValues _gridRangeX;
  RangeValues _gridRangeY;
  double _pointSize;

  ViewerConfigController({
    RangeValues? gridRangeX,
    RangeValues? gridRangeY,
    double? pointSize,
  })  : _gridRangeX = gridRangeX ?? const RangeValues(-10, 10),
        _gridRangeY = gridRangeY ?? const RangeValues(0, 20),
        _pointSize = pointSize ?? 1.0;

  final RangeValues maxRangeX = const RangeValues(-50.0, 50.0);
  final RangeValues maxRangeY = const RangeValues(0, 100.0);

  void updateGridRangeX(RangeValues range) {
    _gridRangeX = range;

    if (_gridRangeX.start < maxRangeX.start) {
      updateGridRangeX(RangeValues(maxRangeX.start, range.end));
    }

    if (_gridRangeX.end > maxRangeX.end) {
      updateGridRangeX(RangeValues(range.start, maxRangeX.end));
    }

    notifyListeners();
  }

  void updateGridRangeY(RangeValues range) {
    _gridRangeY = range;
    if (_gridRangeY.start < maxRangeY.start) {
      updateGridRangeX(RangeValues(maxRangeY.start, range.end));
    }

    if (_gridRangeY.end > maxRangeY.end) {
      updateGridRangeX(RangeValues(range.start, maxRangeY.end));
    }
    notifyListeners();
  }

  void updatePointSize(double size) {
    _pointSize = size;
    if (_pointSize <= 0) _pointSize = 1.0;
    if (_pointSize >= 6) _pointSize = 5.0;
  }

  RangeValues get getGridRangeX => _gridRangeX;
  double get getGridRangeXStart => _gridRangeX.start;
  double get getGridRangeXEnd => _gridRangeX.end;
  RangeValues get getGridRangeY => _gridRangeY;
  double get getGridRangeYStart => _gridRangeY.start;
  double get getGridRangeYEnd => _gridRangeY.end;
  double get getPointSize => _pointSize;

  RangeValues get getMaxRangeX => maxRangeX;
  RangeValues get getMaxRangeY => maxRangeY;

  int rangeXdivision() {
    return (maxRangeX.end - maxRangeX.start) ~/ 5;
  }

  int rangeYdivision() {
    return (maxRangeY.end - maxRangeY.start) ~/ 5;
  }
}
