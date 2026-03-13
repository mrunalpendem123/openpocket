import 'package:openpocket/backend/schema/folder.dart';

Future<List<Folder>> getFolders() async {
  return [];
}

Future<Folder?> createFolderApi({
  required String name,
  String? description,
  String? color,
  String? icon,
}) async {
  return null;
}

Future<Folder?> updateFolderApi(
  String folderId, {
  String? name,
  String? description,
  String? color,
  String? icon,
  int? order,
}) async {
  return null;
}

Future<bool> deleteFolderApi(String folderId, {String? moveToFolderId}) async {
  return false;
}

Future<bool> moveConversationToFolderApi(
  String conversationId,
  String? folderId,
) async {
  return false;
}

Future<int> bulkMoveConversationsToFolderApi(
  String folderId,
  List<String> conversationIds,
) async {
  return 0;
}

Future<bool> reorderFoldersApi(List<String> folderIds) async {
  return false;
}
