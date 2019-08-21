# flutter_qiniu

A new flutter plugin project for Qiniu.

## Getting Started

```dart
/// 单个文件上传
///
/// [file] 文件
/// [key] 保存在服务器上的资源唯一标识
/// [token] 服务器分配的 token
Future<String> _onUpload(File file, String key, String token) async {

    final qiniu = FlutterQiniu(zone: QNFixedZone.zone2);
    String resultKey = await qiniu.upload(file.path, key, token);

    return resultKey;
}

/// 多个文件上传
Future<List<String>> _onUploadFiles(List<FilePathEntity> entities) async {
    final qiniu = FlutterQiniu(zone: QNFixedZone.zone1);
    List<String> resultKeys = await qiniu.uploadFiles(entities);

    return resultKeys;
}
```


