import 'package:flutter/material.dart';

import 'package:openpocket/backend/preferences.dart';
import 'package:openpocket/pages/home/page.dart';
import 'package:openpocket/pages/model_download/model_download_page.dart';

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modelsReady = SharedPreferencesUtil().modelsDownloaded;
    if (!modelsReady) {
      return const ModelDownloadPage();
    }
    return const HomePageWrapper();
  }
}
