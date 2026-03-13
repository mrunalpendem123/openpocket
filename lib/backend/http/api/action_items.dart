import 'package:openpocket/backend/schema/schema.dart';

Future<ActionItemsResponse> getActionItems({
  int limit = 50,
  int offset = 0,
  bool? completed,
  String? conversationId,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  return ActionItemsResponse(actionItems: [], hasMore: false);
}

Future<ActionItemWithMetadata?> getActionItem(String actionItemId) async {
  return null;
}

Future<ActionItemWithMetadata?> createActionItem({
  required String description,
  DateTime? dueAt,
  String? conversationId,
  bool completed = false,
}) async {
  return null;
}

Future<ActionItemWithMetadata?> updateActionItem(
  String actionItemId, {
  String? description,
  bool? completed,
  DateTime? dueAt,
  bool clearDueAt = false,
  bool? exported,
  DateTime? exportDate,
  String? exportPlatform,
  int? sortOrder,
  int? indentLevel,
}) async {
  return null;
}

Future<ActionItemWithMetadata?> toggleActionItemCompletion(String actionItemId, bool completed) async {
  return null;
}

Future<bool> deleteActionItem(String actionItemId) async {
  return false;
}

Future<ActionItemsResponse> getConversationActionItems(String conversationId) async {
  return ActionItemsResponse(actionItems: [], hasMore: false);
}

Future<bool> deleteConversationActionItems(String conversationId) async {
  return false;
}

Future<Map<String, dynamic>?> shareActionItems(List<String> taskIds) async {
  return null;
}

Future<Map<String, dynamic>?> getSharedActionItems(String token) async {
  return null;
}

Future<Map<String, dynamic>?> acceptSharedActionItems(String token) async {
  return null;
}

Future<bool> batchUpdateActionItems(List<Map<String, dynamic>> items) async {
  return false;
}

Future<List<ActionItemWithMetadata>> createActionItemsBatch(List<Map<String, dynamic>> actionItems) async {
  return [];
}
