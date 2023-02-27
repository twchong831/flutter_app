import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:pointcloud_data_viewer/files/pcd_reader.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FileSystem pcdFiles = FileSystem();
  PCDReader pcdReader = PCDReader(path: '');
  List<Point3D> pointCloud = [];
  final _controller = DiTreDiController(
    rotationX: 0,
    rotationY: 0,
    light: vector.Vector3(-0.5, -0.5, 0.5),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("load File & Display Point Cloud"),
        ),
        body: SafeArea(
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              Expanded(
                child: DiTreDiDraggable(
                  controller: _controller,
                  child: DiTreDi(
                    figures: pointCloud,
                    controller: _controller,
                    config: const DiTreDiConfig(
                      defaultPointWidth: 2,
                      supportZIndex: true,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('som2'),
              ),
              TextButton(
                onPressed: () async {
                  pointCloud = await pcdReader.read('');
                  setState(() {});
                },
                child: const Text('load file list'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
