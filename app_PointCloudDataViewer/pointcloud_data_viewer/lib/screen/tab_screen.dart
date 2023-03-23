import 'package:flutter/material.dart';
import 'package:pointcloud_data_viewer/screen/file_select_screen.dart';
import 'package:tab_container/tab_container.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  late final TabContainerController _controller;
  late TextTheme textTheme;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Point Cloud Data File Visualizer'),
      ),
      body: SizedBox(
        child: Expanded(
          child: TabContainer(
            radius: 10,
            color: Theme.of(context).colorScheme.primary,
            tabEdge: TabEdge.left,
            tabStart: 0,
            tabEnd: 0.3,
            childPadding: const EdgeInsets.all(10),
            tabs: const ['File Select', 'config'],
            children: const [
              FileSelectScreen(),
              Text('Config page'),
            ],
          ),
        ),
      ),
    );
  }
}
