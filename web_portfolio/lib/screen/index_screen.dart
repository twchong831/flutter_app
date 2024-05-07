import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  bool checkedSceen = false;
  late Timer timer_;

  void activeLoadingTimer() {
    if (!checkedSceen) {
      timer_ = Timer(const Duration(seconds: 1), () {
        print('time out');
        stopTimer();
      });
    }
  }

  void stopTimer() {
    timer_.cancel();
    print('timer stop ${timer_.isActive}');
    setState(() {
      checkedSceen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    activeLoadingTimer();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
      ),
      body: checkedSceen
          ? const Column(
              children: [
                Text('test'),
              ],
            )
          : Center(
              child: LoadingAnimationWidget.beat(
                color: Colors.red,
                size: 200,
              ),
            ),
    );
  }
}
