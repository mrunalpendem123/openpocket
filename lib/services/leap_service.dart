import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class LeapService {
  static final LeapService _instance = LeapService._internal();
  static LeapService get instance => _instance;
  LeapService._internal();

  static const _channel = MethodChannel('com.openpocket/leap');

  bool _audioModelLoaded = false;
  bool _textModelLoaded = false;

  bool get isAudioModelLoaded => _audioModelLoaded;
  bool get isTextModelLoaded => _textModelLoaded;

  Future<bool> loadModel(String modelType) async {
    try {
      final result = await _channel.invokeMethod<bool>('loadModel', {'modelType': modelType});
      if (modelType == 'audio') _audioModelLoaded = result ?? false;
      if (modelType == 'text') _textModelLoaded = result ?? false;
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to load LEAP model: ${e.message}');
      return false;
    }
  }

  Future<String> transcribe(Uint8List audioData, {String language = 'en'}) async {
    try {
      final result = await _channel.invokeMethod<String>('transcribe', {
        'audioData': audioData,
        'language': language,
      });
      return result ?? '';
    } on PlatformException catch (e) {
      print('LEAP transcription failed: ${e.message}');
      return '';
    }
  }

  Future<Map<String, dynamic>> summarize(String transcript) async {
    try {
      final result = await _channel.invokeMethod<String>('summarize', {
        'transcript': transcript,
      });
      if (result == null || result.isEmpty) {
        return {'title': 'Conversation', 'overview': transcript, 'actionItems': []};
      }
      // Parse JSON result from native
      final parsed = jsonDecode(result);
      if (parsed is Map<String, dynamic>) return parsed;
      return {'title': 'Conversation', 'overview': transcript, 'actionItems': []};
    } on PlatformException catch (e) {
      print('LEAP summarization failed: ${e.message}');
      return {'title': 'Conversation', 'overview': transcript, 'actionItems': []};
    }
  }

  Future<bool> isModelDownloaded(String modelType) async {
    try {
      final result = await _channel.invokeMethod<bool>('isModelDownloaded', {'modelType': modelType});
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<double> getDownloadProgress(String modelType) async {
    try {
      final result = await _channel.invokeMethod<double>('getDownloadProgress', {'modelType': modelType});
      return result ?? 0.0;
    } on PlatformException {
      return 0.0;
    }
  }

  Future<bool> downloadModel(String modelType) async {
    try {
      final result = await _channel.invokeMethod<bool>('downloadModel', {'modelType': modelType});
      return result ?? false;
    } on PlatformException catch (e) {
      print('LEAP model download failed: ${e.message}');
      return false;
    }
  }

  /// Send a chat message to the text model and get a response
  Future<String> chat(String message) async {
    try {
      final result = await _channel.invokeMethod<String>('chat', {
        'message': message,
      });
      return result ?? '';
    } on PlatformException catch (e) {
      print('LEAP chat failed: ${e.message}');
      return '';
    }
  }

  /// Check if both models are ready
  bool get isReady => _audioModelLoaded && _textModelLoaded;

  /// Initialize both models
  Future<bool> initializeModels() async {
    final audioOk = await loadModel('audio');
    final textOk = await loadModel('text');
    return audioOk && textOk;
  }

  void setDownloadProgressHandler(Function(String modelType, double progress)? handler) {
    if (handler != null) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'onDownloadProgress') {
          final args = call.arguments as Map;
          handler(args['modelType'] as String, args['progress'] as double);
        }
      });
    } else {
      _channel.setMethodCallHandler(null);
    }
  }
}
