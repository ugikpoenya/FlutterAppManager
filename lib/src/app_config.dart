import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class AppConfig extends GetxController {
  GetStorage box = GetStorage();

  void setBaseUrl(String value) {
    box.write("BASE_URL", value);
  }

  String getBaseUrl() {
    return box.read("BASE_URL");
  }

  void setApiKey(String value) {
    box.write("API_KEY", value);
  }

  String getApiKey() {
    return box.read("API_KEY");
  }

  void setPackageName(String value) {
    box.write("PACKAGE_NAME", value);
  }

  String getPackageName() {
    return box.read("PACKAGE_NAME");
  }

  void setRevenuecatApiKey(String value) {
    box.write("REVENUECAT_API_KEY", value);
  }

  String getRevenuecatApiKey() {
    return box.read("REVENUECAT_API_KEY");
  }

  void setPrivacyPolicy(String value) {
    box.write("PRIVACY_POLICY", value);
  }

  String getPrivacyPolicy() {
    return box.read("PRIVACY_POLICY");
  }

  void setTermsOfUse(String value) {
    box.write("TERMS_OF_USE", value);
  }

  String getTermsOfUse() {
    return box.read("TERMS_OF_USE");
  }

  void setEmail(String value) {
    box.write("EMAIL", value);
  }

  String getEmail() {
    return box.read("EMAIL");
  }
}
