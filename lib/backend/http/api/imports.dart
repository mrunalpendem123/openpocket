import 'dart:io';

/// Import job status enum matching the backend
enum ImportJobStatus {
  pending,
  processing,
  completed,
  failed;

  static ImportJobStatus fromString(String status) {
    switch (status) {
      case 'pending':
        return ImportJobStatus.pending;
      case 'processing':
        return ImportJobStatus.processing;
      case 'completed':
        return ImportJobStatus.completed;
      case 'failed':
        return ImportJobStatus.failed;
      default:
        return ImportJobStatus.pending;
    }
  }
}

class ImportJobResponse {
  final String jobId;
  final ImportJobStatus status;
  final int? totalFiles;
  final int? processedFiles;
  final int? conversationsCreated;
  final DateTime? createdAt;
  final String? error;

  ImportJobResponse({
    required this.jobId,
    required this.status,
    this.totalFiles,
    this.processedFiles,
    this.conversationsCreated,
    this.createdAt,
    this.error,
  });

  factory ImportJobResponse.fromJson(Map<String, dynamic> json) {
    return ImportJobResponse(
      jobId: json['job_id'] as String,
      status: ImportJobStatus.fromString(json['status'] as String),
      totalFiles: json['total_files'] as int?,
      processedFiles: json['processed_files'] as int?,
      conversationsCreated: json['conversations_created'] as int?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      error: json['error'] as String?,
    );
  }

  double get progress {
    if (totalFiles == null || totalFiles == 0) return 0;
    return (processedFiles ?? 0) / totalFiles!;
  }

  bool get isCompleted => status == ImportJobStatus.completed;
  bool get isFailed => status == ImportJobStatus.failed;
  bool get isProcessing => status == ImportJobStatus.processing || status == ImportJobStatus.pending;
}

Future<ImportJobResponse?> startLimitlessImport(File zipFile, {String language = 'en'}) async {
  return null;
}

Future<ImportJobResponse?> getImportJobStatus(String jobId) async {
  return null;
}

Future<List<ImportJobResponse>> getImportJobs({int limit = 50}) async {
  return [];
}

Future<int?> deleteLimitlessConversations() async {
  return null;
}
