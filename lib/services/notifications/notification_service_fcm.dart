// FCM notification service stub — Firebase Cloud Messaging removed for offline mode.
// This file is kept so that any residual imports do not break compilation.

import 'package:openpocket/services/notifications/notification_interface.dart';
import 'package:openpocket/services/notifications/notification_service.dart';

/// Factory function retained for backward compatibility.
/// Returns the same no-op implementation used by NotificationService.
NotificationInterface createNotificationService() => NotificationService.instance;
