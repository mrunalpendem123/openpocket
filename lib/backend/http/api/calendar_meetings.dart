import 'package:openpocket/backend/schema/calendar_meeting_context.dart';

class StoreMeetingResponse {
  final String meetingId;
  final String calendarEventId;
  final String message;

  StoreMeetingResponse({
    required this.meetingId,
    required this.calendarEventId,
    required this.message,
  });

  factory StoreMeetingResponse.fromJson(Map<String, dynamic> json) {
    return StoreMeetingResponse(
      meetingId: json['meeting_id'] ?? '',
      calendarEventId: json['calendar_event_id'] ?? '',
      message: json['message'] ?? 'Meeting stored successfully',
    );
  }
}

Future<StoreMeetingResponse?> storeMeeting({
  required String calendarEventId,
  required String calendarSource,
  required String title,
  required DateTime startTime,
  required DateTime endTime,
  String? platform,
  String? meetingLink,
  List<MeetingParticipant>? participants,
  String? notes,
}) async {
  return null;
}

Future<CalendarMeetingContext?> getMeeting(String meetingId) async {
  return null;
}

Future<List<CalendarMeetingContext>> listMeetings({
  DateTime? startDate,
  DateTime? endDate,
  int limit = 50,
}) async {
  return [];
}
