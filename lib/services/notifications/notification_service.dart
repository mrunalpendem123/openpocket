import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:openpocket/backend/schema/message.dart';
import 'package:openpocket/services/notifications/notification_interface.dart';

/// No-op notification service for offline mode
class _NoOpNotificationService implements NotificationInterface {
  _NoOpNotificationService._();

  final _serverMessageStreamController = StreamController<ServerMessage>.broadcast();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, String?>? payload,
    bool wakeUpScreen = false,
    NotificationSchedule? schedule,
    NotificationLayout layout = NotificationLayout.Default,
  }) async {}

  @override
  Future<bool> requestNotificationPermissions() async => false;

  @override
  Future<void> register() async {}

  @override
  Future<String> getTimeZone() async => 'UTC';

  @override
  Future<void> saveFcmToken(String? token) async {}

  @override
  void saveNotificationToken() {}

  @override
  Future<bool> hasNotificationPermissions() async => false;

  @override
  Future<void> createNotification({
    String title = '',
    String body = '',
    int notificationId = 1,
    Map<String, String?>? payload,
  }) async {}

  @override
  void clearNotification(int id) {}

  @override
  Future<void> listenForMessages() async {}

  @override
  Stream<ServerMessage> get listenForServerMessages => _serverMessageStreamController.stream;
}

/// Singleton notification service instance
class NotificationService {
  static NotificationInterface? _instance;

  /// Get the singleton notification service instance
  static NotificationInterface get instance {
    _instance ??= _NoOpNotificationService._();
    return _instance!;
  }

  /// Clear the instance (useful for testing)
  static void reset() {
    _instance = null;
  }
}
