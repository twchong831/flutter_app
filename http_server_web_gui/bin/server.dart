// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

String nowIp = '';
int portNum = 0;

class JsonNetworkModel {
  final String name;
  final String ip;
  final String _netmask;
  final String _gateway;

  static String _convertIP2gateway(String ip) {
    List<String> ips = ip.split('.');
    return '${ips[0]}.${ips[1]}.${ips[2]}.1';
  }

  JsonNetworkModel({
    required this.name,
    required this.ip,
    String? netmask,
    String? gateway,
  })  : _netmask = netmask ?? "255.255.255.0",
        _gateway = gateway ?? _convertIP2gateway(ip);

  JsonNetworkModel.fromJson(Map<String, dynamic> jsonType)
      : name = jsonType['name'],
        ip = jsonType['ip'],
        _netmask = jsonType['netmask'] ?? '255.255.255.0',
        _gateway = jsonType['gateway'] ?? _convertIP2gateway(jsonType['ip']);
}

Future<void> main() async {
  // If the "PORT" environment variable is set, listen to it. Otherwise, 8080.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

// Serve files from the file system.
  String basePath = Directory.current.path;
  print(basePath);
  final staticHandler = shelf_static.createStaticHandler(
      '$basePath/web_gui/build/web',
      defaultDocument: 'index.html');

  final cascade = Cascade()
      // First, serve files from the 'public' directory
      .add(staticHandler)
      // If a corresponding file is not found, send requests to a `Router`
      .add(_router);

  final server = await shelf_io.serve(
    logRequests().addHandler(cascade.handler),
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  nowIp = server.address.host;
  portNum = port;

  print('Serving at http://${server.address.host}:${server.port}');
}

// Router instance to handler requests.
final _router = shelf_router.Router()
  ..get('/helloworld', _helloWorldHandler) // send 'Hello. World!'
  ..get('/ipport', _ipPortHandler) // send http server IP & port
  ..get('/ipSearch', _ipSearchHandler); // send local Network Information

Response _helloWorldHandler(Request request) => Response.ok('Hello, World!');

Response _ipPortHandler(Request request) =>
    Response.ok('IP : $nowIp, port : $portNum');

const _jsonHeaders = {
  'content-type': 'application/json',
};

Future<Response> _ipSearchHandler(Request request) async {
  List<NetworkInterface> ips = await _getNetworkInform();

  // make json list of Network information
  List<Map<String, dynamic>> jsonList = [];
  for (var i in ips) {
    jsonList.add({
      "name": i.name,
      "ip": i.addresses[0].address,
      // 'netmask': i.addresses
    });
  }

  // shell
  // var shell = Shell();
  // var shellResult = await shell.run('ifconfig');
  // print('shell : ${shellResult.length}');
  // print('shell : ${shellResult[0].outText}');

  var jsonResult = jsonEncode(jsonList);
  print(jsonResult);

  // decode
  List jsonListDe = jsonDecode(jsonResult);
  print(jsonListDe);

  // return Response.ok('$ips');
  return Response(
    200,
    headers: {
      ..._jsonHeaders,
      'Cache-Control': 'no-store',
    },
    body: jsonResult,
  );
}

// get Network IP List
Future<List<NetworkInterface>> _getNetworkInform() async {
  List<NetworkInterface> ipList = [];
  try {
    final list = await NetworkInterface.list(
      includeLoopback: true,
      type: InternetAddressType.IPv4,
    );
    for (var i = 0; i < list.length; i++) {
      ipList.add(list[i]);
    }
  } catch (e) {
    //exception
  }

  return ipList;
}
