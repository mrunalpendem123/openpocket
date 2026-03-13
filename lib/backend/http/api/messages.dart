import 'dart:io';

import 'package:openpocket/backend/schema/message.dart';

Future<List<ServerMessage>> getMessagesServer({
  String? appId,
  bool dropdownSelected = false,
}) async {
  return [];
}

Future<List<ServerMessage>> clearChatServer({String? appId}) async {
  return [];
}

ServerMessageChunk? parseMessageChunk(String line, String messageId) {
  return null;
}

Stream<ServerMessageChunk> sendMessageStreamServer(String text, {String? appId, List<String>? filesId}) async* {
  // No-op in offline mode
}

Future<ServerMessage> getInitialAppMessage(String? appId) async {
  throw Exception('Not available in offline mode');
}

Stream<ServerMessageChunk> sendVoiceMessageStreamServer(List<File> files, {String? language}) async* {
  // No-op in offline mode
}

Future<List<MessageFile>?> uploadFilesServer(List<File> files, {String? appId}) async {
  return null;
}

Future reportMessageServer(String messageId) async {
  // No-op
}

Future<String> transcribeVoiceMessage(File audioFile, {String? language}) async {
  return '';
}
