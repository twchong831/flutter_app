import 'dart:io';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // variables====================================
  List<String> localIPList = [];
  // !variables===================================

  // defined FUNC.================================
  // get Network IP List
  void _getNetworkInform() async {
    try {
      final list = await NetworkInterface.list(
        includeLoopback: true,
        type: InternetAddressType.IPv4,
      );
      setState(() {
        localIPList.clear();
        for (var i = 0; i < list.length; i++) {
          localIPList.add(list[i].addresses[0].address);
        }
        // print('update ip list ${_localIPList.length}');
      });
    } catch (e) {
      //exception
      setState(() {
        localIPList.clear();
        localIPList.add('nothing');
      });
    }
  }

  // !defined FUNC.===============================

  // based FUNC.==================================
  // !based FUNC.=================================
  // build========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanavi-mobility DCU'),
      ),
      body: Row(
        children: [
          IconButton(
            onPressed: _getNetworkInform,
            icon: const Icon(Icons.refresh),
          ),
          Text('$localIPList'),
        ],
      ),
    );
  }
}
