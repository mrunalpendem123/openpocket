/// Wrapped status enum
enum WrappedStatus {
  notGenerated,
  processing,
  done,
  error,
}

/// Wrapped 2025 response model
class Wrapped2025Response {
  final WrappedStatus status;
  final int year;
  final Map<String, dynamic>? result;
  final String? error;
  final Map<String, dynamic>? progress;

  Wrapped2025Response({
    required this.status,
    this.year = 2025,
    this.result,
    this.error,
    this.progress,
  });

  factory Wrapped2025Response.fromJson(Map<String, dynamic> json) {
    WrappedStatus status;
    switch (json['status']) {
      case 'done':
        status = WrappedStatus.done;
        break;
      case 'processing':
        status = WrappedStatus.processing;
        break;
      case 'error':
        status = WrappedStatus.error;
        break;
      default:
        status = WrappedStatus.notGenerated;
    }

    return Wrapped2025Response(
      status: status,
      year: json['year'] ?? 2025,
      result: json['result'],
      error: json['error'],
      progress: json['progress'],
    );
  }
}

Future<Wrapped2025Response?> getWrapped2025() async {
  return null;
}

Future<Wrapped2025Response?> generateWrapped2025() async {
  return null;
}
