import 'package:openpocket/backend/preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;

  AuthService._internal();

  bool isSignedIn() => true;

  dynamic getFirebaseUser() => null;

  Future<dynamic> signInWithGoogleMobile() async => null;

  String generateNonce([int length = 32]) => '';

  String sha256ofString(String input) => '';

  Future<dynamic> signInWithAppleMobile() async => null;

  Future<void> signInAnonymously() async {}

  Future<void> signOut() async {
    _clearCachedAuth();
  }

  void _clearCachedAuth() {
    SharedPreferencesUtil().authToken = '';
    SharedPreferencesUtil().tokenExpirationTime = 0;
  }

  Future<String?> getIdToken() async {
    return 'offline-token';
  }

  Future<dynamic> authenticateWithProvider(String provider) async => null;

  Future<void> _updateUserPreferences(dynamic result, String provider) async {}

  Future<void> restoreOnboardingState() async {}

  Future<void> updateGivenName(String fullName) async {
    SharedPreferencesUtil().givenName = fullName.split(' ')[0];
    if (fullName.split(' ').length > 1) {
      SharedPreferencesUtil().familyName = fullName.split(' ').sublist(1).join(' ');
    }
  }

  Future<dynamic> linkWithProvider(String provider) async {}

  Future<dynamic> linkWithGoogle() async {
    return await linkWithProvider('google');
  }

  Future<dynamic> linkWithApple() async {
    return await linkWithProvider('apple');
  }
}
