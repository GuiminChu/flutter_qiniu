import 'dart:async';

import 'package:flutter/services.dart';

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
}
