import 'package:openpocket/backend/schema/memory.dart';

Future<Memory?> createMemoryServer(String content, String visibility, String category) async {
  return null;
}

Future<bool> updateMemoryVisibilityServer(String memoryId, String visibility) async {
  return false;
}

Future<List<Memory>> getMemories({int limit = 100, int offset = 0}) async {
  return [];
}

Future<bool> deleteMemoryServer(String memoryId) async {
  return false;
}

Future<bool> deleteAllMemoriesServer() async {
  return false;
}

Future<bool> editMemoryServer(String memoryId, String value) async {
  return false;
}
