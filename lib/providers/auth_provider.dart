import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:openpocket/backend/preferences.dart';
import 'package:openpocket/providers/base_provider.dart';
import 'package:openpocket/services/auth_service.dart';
import 'package:openpocket/utils/logger.dart';

class AuthenticationProvider extends BaseProvider {
  dynamic user;
  String? authToken;
  bool _loading = false;
  @override
  bool get loading => _loading;

  AuthenticationProvider() {
    // No Firebase listeners needed in offline mode
    authToken = 'offline-token';
  }

  bool isSignedIn() => true;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> onGoogleSignIn(Function() onSignIn) async {
    // No-op in offline mode
  }

  Future<void> onAppleSignIn(Function() onSignIn) async {
    // No-op in offline mode
  }

  Future<String?> _getIdToken() async {
    return 'offline-token';
  }

  void openTermsOfService() {
    _launchUrl('https://www.omi.me/pages/terms-of-service');
  }

  void openPrivacyPolicy() {
    _launchUrl('https://www.omi.me/pages/privacy');
  }

  void _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      Logger.debug('Invalid URL');
      return;
    }

    await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
    );
  }

  Future<void> linkWithGoogle() async {
    // No-op in offline mode
  }

  Future<void> linkWithApple() async {
    // No-op in offline mode
  }

  Future<bool> migrateAppOwnerId(String oldId) async {
    // No-op in offline mode
    return false;
  }
}
