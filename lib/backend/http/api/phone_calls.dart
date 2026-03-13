import 'package:openpocket/backend/schema/phone_call.dart';

Future<Map<String, dynamic>?> verifyPhoneNumber(String phoneNumber) async {
  return null;
}

Future<Map<String, dynamic>?> checkPhoneVerification(String phoneNumber) async {
  return null;
}

Future<List<VerifiedPhoneNumber>> getVerifiedPhoneNumbers() async {
  return [];
}

Future<bool> deleteVerifiedPhoneNumber(String phoneNumberId) async {
  return false;
}

Future<PhoneCallToken?> getPhoneCallToken() async {
  return null;
}

String buildPhoneCallWebSocketUrl({
  required String callId,
  required String uid,
  int sampleRate = 48000,
  String codec = 'pcm',
  String language = 'en',
}) {
  return '';
}
