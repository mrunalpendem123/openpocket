import 'dart:convert';

/// Goal model
class Goal {
  final String id;
  final String title;
  final String goalType;
  final double targetValue;
  final double currentValue;
  final double minValue;
  final double maxValue;
  final String? unit;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Goal({
    required this.id,
    required this.title,
    required this.goalType,
    required this.targetValue,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    this.unit,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      goalType: json['goal_type'] ?? 'scale',
      targetValue: (json['target_value'] ?? 0).toDouble(),
      currentValue: (json['current_value'] ?? 0).toDouble(),
      minValue: (json['min_value'] ?? 0).toDouble(),
      maxValue: (json['max_value'] ?? 10).toDouble(),
      unit: json['unit'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'goal_type': goalType,
      'target_value': targetValue,
      'current_value': currentValue,
      'min_value': minValue,
      'max_value': maxValue,
      'unit': unit,
      'is_active': isActive,
    };
  }

  double get progressPercentage {
    if (targetValue <= 0) return currentValue > 0 ? 1.0 : 0.0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }
}

class GoalHistoryEntry {
  final String date;
  final double value;
  final DateTime recordedAt;

  GoalHistoryEntry({
    required this.date,
    required this.value,
    required this.recordedAt,
  });

  factory GoalHistoryEntry.fromJson(Map<String, dynamic> json) {
    return GoalHistoryEntry(
      date: json['date'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      recordedAt: json['recorded_at'] != null ? DateTime.parse(json['recorded_at']) : DateTime.now(),
    );
  }
}

class GoalSuggestion {
  final String suggestedTitle;
  final String suggestedType;
  final double suggestedTarget;
  final double suggestedMin;
  final double suggestedMax;
  final String reasoning;

  GoalSuggestion({
    required this.suggestedTitle,
    required this.suggestedType,
    required this.suggestedTarget,
    required this.suggestedMin,
    required this.suggestedMax,
    required this.reasoning,
  });

  factory GoalSuggestion.fromJson(Map<String, dynamic> json) {
    return GoalSuggestion(
      suggestedTitle: json['suggested_title'] ?? '',
      suggestedType: json['suggested_type'] ?? 'scale',
      suggestedTarget: (json['suggested_target'] ?? 10).toDouble(),
      suggestedMin: (json['suggested_min'] ?? 0).toDouble(),
      suggestedMax: (json['suggested_max'] ?? 10).toDouble(),
      reasoning: json['reasoning'] ?? '',
    );
  }
}

Future<Goal?> getCurrentGoal() async {
  return null;
}

Future<List<Goal>> getAllGoals() async {
  return [];
}

Future<Goal?> createGoal({
  required String title,
  required String goalType,
  required double targetValue,
  double currentValue = 0,
  double minValue = 0,
  double maxValue = 10,
  String? unit,
}) async {
  return null;
}

Future<Goal?> updateGoal(
  String goalId, {
  String? title,
  double? targetValue,
  double? currentValue,
  double? minValue,
  double? maxValue,
  String? unit,
}) async {
  return null;
}

Future<Goal?> updateGoalProgress(String goalId, double currentValue) async {
  return null;
}

Future<List<GoalHistoryEntry>> getGoalHistory(String goalId, {int days = 30}) async {
  return [];
}

Future<bool> deleteGoal(String goalId) async {
  return false;
}

Future<GoalSuggestion?> suggestGoal() async {
  return null;
}

Future<String?> getGoalAdvice() async {
  return null;
}

Future<String?> getGoalAdviceById(String goalId) async {
  return null;
}
