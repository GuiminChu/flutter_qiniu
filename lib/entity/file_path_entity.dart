import 'package:flutter/foundation.dart';

class FilePathEntity {
  String filePath;
  String key;
  String token;

  FilePathEntity({
    @required this.filePath,
    @required this.key,
    @required this.token,
  })  : assert(filePath != null),
        assert(key != null),
        assert(token != null);
}
