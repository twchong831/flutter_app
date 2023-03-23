import 'package:flutter/material.dart';
import 'package:pointcloud_data_viewer/screen/file_select_screen.dart';
import 'package:pointcloud_data_viewer/screen/viewer_setting_screen.dart';
import 'package:tab_container/tab_container.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  late final TabContainerController _controller;
  late TextTheme textTheme;

  List<Widget> _tabIcons(BuildContext context) => [
        const Icon(
          Icons.folder,
          size: 40,
        ),
        const Icon(
          Icons.settings,
          size: 40,
        ),
      ];

  @override
  void initState() {
    _controller = TabContainerController(length: 2);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double gridMax = 20;
  double gridMin = 0;
  double pointSize = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Point Cloud Data File Visualizer'),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabContainer(
              radius: 10,
              color: Theme.of(context).colorScheme.primary,
              tabEdge: TabEdge.left,
              tabStart: 0,
              tabEnd: 0.25,
              childPadding: const EdgeInsets.all(10),
              tabs: _tabIcons(context),
              isStringTabs: false,
              children: [
                const FileSelectScreen(),
                ViewerSetScreen(
                  gridMax: gridMax,
                  gridMin: gridMin,
                  ptSize: pointSize,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
