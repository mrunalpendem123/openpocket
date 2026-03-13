import 'dart:typed_data';

import 'package:openpocket/models/stt_result.dart';
import 'package:openpocket/services/custom_stt_log_service.dart';
import 'package:openpocket/services/leap_service.dart';
import 'package:openpocket/services/sockets/pure_polling.dart';

class OnDeviceLeapProvider implements ISttProvider {
  final String language;

  OnDeviceLeapProvider({this.language = 'en'});

  @override
  Future<SttTranscriptionResult?> transcribe(
    Uint8List audioData, {
    double audioOffsetSeconds = 0,
    String? language,
  }) async {
    if (!LeapService.instance.isAudioModelLoaded) {
      CustomSttLogService.instance.warning('OnDeviceLeap', 'Audio model not loaded');
      return null;
    }

    try {
      final sw = Stopwatch()..start();

      String effectiveLanguage = language ?? this.language;
      if (effectiveLanguage == 'multi') {
        effectiveLanguage = 'en';
      }

      final text = await LeapService.instance.transcribe(
        audioData,
        language: effectiveLanguage,
      );

      if (text.isEmpty) return null;

      // Calculate duration: 16kHz, 16-bit mono = 32000 bytes/sec
      final durationSeconds = audioData.lengthInBytes / 32000.0;

      CustomSttLogService.instance.info('OnDeviceLeap',
          'Transcribed ${durationSeconds.toStringAsFixed(1)}s in ${sw.elapsedMilliseconds}ms. Text: $text');

      return SttTranscriptionResult(
        segments: [
          SttSegment(
            text: text.trim(),
            speakerId: 0,
            start: audioOffsetSeconds,
            end: audioOffsetSeconds + durationSeconds,
          ),
        ],
        rawText: text.trim(),
      );
    } catch (e) {
      CustomSttLogService.instance.error('OnDeviceLeap', 'Transcription error: $e');
      return null;
    }
  }

  @override
  void dispose() {
    // LEAP models are managed by LeapService singleton
  }
}
