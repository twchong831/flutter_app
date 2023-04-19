import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_embedded/data/json_network_model.dart';
import 'package:web_embedded/widget/widget_tab.dart';

class HomeScreenTab extends StatefulWidget {
  const HomeScreenTab({super.key});

  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
  // network Informationg using JSON
  late List<JsonNetworkModel> listNetworkJson;
  // communication http server
  final dio = Dio();
  // check network information get
  bool checkIpListUpdate = false;
  // network Informationg
  String ipSearchResponse = '';

  // timer for check
  late Timer _timer;

  int tickCount = 0;

  // get Network Information from Http server
  void getNetworkResponse(Timer timer) async {
    tickCount++;
    if (!checkIpListUpdate) {
      // request Response Command '/ipSearch' to http Server
      final Response respon = await dio.get('/ipSearch');

      setState(() {
        // response OK
        ipSearchResponse = respon.data;
        listNetworkJson = (respon.data).map<JsonNetworkModel>((json) {
          return JsonNetworkModel.fromJson(json);
        }).toList();

        // // for test==================
        // List<Map<String, dynamic>> jsonList = [];
        // jsonList.add({
        //   'name': 'eno0',
        //   'ip': '127.1.2.3',
        // });
        // ipSearchResponse = jsonEncode(jsonList);
        // listNetworkJson = (jsonList).map<JsonNetworkModel>((json) {
        //   return JsonNetworkModel.fromJson(json);
        // }).toList();
        // // !for test==================
        if (listNetworkJson.isNotEmpty) {
          // delay
          Timer(const Duration(seconds: 3), () {});
          checkIpListUpdate = true;
          _timer.cancel();
        }
      });
    }
  }

  // based FUNC.==================================
  @override
  void initState() {
    super.initState();
    checkIpListUpdate = false;

    // getNetworkResponse();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      getNetworkResponse(timer);
    });
  }
  // !based FUNC.=================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanavi-mobility DCU'),
      ),
      body: checkIpListUpdate
          // page for Network Information
          ? Column(
              children: [
                NetworkTabWidget(
                  model: listNetworkJson,
                )
              ],
            )
          : Center(
              // page for Loading
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.blueAccent,
                size: 200,
              ),
            ),
    );
  }
}
