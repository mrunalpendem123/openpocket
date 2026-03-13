import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  static LocalStorageService get instance => _instance;
  LocalStorageService._internal();

  late Box<Map> _conversationsBox;
  late Box<Map> _memoriesBox;
  late Box<Map> _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _conversationsBox = await Hive.openBox<Map>('conversations');
    _memoriesBox = await Hive.openBox<Map>('memories');
    _settingsBox = await Hive.openBox<Map>('settings');
  }

  // Conversations
  Future<void> saveConversation(Map<String, dynamic> conversation) async {
    final id = conversation['id'] as String;
    await _conversationsBox.put(id, conversation);
  }

  Future<List<Map<String, dynamic>>> getConversations({
    int limit = 50,
    int offset = 0,
    bool includeDiscarded = true,
    bool? starred,
  }) async {
    var all = _conversationsBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    if (!includeDiscarded) {
      all = all.where((c) => c['discarded'] != true).toList();
    }
    if (starred == true) {
      all = all.where((c) => c['starred'] == true).toList();
    }

    // Sort by created_at descending
    all.sort((a, b) {
      final aDate = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });

    if (offset >= all.length) return [];
    return all.skip(offset).take(limit).toList();
  }

  Future<Map<String, dynamic>?> getConversationById(String id) async {
    final raw = _conversationsBox.get(id);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }

  Future<void> deleteConversation(String id) async {
    await _conversationsBox.delete(id);
  }

  Future<List<Map<String, dynamic>>> searchConversations(String query) async {
    final q = query.toLowerCase();
    return _conversationsBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .where((c) {
          final title = (c['structured']?['title'] ?? '').toString().toLowerCase();
          final overview = (c['structured']?['overview'] ?? '').toString().toLowerCase();
          return title.contains(q) || overview.contains(q);
        })
        .toList();
  }

  // Memories
  Future<void> saveMemory(Map<String, dynamic> memory) async {
    final id = memory['id'] as String;
    await _memoriesBox.put(id, memory);
  }

  Future<List<Map<String, dynamic>>> getMemories({int limit = 50, int offset = 0}) async {
    var all = _memoriesBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    all.sort((a, b) {
      final aDate = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(2000);
      final bDate = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
    if (offset >= all.length) return [];
    return all.skip(offset).take(limit).toList();
  }

  Future<void> deleteMemory(String id) async {
    await _memoriesBox.delete(id);
  }

  // Settings
  Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, {'value': value});
  }

  dynamic getSetting(String key) {
    return _settingsBox.get(key)?['value'];
  }

  // Storage info
  int get totalConversations => _conversationsBox.length;
  int get totalMemories => _memoriesBox.length;

  Future<void> clearAll() async {
    await _conversationsBox.clear();
    await _memoriesBox.clear();
    await _settingsBox.clear();
  }
}
