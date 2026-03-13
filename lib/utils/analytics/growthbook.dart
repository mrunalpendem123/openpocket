class GrowthbookUtil {
  static final GrowthbookUtil _instance = GrowthbookUtil._internal();

  factory GrowthbookUtil() {
    return _instance;
  }

  GrowthbookUtil._internal();

  static Future<void> init() async {
    // No-op — GrowthBook removed
  }

  bool displayOmiFeedback() => false;

  bool displayMemoriesSearchBar() => false;

  bool isOmiFeedbackEnabled() => false;
}
