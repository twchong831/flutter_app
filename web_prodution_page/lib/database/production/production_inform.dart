import 'dart:convert';

class LiDARInformation {
  int? id;
  String? name;
  int? depth;
  int? height;
  int? width;

  double? hFoV;
  double? hResolution;
  double? vFoV;
  double? vResolution;

  int? numOfChs;
  int? lightSource;

  double? rangeMax;
  double? rangeMin;
  double? tempMax;
  double? tempMin;
  double? voltageMax;
  double? voltageMin;

  double? freq;

  String? application;

  LiDARInformation({
    this.application,
    this.depth,
    this.hFoV,
    this.hResolution,
    this.height,
    this.lightSource,
    this.name,
    this.numOfChs,
    this.rangeMax,
    this.rangeMin,
    this.tempMax,
    this.tempMin,
    this.vFoV,
    this.vResolution,
    this.width,
    this.id,
    this.freq,
    this.voltageMax,
    this.voltageMin,
  });

  factory LiDARInformation.fromJson(Map<String, dynamic> json) =>
      LiDARInformation(
        application: json['application'],
        depth: json['depth'],
        hFoV: json['HFoV'],
        hResolution: json['HResolution'],
        height: json['height'],
        lightSource: json['LightSource'],
        name: json['name'],
        numOfChs: json['Num_of_chs'],
        rangeMax: json['detectionRange_Max'],
        rangeMin: json['detectionRange_Min'],
        tempMax: json['operatingTemp_Max'],
        tempMin: json['operatingTemp_Min'],
        vFoV: json['VFoV'],
        vResolution: json['VResolution'],
        width: json['width'],
        id: json['id'],
        freq: json['freq'],
        voltageMax: json['voltage_Max'],
        voltageMin: json['voltage_Min'],
      );
}

class ProductionInformList {
  final List<LiDARInformation>? lists;
  ProductionInformList({this.lists});

  factory ProductionInformList.fromJson(String jsonString) {
    List<dynamic> listFromJson = json.decode(jsonString);
    List<LiDARInformation> list_ = <LiDARInformation>[];

    list_ = listFromJson.map((e) => LiDARInformation.fromJson(e)).toList();

    return ProductionInformList(lists: list_);
  }
}
