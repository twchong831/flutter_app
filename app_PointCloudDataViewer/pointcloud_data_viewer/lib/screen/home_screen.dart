import 'dart:io';

import 'package:ditredi/ditredi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pointcloud_data_viewer/files/pcd_reader.dart';
import 'package:pointcloud_data_viewer/widget/pcd_visualizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // FileSystem pcdFiles = FileSystem();
  PCDReader pcdReader = PCDReader(path: '');
  List<DropdownMenuItem<String>> pcdFileList = [];
  String selPcdFile = '';
  List<Point3D> pointCloud = [];

  String strNone = "NONE";
  List<String> listPcdFiles = [];

  _visualizer(
    BuildContext context, {
    required pointCloud,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PcdVisualizer(
          outputPointCloud: pointCloud,
        ),
      ),
    );

    setState(() {});
  }

  // generate dropdownMenuItem
  List<DropdownMenuItem<String>> generateFileListMenu(List<String> list) {
    // print('load generate menu Item');
    bool checked = false;
    late List<DropdownMenuItem<String>> l = [];

    if (list.isEmpty) {
      l.add(DropdownMenuItem(
        value: strNone,
        child: Text(strNone),
      ));
    } else {
      for (var i = 0; i < list.length; i++) {
        List nameList = list[i].split('/');
        l.add(DropdownMenuItem(
          value: list[i],
          child: Text(nameList[nameList.length - 1]),
        ));

        if (selPcdFile.isNotEmpty && (selPcdFile == list[i])) {
          checked = true;
        }
      }
    }

    setState(() {
      if (list.isEmpty) {
        selPcdFile = strNone;
      } else {
        if (!checked) {
          selPcdFile = list[0];
        }
      }
    });

    return l;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Point Cloud Data File Visualizer"),
      ),
      body: Scrollbar(
        thickness: 10,
        radius: const Radius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      if (listPcdFiles.isNotEmpty) listPcdFiles.clear();
                      String? selectedDirectory =
                          await FilePicker.platform.getDirectoryPath();
                      if (selectedDirectory == null) {
                        // User canceled the picker
                      } else {
                        Directory dir = Directory(selectedDirectory);
                        List listFiles = dir.listSync();
                        setState(
                          () {
                            for (var i in listFiles) {
                              String sub = i
                                  .toString()
                                  .substring(7, i.toString().length - 1);
                              List sp = sub.split('.');
                              if (sp.length > 1) {
                                if (sp[sp.length - 1] == 'pcd') {
                                  print('Find : $sub');
                                  listPcdFiles.add(sub);
                                }
                              }
                            }
                            selPcdFile = listPcdFiles[0];
                          },
                        );
                      }
                    },
                    child: const Text("PCD files Directory select"),
                  ),
                  DropdownButton(
                    items: generateFileListMenu(listPcdFiles),
                    onChanged: (dynamic value) {
                      setState(
                        () {
                          selPcdFile = value;
                          // print(listPcdFiles);
                        },
                      );
                    },
                    value: selPcdFile,
                  ),
                  TextButton(
                    onPressed: () async {
                      // print("button pressed : $selPcdFile");
                      // pointCloud = await pcdReader.read(selPcdFile);
                      _visualizer(context,
                          pointCloud: await pcdReader.read(selPcdFile));
                    },
                    child: const Text('Load'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
