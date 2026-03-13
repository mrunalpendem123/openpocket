import 'package:openpocket/pages/payments/models/payment_method_config.dart';

Future<Map<String, dynamic>?> getStripeAccountLink(String? country) async {
  return null;
}

Future<bool> isStripeOnboardingComplete() async {
  return false;
}

Future<bool> savePayPalDetails(String email, String link) async {
  return false;
}

Future<Map<String, dynamic>?> fetchPaymentMethodsStatus() async {
  return null;
}

Future<PayPalDetails?> fetchPayPalDetails() async {
  return null;
}

Future<bool> setDefaultPaymentMethod(String method) async {
  return false;
}

Future<List?> getStripeSupportedCountries() async {
  return null;
}
