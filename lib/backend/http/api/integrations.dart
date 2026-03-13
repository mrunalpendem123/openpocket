/// Response model for integration
class IntegrationResponse {
  final bool connected;
  final String appKey;

  IntegrationResponse({
    required this.connected,
    required this.appKey,
  });

  factory IntegrationResponse.fromJson(Map<String, dynamic> json) {
    return IntegrationResponse(
      connected: json['connected'] as bool? ?? false,
      appKey: json['app_key'] as String? ?? '',
    );
  }
}

Future<IntegrationResponse?> getIntegration(String appKey) async {
  return null;
}

Future<bool> saveIntegration(String appKey, Map<String, dynamic> details) async {
  return false;
}

Future<bool> deleteIntegration(String appKey) async {
  return false;
}

Future<String?> getIntegrationOAuthUrl(String appKey) async {
  return null;
}

class GitHubRepository {
  final String fullName;
  final String name;
  final String owner;
  final bool isPrivate;
  final String? description;
  final String updatedAt;

  GitHubRepository({
    required this.fullName,
    required this.name,
    required this.owner,
    required this.isPrivate,
    this.description,
    required this.updatedAt,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      fullName: json['full_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      isPrivate: json['private'] as bool? ?? false,
      description: json['description'] as String?,
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}

Future<List<GitHubRepository>> getGitHubRepositories() async {
  return [];
}

Future<bool> setGitHubDefaultRepo(String defaultRepo) async {
  return false;
}

Future<bool> syncAppleHealthData(Map<String, dynamic> healthData) async {
  return false;
}
