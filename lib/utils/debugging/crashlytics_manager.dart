import 'package:flutter/material.dart';

import 'package:openpocket/utils/debugging/crash_reporter.dart';

class CrashlyticsManager implements CrashReporter {
  static final CrashlyticsManager _instance = CrashlyticsManager._internal();
  static CrashlyticsManager get instance => _instance;

  CrashlyticsManager._internal();

  factory CrashlyticsManager() {
    return _instance;
  }

  static Future<void> init() async {
    // No-op — Crashlytics removed
  }

  @override
  void identifyUser(String email, String name, String userId) {}

  @override
  void logInfo(String message) {}

  @override
  void logError(String message) {}

  @override
  void logWarn(String message) {}

  @override
  void logDebug(String message) {}

  @override
  void logVerbose(String message) {}

  @override
  void setUserAttribute(String key, String value) {}

  @override
  void setEnabled(bool isEnabled) {}

  @override
  Future<void> reportCrash(Object exception, StackTrace stackTrace, {Map<String, String>? userAttributes}) async {}

  @override
  NavigatorObserver? getNavigatorObserver() {
    return null;
  }

  @override
  bool get isSupported => false;
}
