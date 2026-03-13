import 'package:flutter/material.dart';
import 'package:openpocket/services/leap_service.dart';
import 'package:openpocket/backend/preferences.dart';
import 'package:openpocket/pages/home/page.dart';

class ModelDownloadPage extends StatefulWidget {
  const ModelDownloadPage({super.key});

  @override
  State<ModelDownloadPage> createState() => _ModelDownloadPageState();
}

class _ModelDownloadPageState extends State<ModelDownloadPage> {
  bool _isDownloading = false;
  double _audioProgress = 0.0;
  double _textProgress = 0.0;
  bool _audioDownloaded = false;
  bool _textDownloaded = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _checkModels();
  }

  Future<void> _checkModels() async {
    final audioOk = await LeapService.instance.isModelDownloaded('audio');
    final textOk = await LeapService.instance.isModelDownloaded('text');
    setState(() {
      _audioDownloaded = audioOk;
      _textDownloaded = textOk;
      if (audioOk) _audioProgress = 1.0;
      if (textOk) _textProgress = 1.0;
    });
  }

  Future<void> _startDownload() async {
    setState(() {
      _isDownloading = true;
      _statusMessage = 'Downloading transcription model...';
    });

    LeapService.instance.setDownloadProgressHandler((modelType, progress) {
      setState(() {
        if (modelType == 'audio') _audioProgress = progress;
        if (modelType == 'text') _textProgress = progress;
      });
    });

    // Download audio model first
    final audioOk = await LeapService.instance.downloadModel('audio');
    setState(() {
      _audioDownloaded = audioOk;
      _statusMessage = 'Downloading summarization model...';
    });

    // Then text model
    final textOk = await LeapService.instance.downloadModel('text');
    setState(() {
      _textDownloaded = textOk;
      _isDownloading = false;
      _statusMessage = (audioOk && textOk) ? 'Models ready!' : 'Download failed. Please try again.';
    });

    LeapService.instance.setDownloadProgressHandler(null);
  }

  void _continue() {
    SharedPreferencesUtil().modelsDownloaded = true;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePageWrapper()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final allReady = _audioDownloaded && _textDownloaded;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.download_rounded, size: 64, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Set Up OpenPocket',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Download AI models for on-device transcription and summarization. This is a one-time setup (~2.3 GB).',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),

              // Audio model progress
              _buildModelCard(
                'Transcription Model',
                'LFM2.5-Audio-1.5B (~1.2 GB)',
                _audioProgress,
                _audioDownloaded,
              ),
              const SizedBox(height: 16),

              // Text model progress
              _buildModelCard(
                'Summarization Model',
                'LFM2-2.6B-Transcript (~1.1 GB)',
                _textProgress,
                _textDownloaded,
              ),

              const SizedBox(height: 24),
              if (_statusMessage.isNotEmpty)
                Text(
                  _statusMessage,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),

              const Spacer(),

              // Privacy message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.greenAccent, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'All processing happens on your device. No data leaves your phone.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: allReady
                      ? _continue
                      : (_isDownloading ? null : _startDownload),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allReady ? Colors.greenAccent : Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Text(
                    allReady
                        ? 'Continue'
                        : (_isDownloading ? 'Downloading...' : 'Download Models'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelCard(String title, String subtitle, double progress, bool downloaded) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                  ],
                ),
              ),
              if (downloaded)
                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 24)
              else if (progress > 0)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
            ],
          ),
          if (!downloaded && progress > 0) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
