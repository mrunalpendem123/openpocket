import 'dart:io';

import 'package:openpocket/backend/schema/schema.dart';
import 'package:openpocket/services/local_storage_service.dart';

final _storage = LocalStorageService.instance;

Future<CreateConversationResponse?> processInProgressConversation() async {
  return null;
}

Future<List<ServerConversation>> getConversations({
  int limit = 50,
  int offset = 0,
  List<ConversationStatus> statuses = const [],
  bool includeDiscarded = true,
  DateTime? startDate,
  DateTime? endDate,
  String? folderId,
  bool? starred,
}) async {
  final maps = await _storage.getConversations(
    limit: limit,
    offset: offset,
    includeDiscarded: includeDiscarded,
    starred: starred,
  );
  return maps.map((m) => ServerConversation.fromJson(m)).toList();
}

Future<ServerConversation?> reProcessConversationServer(String conversationId, {String? appId}) async {
  return null;
}

Future<bool> deleteConversationServer(String conversationId) async {
  await _storage.deleteConversation(conversationId);
  return true;
}

Future<ServerConversation?> getConversationById(String conversationId) async {
  final map = await _storage.getConversationById(conversationId);
  if (map == null) return null;
  return ServerConversation.fromJson(map);
}

Future<bool> updateConversationTitle(String conversationId, String title) async {
  final map = await _storage.getConversationById(conversationId);
  if (map == null) return true;
  if (map['structured'] == null) {
    map['structured'] = {};
  }
  (map['structured'] as Map)['title'] = title;
  await _storage.saveConversation(map);
  return true;
}

Future<bool> updateConversationSegmentText(String conversationId, String segmentId, String text) async {
  return true;
}

Future<List<ConversationPhoto>> getConversationPhotos(String conversationId) async {
  return [];
}

class TranscriptsResponse {
  List<TranscriptSegment> deepgram;
  List<TranscriptSegment> soniox;
  List<TranscriptSegment> whisperx;
  List<TranscriptSegment> speechmatics;

  TranscriptsResponse({
    this.deepgram = const [],
    this.soniox = const [],
    this.whisperx = const [],
    this.speechmatics = const [],
  });

  factory TranscriptsResponse.fromJson(Map<String, dynamic> json) {
    return TranscriptsResponse(
      deepgram: (json['deepgram'] as List<dynamic>).map((segment) => TranscriptSegment.fromJson(segment)).toList(),
      soniox: (json['soniox'] as List<dynamic>).map((segment) => TranscriptSegment.fromJson(segment)).toList(),
      whisperx: (json['whisperx'] as List<dynamic>).map((segment) => TranscriptSegment.fromJson(segment)).toList(),
      speechmatics:
          (json['speechmatics'] as List<dynamic>).map((segment) => TranscriptSegment.fromJson(segment)).toList(),
    );
  }
}

Future<TranscriptsResponse> getConversationTranscripts(String conversationId) async {
  return TranscriptsResponse();
}

Future<bool> hasConversationRecording(String conversationId) async {
  return true;
}

Future<bool> assignBulkConversationTranscriptSegments(
  String conversationId,
  List<String> segmentIds, {
  bool? isUser,
  String? personId,
}) async {
  return true;
}

Future<bool> setConversationVisibility(String conversationId, {String visibility = 'shared'}) async {
  return true;
}

Future<bool> setConversationStarred(String conversationId, bool starred) async {
  final map = await _storage.getConversationById(conversationId);
  if (map == null) return true;
  map['starred'] = starred;
  await _storage.saveConversation(map);
  return true;
}

Future<bool> setConversationEventsState(
  String conversationId,
  List<int> eventsIdx,
  List<bool> values,
) async {
  return true;
}

Future<bool> setConversationActionItemState(
  String conversationId,
  List<int> actionItemsIdx,
  List<bool> values,
) async {
  return true;
}

Future<bool> updateActionItemDescription(
    String conversationId, String oldDescription, String newDescription, int idx) async {
  return true;
}

Future<bool> deleteConversationActionItem(String conversationId, ActionItem item) async {
  return true;
}

Future<List<ServerConversation>> sendStorageToBackend(File file, String sdCardDateTimeString) async {
  return [];
}

Future<SyncLocalFilesResponse> syncLocalFiles(List<File> files) async {
  throw Exception('Sync not available in offline mode');
}

Future<(List<ServerConversation>, int, int)> searchConversationsServer(
  String query, {
  int? page,
  int? limit,
  bool includeDiscarded = true,
}) async {
  final maps = await _storage.searchConversations(query);
  final convos = maps.map((m) => ServerConversation.fromJson(m)).toList();
  return (convos, 1, 1);
}

Future<String> testConversationPrompt(String prompt, String conversationId) async {
  return '';
}

// *********************************
// ******** ACTION ITEMS ***********
// *********************************

Future<ActionItemsResponse> getActionItems({
  int limit = 50,
  int offset = 0,
  bool includeCompleted = true,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  return ActionItemsResponse(actionItems: [], hasMore: false);
}

Future<List<App>> getConversationSuggestedApps(String conversationId) async {
  return [];
}

Future<bool> updateActionItemStateByMetadata(
  String conversationId,
  int itemIndex,
  bool newState,
) async {
  return true;
}

// *********************************
// ******** MERGE CONVERSATIONS ****
// *********************************

class MergeConversationsResponse {
  final String status;
  final String message;
  final String? warning;
  final List<String> conversationIds;

  MergeConversationsResponse({
    required this.status,
    required this.message,
    this.warning,
    required this.conversationIds,
  });

  factory MergeConversationsResponse.fromJson(Map<String, dynamic> json) {
    return MergeConversationsResponse(
      status: json['status'] ?? 'merging',
      message: json['message'] ?? 'Merge started',
      warning: json['warning'],
      conversationIds: List<String>.from(json['conversation_ids'] ?? []),
    );
  }
}

Future<MergeConversationsResponse?> mergeConversations(
  List<String> conversationIds, {
  bool reprocess = true,
}) async {
  return null;
}
