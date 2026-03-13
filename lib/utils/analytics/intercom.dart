import 'dart:async';

/// Stub for Intercom SDK's Intercom class
class _IntercomStub {
  Future<void> displayMessenger() async {}
  Future<void> displayArticle(String articleId) async {}
}

class IntercomManager {
  static final IntercomManager _instance = IntercomManager._internal();
  static IntercomManager get instance => _instance;

  IntercomManager._internal();

  factory IntercomManager() {
    return _instance;
  }

  _IntercomStub get intercom => _IntercomStub();

  Future<void> initIntercom() async {}

  Future displayChargingArticle(String device) async {}

  Future loginIdentifiedUser(String uid) async {}

  Future loginUnidentifiedUser() async {}

  Future displayEarnMoneyArticle() async {}

  Future displayFirmwareUpdateArticle() async {}

  Future logEvent(String eventName, {Map<String, dynamic>? metaData}) async {}

  Future updateCustomAttributes(Map<String, dynamic> attributes) async {}

  Future updateUser(String? email, String? name, String? uid) async {}

  Future<void> setUserAttributes() async {}

  Future<void> sendTokenToIntercom(String token) async {}
}
