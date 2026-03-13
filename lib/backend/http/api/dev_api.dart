import 'package:openpocket/backend/schema/dev_api_key.dart';

class DevApi {
  static Future<List<DevApiKey>> getDevApiKeys() async {
    return [];
  }

  static Future<DevApiKeyCreated> createDevApiKey(String name, {List<String>? scopes}) async {
    throw Exception('Not available in offline mode');
  }

  static Future<void> deleteDevApiKey(String keyId) async {
    // No-op
  }
}
