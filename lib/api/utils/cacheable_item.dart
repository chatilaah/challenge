import 'dart:convert';

import 'package:challenge/api/models/base_response.dart';
import 'package:challenge/api/utils/cacheable_util.dart';
import 'package:challenge/api/utils/cached_object.dart';
import 'package:challenge/api/utils/online_api.dart';
import 'package:challenge/api/utils/secure_file.dart';

class CacheableItem with CacheableUtil {
  final String internalName;

  Future<void> preserveCacheObject(BaseResponse resp, {String suffix = ''}) {
    if (resp.code != kApiSuccess) {
      return Future.value();
    }

    final co = CachedObject(lastUpdated: DateTime.now(), data: resp.toJson());
    final fileContent = jsonEncode(co);

    var file = SecureFile(_getCachedFilename(suffix: suffix));
    return file.writeAsString(fileContent, flush: true);
  }

  Future<String> _retrieveCachedObjectContent({String suffix = ''}) async {
    final file = SecureFile(_getCachedFilename(suffix: suffix));
    if (file.existsSync()) {
      return await file.readAsString();
    }

    return '';
  }

  String _getCachedFilename({String suffix = ''}) {
    if (suffix.isEmpty) return getCachedFile(internalName);
    return getCachedFile(
        '${internalName}_${suffix.replaceAll(' ', '').toLowerCase()}');
  }

  Future<CachedObject?> getCachedObject({String suffix = ''}) async {
    final content = await _retrieveCachedObjectContent(suffix: suffix);

    if (content.isEmpty) {
      return null;
    }

    return cachedObjectFromJson(content);
  }

  const CacheableItem({required this.internalName});
}
