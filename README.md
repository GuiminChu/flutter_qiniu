# flutter_qiniu

A new flutter plugin project for Qiniu.

## Getting Started

```dart
/// key: 保存在服务器上的资源唯一标识
/// token: 服务器分配的 token
Future<bool> _onUpload(File file, String key, String token) async {

    final qiniu = FlutterQiniu(zone: QNFixedZone.zone2);

    //上传文件
    bool result = await qiniu.upload(file.path, key, token);

    return result;
}
```


