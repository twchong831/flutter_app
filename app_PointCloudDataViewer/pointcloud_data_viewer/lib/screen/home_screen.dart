import 'dart:io';

// import 'package:ditredi/ditredi.dart';
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

  bool checkedListUpdated = false;

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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                top: 8,
                right: 15,
                left: 15,
              ),
              child: ElevatedButton(
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
                              // print('Find : $sub');
                              listPcdFiles.add(sub);
                            }
                          }
                        }
                        selPcdFile = listPcdFiles[0];
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4399F8),
                  foregroundColor: Colors.white,
                  elevation: 10,
                  shadowColor: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    top: 8,
                    right: 15,
                    left: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.folder_open_rounded,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "PCD files Directory select",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          // backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                top: 8,
                right: 15,
                left: 15,
              ),
              child: DropdownButton(
                isExpanded: true,
                items: generateFileListMenu(listPcdFiles),
                // icon: Ic,
                onChanged: (dynamic value) {
                  setState(
                    () {
                      selPcdFile = value;
                      if (selPcdFile != strNone) {
                        checkedListUpdated = true;
                      } else {
                        checkedListUpdated = false;
                      }
                      // print(listPcdFiles);
                    },
                  );
                },
                value: selPcdFile,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                top: 8,
                right: 15,
                left: 15,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4399F8),
                  foregroundColor: Colors.white,
                  elevation: 10,
                  shadowColor: Colors.black,
                ),
                onPressed: checkedListUpdated
                    ? () async {
                        _visualizer(
                          context,
                          pointCloud: await pcdReader.read(selPcdFile),
                        );
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.file_open_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Load',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          // backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
