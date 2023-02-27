import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:pointcloud_data_viewer/files/filesystem.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class PcdFormat {
  PcdFormat._();

  static const int top = 0;
  static const int version = 1;
  static const int field = 2;
  static const int size = 3;
  static const int type = 4;
  static const int count = 5;
  static const int width = 6;
  static const int height = 7;
  static const int veiwpoint = 8;
  static const int numOfPoints = 9;
  static const int data = 10;
  static const int points = 11;
}

enum PCDField {
  none,
  xyz,
  xyzrgb,
  xyzhsv,
}

class PCDReader {
  late String path;

  final String _dumPath =
      '/Users/twchong/workspace/myGithub/basic_study/flutter/03_flutter/SRC/app_flutter_3D/app_thirddemension/pcd';
  FileSystem mFiles = FileSystem();

  PCDReader({
    required this.path,
  });

  // check pcd file field

  PCDField checkField(List<String> list) {
    List checkXyz = [false, false, false];
    bool checkRgb = false;
    bool checkHsv = false;
    String field = list[PcdFormat.field];
    // parse field
    List sp1 = field.split(' ');

    for (var i in sp1) {
      switch (i) {
        case 'x':
          checkXyz[0] = true;
          break;
        case 'y':
          checkXyz[1] = true;
          break;
        case 'z':
          checkXyz[2] = true;
          break;
        case 'rgb':
          checkRgb = true;
          break;
        case 'hsv':
          checkHsv = true;
          break;
        default:
          print('defalut...$i');
          break;
      }
    }

    if (checkXyz[0] && checkXyz[1] && checkXyz[2]) {
      if (checkRgb && !checkHsv) {
        return PCDField.xyzrgb;
      } else if (!checkRgb && checkHsv) {
        return PCDField.xyzhsv;
      } else if (!checkRgb && !checkHsv) {
        return PCDField.xyz;
      }
    }

    return PCDField.none;
  }

  // check total number of points
  int checkNumOfPoints(List<String> list) {
    int size = 0;
    String num = list[PcdFormat.numOfPoints];
    List l = num.split(' ');
    size = int.parse(l[1]);
    return size;
  }

  // get point cloud
  List<Point3D> parsePointCloud({
    required List<String> list,
    required PCDField field,
  }) {
    List<Point3D> pointcloud = [];

    // parse
    List sp;
    Point3D pt;
    Color c = Colors.black;
    int colorDec = 0;
    String colorHex = '';
    for (int i = PcdFormat.points; i < list.length; i++) {
      sp = list[i].split(' ');
      // print(sp);
      if (sp.length == 4) {
        // parse color
        if (field == PCDField.xyzrgb) {
          // dec -> hex
          colorDec = int.parse(sp[3]);
          colorHex = colorDec.toRadixString(16);
          colorHex = '0xFF$colorHex';
          // alpha/r/g/b
          // final alpha = colorHex.substring(0, 2);
          // final r = colorHex.substring(2, 4);
          // final g = colorHex.substring(4, 6);
          // final b = colorHex.substring(6, 8);
          // print('$colorHex : $alpha | $r | $g | $b');
          c = Color(int.parse(colorHex)); // 확인 필요...
        } else if (field == PCDField.xyzhsv) {}
        // parse point
        pt = Point3D(
            vector.Vector3(
              double.parse(sp[0]), // x
              double.parse(sp[1]), // y
              double.parse(sp[2]), // z
            ),
            color: c);
      } else {
        //only points
        pt = Point3D(
            vector.Vector3(
              double.parse(sp[0]), // x
              double.parse(sp[1]), // y
              double.parse(sp[2]), // z
            ),
            color: c);
      }

      pointcloud.add(pt);
    }
    return pointcloud;
  }

  // read file & convert Stream<string> to List<String>
  Future<List<String>> _readFromFile() async {
    setBasePath();

    mFiles.setLocalPath(path);
    mFiles.setFileName('pointcloud_log.pcd');

    Stream<String> fileLines = mFiles.readSync();

    return fileLines.toList();
  }

  Future<List<Point3D>> read(String filename) async {
    List<Point3D> pc = [];
    final strs = await _readFromFile();

    if (strs.isNotEmpty) {
      // check point type
      PCDField field = checkField(strs);
      int size = checkNumOfPoints(strs);
      // print('point size $size');

      pc = parsePointCloud(list: strs, field: field);
    }
    return pc;
  }

  void setBasePath() {
    if (path.isEmpty) {
      path = _dumPath;
    }
  }
}
