import 'dart:io';

import 'package:openpocket/backend/schema/app.dart';

Future<List<Map<String, dynamic>>> retrieveAppsGrouped({
  int offset = 0,
  int limit = 10,
  bool includeReviews = false,
}) async {
  return [];
}

Future<({List<App> apps, Map<String, dynamic> pagination, Map<String, dynamic>? category})> retrieveAppsByCategory({
  required String category,
  int offset = 0,
  int limit = 20,
  bool includeReviews = false,
}) async {
  return (apps: <App>[], pagination: {'total': 0, 'count': 0, 'offset': offset, 'limit': limit}, category: null);
}

Future<({List<App> apps, Map<String, dynamic> pagination, Map<String, dynamic>? capability})> retrieveAppsByCapability({
  required String capability,
  int offset = 0,
  int limit = 20,
  bool includeReviews = false,
}) async {
  return (apps: <App>[], pagination: {'total': 0, 'count': 0, 'offset': offset, 'limit': limit}, capability: null);
}

Future<({List<Map<String, dynamic>> groups, Map<String, dynamic>? capability, int totalApps})>
    retrieveCapabilityAppsGroupedByCategory({
  required String capability,
  bool includeReviews = true,
}) async {
  return (groups: <Map<String, dynamic>>[], capability: null, totalApps: 0);
}

Future<({List<App> apps, Map<String, dynamic> pagination, Map<String, dynamic>? filters})> retrieveAppsSearch({
  String? query,
  String? category,
  double? minRating,
  String? capability,
  String? sort,
  bool? myApps,
  bool? installedApps,
  int offset = 0,
  int limit = 50,
}) async {
  return (
    apps: <App>[],
    pagination: {'total': 0, 'count': 0, 'offset': offset, 'limit': limit},
    filters: null,
  );
}

Future<List<App>> retrievePopularApps() async {
  return [];
}

Future<List<String>> getEnabledAppsServer() async {
  return [];
}

Future<bool> enableAppServer(String appId) async {
  return false;
}

Future<bool> disableAppServer(String appId) async {
  return false;
}

Future<bool> reviewApp(String appId, AppReview review) async {
  return false;
}

Future<Map<String, String>> uploadAppThumbnail(File file) async {
  return {};
}

Future<bool> updateAppReview(String appId, AppReview review) async {
  return false;
}

Future<bool> replyToAppReview(String appId, String reply, String reviewerUid) async {
  return false;
}

Future<List<AppReview>> getAppReviews(String appId) async {
  return [];
}

Future<String> getAppMarkdown(String appMarkdownPath) async {
  return '';
}

Future<bool> isAppSetupCompleted(String? url) async {
  return true;
}

Future<(bool, String, String?)> submitAppServer(File file, Map<String, dynamic> appData) async {
  return (false, 'Not available in offline mode', null);
}

Future<bool> updateAppServer(File? file, Map<String, dynamic> appData) async {
  return false;
}

Future<List<Category>> getAppCategories() async {
  return [];
}

Future<List<AppCapability>> getAppCapabilitiesServer() async {
  return [];
}

Future<List<NotificationScope>> getNotificationScopesServer() async {
  return [];
}

Future changeAppVisibilityServer(String appId, bool makePublic) async {
  return false;
}

Future<bool> refreshAppManifestServer(String appId) async {
  return false;
}

Future deleteAppServer(String appId) async {
  return false;
}

Future<Map<String, dynamic>?> getAppDetailsServer(String appId) async {
  return null;
}

Future<List<PaymentPlan>> getPaymentPlansServer() async {
  return [];
}

Future<String> getGenratedDescription(String name, String description) async {
  return '';
}

Future<({String description, String emoji})> getGeneratedDescriptionAndEmoji(String name, String prompt) async {
  return (description: 'A custom app that $prompt', emoji: '');
}

Future<List<String>> getGeneratedAppPrompts() async {
  return [];
}

Future<Map<String, dynamic>?> generateAppFromPrompt(String prompt) async {
  return null;
}

Future<String?> generateAppIcon(String name, String description, String category) async {
  return null;
}

Future<List<AppApiKey>> listApiKeysServer(String appId) async {
  return [];
}

Future<Map<String, dynamic>> createApiKeyServer(String appId) async {
  throw Exception('Not available in offline mode');
}

Future<bool> deleteApiKeyServer(String appId, String keyId) async {
  return false;
}

Future<Map> createPersonaApp(File file, Map<String, dynamic> personaData) async {
  return {};
}

Future<bool> updatePersonaApp(File? file, Map<String, dynamic> personaData) async {
  return false;
}

Future<bool> checkPersonaUsername(String username) async {
  return false;
}

Future<Map?> getTwitterProfileData(String handle) async {
  return null;
}

Future<(bool, String?)> verifyTwitterOwnership(String username, String handle, String? personaId) async {
  return (false, null);
}

Future<String> getPersonaInitialMessage(String username) async {
  return '';
}

Future<App?> getUserPersonaServer() async {
  return null;
}

Future<String?> generateUsername(String handle) async {
  return null;
}

Future<bool> migrateAppOwnerId(String oldId) async {
  return false;
}

Future<Map<String, dynamic>?> getUpsertUserPersonaServer() async {
  return null;
}

Future<Map<String, dynamic>?> addMcpServer(String name, String serverUrl, {String? description}) async {
  return null;
}

Future<Map<String, dynamic>?> refreshMcpTools(String appId) async {
  return null;
}
