/// Response model for task integrations
class TaskIntegrationsResponse {
  final Map<String, dynamic> integrations;
  final String? defaultApp;

  TaskIntegrationsResponse({
    required this.integrations,
    this.defaultApp,
  });

  factory TaskIntegrationsResponse.fromJson(Map<String, dynamic> json) {
    return TaskIntegrationsResponse(
      integrations: json['integrations'] as Map<String, dynamic>? ?? {},
      defaultApp: json['default_app'] as String?,
    );
  }
}

Future<TaskIntegrationsResponse?> getTaskIntegrations() async {
  return null;
}

Future<String?> getDefaultTaskIntegration() async {
  return null;
}

Future<bool> setDefaultTaskIntegration(String appKey) async {
  return false;
}

Future<bool> saveTaskIntegration(String appKey, Map<String, dynamic> details) async {
  return false;
}

Future<bool> deleteTaskIntegration(String appKey) async {
  return false;
}

Future<String?> getOAuthUrl(String appKey) async {
  return null;
}

Future<Map<String, dynamic>?> createTaskViaIntegration(
  String appKey, {
  required String title,
  String? description,
  DateTime? dueDate,
}) async {
  return null;
}

Future<List<Map<String, dynamic>>?> getAsanaWorkspaces() async {
  return null;
}

Future<List<Map<String, dynamic>>?> getAsanaProjects(String workspaceGid) async {
  return null;
}

Future<List<Map<String, dynamic>>?> getClickUpTeams() async {
  return null;
}

Future<List<Map<String, dynamic>>?> getClickUpSpaces(String teamId) async {
  return null;
}

Future<List<Map<String, dynamic>>?> getClickUpLists(String spaceId) async {
  return null;
}
