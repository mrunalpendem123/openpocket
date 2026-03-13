import 'package:openpocket/backend/preferences.dart';
import 'package:openpocket/backend/schema/daily_summary.dart';
import 'package:openpocket/backend/schema/geolocation.dart';
import 'package:openpocket/backend/schema/person.dart';
import 'package:openpocket/models/subscription.dart';
import 'package:openpocket/models/user_usage.dart';

Future<bool> updateUserGeolocation({required Geolocation geolocation}) async {
  return true;
}

Future<bool> setUserWebhookUrl({required String type, required String url}) async {
  return true;
}

Future<String> getUserWebhookUrl({required String type}) async {
  return '';
}

Future disableWebhook({required String type}) async {
  return true;
}

Future enableWebhook({required String type}) async {
  return true;
}

Future webhooksStatus() async {
  return null;
}

Future<bool> deleteAccount() async {
  return true;
}

Future<bool> setRecordingPermission(bool value) async {
  return true;
}

Future<bool?> getStoreRecordingPermission() async {
  return null;
}

Future<bool> deletePermissionAndRecordings() async {
  return true;
}

Future<bool> setPrivateCloudSyncEnabled(bool value) async {
  return true;
}

Future<bool> getPrivateCloudSyncEnabled() async {
  return true;
}

Future<Person?> createPerson(String name) async {
  return null;
}

Future<Person?> getSinglePerson(String personId, {bool includeSpeechSamples = false}) async {
  return null;
}

Future<List<Person>> getAllPeople({bool includeSpeechSamples = true}) async {
  return [];
}

Future<bool> updatePersonName(String personId, String newName) async {
  return true;
}

Future<bool> deletePerson(String personId) async {
  return true;
}

Future<bool> deletePersonSpeechSample(String personId, int sampleIndex) async {
  return true;
}

Future<String> getFollowUpQuestion({String conversationId = '0'}) async {
  return '';
}

Future<bool> setConversationSummaryRating(String conversationId, int value, {String? reason}) async {
  return true;
}

Future<bool> setMessageResponseRating(String messageId, int value, {String? reason}) async {
  return true;
}

Future<bool> getHasConversationSummaryRating(String conversationId) async {
  return true;
}

Future<String?> getUserPrimaryLanguage() async {
  // Offline mode: return saved preference or default to English
  final saved = SharedPreferencesUtil().userPrimaryLanguage;
  return saved.isNotEmpty ? saved : 'en';
}

Future<bool> setUserPrimaryLanguage(String languageCode) async {
  return true;
}

Future<bool> setPreferredSummarizationAppServer(String appId) async {
  return true;
}

Future<UserUsageResponse?> getUserUsage({required String period}) async {
  return null;
}

Future<Map<String, dynamic>> getTrainingDataOptIn() async {
  return {'opted_in': false, 'status': null};
}

Future<bool> setTrainingDataOptIn() async {
  return true;
}

Future<Map<String, dynamic>?> getTranscriptionPreferences() async {
  return null;
}

Future<bool> setTranscriptionPreferences({
  bool? singleLanguageMode,
  List<String>? vocabulary,
}) async {
  return true;
}

Future<UserSubscriptionResponse?> getUserSubscription() async {
  return null;
}

class DailySummarySettings {
  final bool enabled;
  final int hour;

  DailySummarySettings({required this.enabled, required this.hour});

  factory DailySummarySettings.fromJson(Map<String, dynamic> json) {
    return DailySummarySettings(
      enabled: json['enabled'] ?? true,
      hour: json['hour'] ?? 22,
    );
  }
}

Future<DailySummarySettings?> getDailySummarySettings() async {
  return null;
}

Future<bool> setDailySummarySettings({bool? enabled, int? hour}) async {
  return true;
}

Future<List<DailySummary>> getDailySummaries({int limit = 30, int offset = 0}) async {
  return [];
}

Future<DailySummary?> getDailySummary(String summaryId) async {
  return null;
}

Future<bool> deleteDailySummary(String summaryId) async {
  return true;
}

Future<String?> generateDailySummary({String? date}) async {
  return null;
}

Future<Map<String, dynamic>?> getUserOnboardingState() async {
  return null;
}

Future<bool> updateUserOnboardingState({bool? completed, String? acquisitionSource}) async {
  return true;
}

class MentorNotificationSettings {
  final int frequency;

  MentorNotificationSettings({required this.frequency});

  factory MentorNotificationSettings.fromJson(Map<String, dynamic> json) {
    return MentorNotificationSettings(
      frequency: json['frequency'] ?? 0,
    );
  }
}

Future<MentorNotificationSettings?> getMentorNotificationSettings() async {
  return null;
}

Future<bool> setMentorNotificationSettings(int frequency) async {
  return true;
}

Future<String?> exportUserDataToFile(String filePath) async {
  return null;
}
