import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'package:flutter_qiniu/entity/file_path_entity.dart';
export 'package:flutter_qiniu/entity/file_path_entity.dart';

enum QNFixedZone {
  zone0, // 华东
  zone1, // 华北
  zone2, //华南
  zoneNa0, //北美
  zoneAs0 // 新加坡
}

class FlutterQiniu {
  static const MethodChannel _channel = const MethodChannel('flutter_qiniu');

  QNFixedZone zone = QNFixedZone.zone0;

  FlutterQiniu({this.zone});

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<bool> upload(String filePath, String key, String token) async {
    Map<String, String> map = {
      "filePath": filePath,
      "key": key,
      "token": token,
      "zone": zone.index.toString()
    };

    var result = await _channel.invokeMethod('upload', map);
    return result;
  }

  Future<bool> uploadData(Uint8List data, String key, String token) async {
    Map<String, dynamic> map = {
      "data": data,
      "key": key,
      "token": token,
      "zone": zone.index.toString()
    };

    var result = await _channel.invokeMethod('uploadData', map);
    return result;
  }

  Future<List<bool>> uploadFiles(List<FilePathEntity> entities) async {
    var uploads = entities.map((entity) {
      return upload(entity.filePath, entity.key, entity.token);
    });

    var results = await Future.wait(uploads);
    return results;
  }
}
