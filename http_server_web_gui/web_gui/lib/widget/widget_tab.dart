import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_embedded/data/json_network_model.dart';
import 'package:web_embedded/widget/widget_name.dart';

const String staticJson =
    '[{"name": "none", "ip": "none"}, {"name": "none2", "ip": "none2"}]';

class NetworkTabWidget extends StatefulWidget {
  // final List _json;
  // final String jSon;
  final List<JsonNetworkModel> model;

  const NetworkTabWidget({
    super.key,
    // String? json,
    required this.model,
  }) /*: jSon = json ?? staticJson*/;

  @override
  State<NetworkTabWidget> createState() => _NetworkTabWidgetState();
}

class _NetworkTabWidgetState extends State<NetworkTabWidget>
    with TickerProviderStateMixin {
  // tabContainer controller
  late final TabController _tabController;

  List<String> nameList = [];
  String selectIP = '';
  String selectName = '';

  List listJson = [];

  tabMaker() {
    List<Tab> tabs = [];
    // print(' input ? ${widget.jSon}');
    for (var i in listJson) {
      tabs.add(Tab(
        text: i['name'],
      ));
    }
    return tabs;
  }

  List<Widget> tabViewMaker(List json) {
    const double wH = 100;
    List<Widget> tabs = [];

    final GlobalKey widthKey = GlobalKey();

    for (int i = 0; i < listJson.length; i++) {
      tabs.add(
        Column(
          children: [
            SizedBox(
              height: wH,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.amber,
                        width: 4,
                      ))),
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          listJson[i]['name'],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: wH,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const NameWidget(name: 'IP'),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: widthKey.currentContext?.size?.height ?? wH,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: Colors.black,
                          )),
                      child: TextField(
                        controller: TextEditingController(
                          text: listJson[i]['ip'],
                        )..selection = TextSelection.fromPosition(TextPosition(
                            offset: listJson[i]['ip'].toString().length)),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            listJson[i]['ip'] = value;
                          });
                        },
                        style: const TextStyle(
                          fontSize: 50,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return tabs;
  }

  // udpate List
  void updateList() {
    if (widget.model.isNotEmpty) {
      for (var i in widget.model) {
        listJson.add({'name': i.name, 'ip': i.ip});
      }
    } else {
      listJson = jsonDecode(staticJson);
    }

    nameList.clear();
    for (var i in listJson) {
      nameList.add(i['name']);
    }

    selectIP = listJson[0]['ip'];
    selectName = listJson[0]['name'];

    _tabController = TabController(
      initialIndex: 0,
      length: nameList.length,
      vsync: this,
    );
  }

  @override
  void initState() {
    super.initState();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.red,
              labelColor: Colors.black,
              labelStyle: const TextStyle(
                fontSize: 30,
              ),
              onTap: (value) {
                setState(() {});
              },
              tabs: tabMaker(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabViewMaker(listJson),
            ),
          ),
        ],
      ),
    );
  }
}
