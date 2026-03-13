/// Audio file info from signed URL endpoint
class AudioFileUrlInfo {
  final String id;
  final String status;
  final String? signedUrl;
  final double duration;

  AudioFileUrlInfo({
    required this.id,
    required this.status,
    this.signedUrl,
    required this.duration,
  });

  factory AudioFileUrlInfo.fromJson(Map<String, dynamic> json) {
    return AudioFileUrlInfo(
      id: json['id'] ?? '',
      status: json['status'] ?? 'pending',
      signedUrl: json['signed_url'],
      duration: (json['duration'] ?? 0).toDouble(),
    );
  }

  bool get isCached => status == 'cached' && signedUrl != null;
}

String getAudioStreamUrl({
  required String conversationId,
  required String audioFileId,
  String format = 'wav',
}) {
  return '';
}

List<String> getConversationAudioUrls({
  required String conversationId,
  required List<String> audioFileIds,
  String format = 'wav',
}) {
  return [];
}

Future<Map<String, String>> getAudioHeaders() async {
  return {};
}

Future<void> precacheConversationAudio(String conversationId) async {
  // No-op
}

Future<List<AudioFileUrlInfo>> getConversationAudioSignedUrls(String conversationId) async {
  return [];
}
