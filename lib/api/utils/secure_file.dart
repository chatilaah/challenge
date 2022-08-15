import 'dart:io';
import 'package:encrypt/encrypt.dart';

class SecureFile {
  late File _file;

  //HACK: Not the best way to encrypt files, but at least it adds a layer of security.
  final _encrypter =
      Encrypter(AES(Key.fromUtf8("SgVkYp3s6v9y%B&E)H@McQfThWmZq4t7")));
  final iv = IV.fromLength(16);

  SecureFile(String path) {
    _file = File(path);
  }

  Future<File> writeAsString(String fileContent, {bool flush = false}) {
    var newContent = _encrypter.encrypt(fileContent, iv: iv);

    return _file.writeAsString(newContent.base64, flush: flush);
  }

  Future<bool> exists() => _file.exists();

  bool existsSync() => _file.existsSync();

  Future<String> readAsString() async {
    var data = await _file.readAsString();

    var decryptedContent = _encrypter.decrypt64(data, iv: iv);
    return decryptedContent;
  }
}
