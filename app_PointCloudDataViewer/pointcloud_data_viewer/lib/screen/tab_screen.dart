import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:pointcloud_data_viewer/screen/file_select_screen.dart';

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
        title: const Text('tab'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1800,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: TabContainer(
                    radius: 20,
                    colors: const [
                      Colors.red,
                      Colors.yellow,
                    ],
                    tabs: const ['File Select', 'config'],
                    children: [
                      Container(
                        child: const FileSelectScreen(),
                      ),
                      Container(
                        child: const Text('page1'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
