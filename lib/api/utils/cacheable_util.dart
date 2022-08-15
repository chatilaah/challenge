import 'dart:io';

import 'package:challenge/app/views/app.dart';

mixin CacheableUtil {
  String getCachedFile(String cachedFilename,
      {String root = '', bool userScoped = true}) {
    if (root.isEmpty) {
      root = ChallengeApp.applicationSupportPath;
    }

    var directoryPath = root;

    if (userScoped) {
      directoryPath = getUserCachedDirectory();
    }

    return '$directoryPath/.cached_$cachedFilename';
  }

  String getUserCachedDirectory() {
    var root = ChallengeApp.applicationSupportPath;

    var directoryPath = '$root/default';
    Directory dir = Directory(directoryPath);
    if (!dir.existsSync()) {
      dir.createSync();
    }

    return directoryPath;
  }
}
