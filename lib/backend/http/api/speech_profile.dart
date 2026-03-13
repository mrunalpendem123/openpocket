import 'dart:io';

Future<bool> userHasSpeakerProfile() async {
  return true;
}

Future<String?> getUserSpeechProfile() async {
  return null;
}

Future<bool> uploadProfile(File file) async {
  return false;
}

Future<List<String>> getExpandedProfileSamples() async {
  return [];
}

Future<bool> deleteProfileSample(
  String conversationId,
  int segmentIdx, {
  String? personId,
}) async {
  return false;
}
