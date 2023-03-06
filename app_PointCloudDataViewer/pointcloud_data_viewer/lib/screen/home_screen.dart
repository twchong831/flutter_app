import 'dart:async';
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

  bool checkedVisualization = false;
  bool checkedListUpdated = false;
  bool checkedViewrTimerUpdateFunc = false;

  late Timer timerPlay;
  bool checkedTimerIsRunning = false;
  int timerListCount = 0;
  bool checkedTimerViewerUpdated = false;
  DiTreDiController? _beforeViewConfig;

  late PcdVisualizer mVisualizer;

  _visualizer(BuildContext context, {required List<Point3D> pointCloud}) async {
    print('home : visualization pcd : ${pointCloud.length}');

    if (!checkedVisualization) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => PcdVisualizer(
          //   outputPointCloud: pointCloud,
          // ),
          builder: (context) => mVisualizer = PcdVisualizer(
            pointCloud: pointCloud,
            checkedUpdateCloud: checkedViewrTimerUpdateFunc,
            controller: _beforeViewConfig,
          ),
        ),
      );
      checkedVisualization = true;
    }

    setState(() {
      if (checkedVisualization) {
        if (checkedTimerIsRunning) {
          // print("timer cancle");
          checkedTimerIsRunning = false;
          timerPlay.cancel();
        }
        checkedVisualization = false;
        _beforeViewConfig = mVisualizer.getBeforeViewPoint();
        // print("home check viewPoint $_beforeViewPoint");
      }
    });
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

  void onUpdateListNum(Timer timer) async {
    pointCloud = await pcdReader.read(listPcdFiles[timerListCount]);
    setState(() {
      print("home Timer Active");
      timerListCount++;
      if (timerListCount > listPcdFiles.length - 1) {
        timerListCount = 0;
      }
      print('timer point cloud upate : ${pointCloud.length}');
      // mVisualizer.updatedPointCloud(pointCloud);
      checkedTimerViewerUpdated = !checkedTimerViewerUpdated;
    });
  }

  //timer playing
  void timerPlaying() {
    if (!checkedTimerIsRunning) {
      timerPlay = Timer.periodic(
        const Duration(microseconds: 100),
        // const Duration(seconds: 1),
        (timer) => onUpdateListNum(timer),
      );
    } else {
      timerPlay.cancel();
    }

    setState(() {
      checkedTimerIsRunning = !checkedTimerIsRunning;

      if (!checkedTimerIsRunning) {
        timerListCount = 0;
      }
    });
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
                  timerListCount = 0;
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
                              listPcdFiles.add(sub);
                            }
                          }
                        }

                        if (listPcdFiles.length > 1) {
                          checkedListUpdated = true;
                          listPcdFiles.sort(
                            (a, b) {
                              if (a.contains('(') && a.contains(')')) {
                                List<String> la = a.split(RegExp(r'[(-)]'));
                                List<String> lb = b.split(RegExp(r'[(-)]'));

                                if (int.parse(la[1]) > int.parse(lb[1])) {
                                  return 1;
                                } else {
                                  return -1;
                                }
                              }
                              return -1;
                            },
                          );
                        } else {
                          checkedListUpdated = false;
                          listPcdFiles.add(strNone);
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
                child: FittedBox(
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
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff4399F8),
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shadowColor: Colors.black,
                      ),
                      onPressed: checkedListUpdated
                          ? () async {
                              checkedViewrTimerUpdateFunc = false;
                              _visualizer(
                                context,
                                pointCloud: await pcdReader.read(selPcdFile),
                              );
                            }
                          : null,
                      child: FittedBox(
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
                  FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: 70,
                      child: IconButton(
                        padding: const EdgeInsets.only(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 25,
                        ),
                        onPressed: checkedListUpdated
                            ? () async {
                                checkedViewrTimerUpdateFunc = true;
                                // timerPlaying();
                                _visualizer(context,
                                    pointCloud: await pcdReader
                                        .read(listPcdFiles[timerListCount]));
                                timerPlaying();
                              }
                            : null,
                        icon: const Icon(
                          Icons.play_circle_outline_outlined,
                          size: 50,
                          shadows: [],
                        ),
                        color: Colors.green,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
