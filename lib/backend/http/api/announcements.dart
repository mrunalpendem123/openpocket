import 'package:openpocket/models/announcement.dart';

Future<List<Announcement>> getAppChangelogs({
  String? fromVersion,
  String? toVersion,
  String? maxVersion,
  int limit = 5,
}) async {
  return [];
}

Future<List<Announcement>> getPendingAnnouncements({
  required String appVersion,
  required String platform,
  required String trigger,
  String? firmwareVersion,
  String? deviceModel,
}) async {
  return [];
}

Future<bool> dismissAnnouncement(String announcementId, {bool ctaClicked = false}) async {
  return false;
}
