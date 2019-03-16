import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_qiniu/flutter_qiniu.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_qiniu');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterQiniu.platformVersion, '42');
  });
}
