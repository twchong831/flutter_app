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

  late Timer timerPlay;
  bool checkedTimerIsRunning = false;
  int timerListCount = 0;

  late PcdVisualizer mVisualizer;

  _visualizer(
    BuildContext context, {
    required pointCloud,
  }) async {
    print('checkedVisualization $checkedVisualization');
    print('checkedTimerIsRunning $checkedTimerIsRunning');
    if (!checkedVisualization) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => PcdVisualizer(
          //   outputPointCloud: pointCloud,
          // ),
          builder: (context) =>
              mVisualizer = PcdVisualizer(outputPointCloud: pointCloud),
        ),
      );
      checkedVisualization = true;
    }

    setState(() {
      // print('$checkedVisualization , $checkedTimerIsRunning');
      if (checkedVisualization) {
        if (checkedTimerIsRunning) {
          // print("timer cancle");
          checkedTimerIsRunning = false;
          timerPlay.cancel();
        }
        checkedVisualization = false;
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
      timerListCount++;
      if (timerListCount > listPcdFiles.length) {
        timerListCount = 0;

        // mVisualizer.updated(pointCloud);
      }
      print("timer point cloud size ${pointCloud.length}");
      mVisualizer.updated(pointCloud);
      print('timer update 1s : $timerListCount');
    });
  }

  //timer playing
  void timerPlaying() {
    if (!checkedTimerIsRunning) {
      timerPlay = Timer.periodic(
        // const Duration(microseconds: 30),
        const Duration(seconds: 1),
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
                        listPcdFiles.sort(
                          (a, b) {
                            List<String> la = a.split(RegExp(r'[(-)]'));
                            List<String> lb = b.split(RegExp(r'[(-)]'));

                            if (int.parse(la[1]) > int.parse(lb[1])) {
                              return 1;
                            } else {
                              return -1;
                            }
                          },
                        );
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
                                timerPlaying();
                                checkedTimerIsRunning
                                    ? _visualizer(context,
                                        pointCloud: await pcdReader
                                            .read(listPcdFiles[timerListCount]))
                                    : null;
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
