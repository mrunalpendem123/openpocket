class MigrationRequest {
  final String id;
  final String type;
  final String targetLevel;

  MigrationRequest({
    required this.id,
    required this.type,
    required this.targetLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'target_level': targetLevel,
    };
  }
}

class PrivacyApi {
  static Future<Map<String, dynamic>> getUserProfile() async {
    return {};
  }

  static Future<void> startMigration(String targetLevel) async {
    // No-op
  }

  static Future<List<MigrationRequest>> checkMigration(String targetLevel) async {
    return [];
  }

  static Future<void> migrateObject(MigrationRequest request) async {
    // No-op
  }

  static Future<void> migrateObjectsBatch(List<MigrationRequest> requests) async {
    // No-op
  }

  static Future<void> finalizeMigration(String targetLevel) async {
    // No-op
  }
}
