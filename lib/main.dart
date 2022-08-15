import 'package:challenge/app/services/notification_service.dart';
import 'package:challenge/app/views/app.dart';
import 'package:challenge/db/repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  getApplicationSupportDirectory().then((value) {
    runApp(ChallengeApp(value.path, repo: Repo.provider()));
  });
}
