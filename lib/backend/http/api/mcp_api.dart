import 'package:openpocket/backend/schema/mcp_api_key.dart';

class McpApi {
  static Future<List<McpApiKey>> getMcpApiKeys() async {
    return [];
  }

  static Future<McpApiKeyCreated> createMcpApiKey(String name) async {
    throw Exception('Not available in offline mode');
  }

  static Future<void> deleteMcpApiKey(String keyId) async {
    // No-op
  }
}
