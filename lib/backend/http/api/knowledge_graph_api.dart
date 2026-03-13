class KnowledgeGraphApi {
  static Future<Map<String, dynamic>> getKnowledgeGraph() async {
    return {'nodes': [], 'edges': []};
  }

  static Future<Map<String, dynamic>> rebuildKnowledgeGraph() async {
    return {'nodes': [], 'edges': []};
  }

  static Future<void> deleteKnowledgeGraph() async {
    // No-op
  }

  static Future<Map<String, dynamic>> waitForGraphStability({
    Duration timeout = const Duration(seconds: 45),
    Duration interval = const Duration(seconds: 2),
    int stabilityChecks = 2,
  }) async {
    return {'nodes': [], 'edges': []};
  }
}
