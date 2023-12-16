// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class AppConfig {
  GetStorage box = GetStorage();
  String BASE_URL = "";
  String API_KEY = "";
  String PACKAGE_NAME = "";
  String PRIVACY_POLICY = "";
  String TERMS_OF_USE = "";
  String EMAIL = "";
  String REVENUECAT_API_KEY = "";

  AppConfig(this.BASE_URL, this.API_KEY, this.PACKAGE_NAME);

  Map toJson() => {
        'BASE_URL ': BASE_URL,
        'API_KEY': API_KEY,
        'PACKAGE_NAME': PACKAGE_NAME,
        'PRIVACY_POLICY': PRIVACY_POLICY,
        'TERMS_OF_USE': TERMS_OF_USE,
        'EMAIL': EMAIL,
        'REVENUECAT_API_KEY': REVENUECAT_API_KEY,
      };

  void itemParser(dynamic item) {
    if (item != null) {
      try {
        if (item.containsKey("BASE_URL ")) BASE_URL = item["BASE_URL "];
        if (item.containsKey("API_KEY")) API_KEY = item["API_KEY"];
        if (item.containsKey("PACKAGE_NAME")) PACKAGE_NAME = item["PACKAGE_NAME"];
        if (item.containsKey("PRIVACY_POLICY")) PRIVACY_POLICY = item["PRIVACY_POLICY"];
        if (item.containsKey("TERMS_OF_USE")) TERMS_OF_USE = item["TERMS_OF_USE"];
        if (item.containsKey("EMAIL")) EMAIL = item["EMAIL"];
        if (item.containsKey("REVENUECAT_API_KEY")) REVENUECAT_API_KEY = item["REVENUECAT_API_KEY"];
      } catch (e) {
        print(e);
      }
    }
  }

  AppConfig.fromBoxStorage() {
    GetStorage box = GetStorage();
    itemParser(box.read("AppConfig"));
    if (kDebugMode) print("AppConfig ${box.read("AppConfig")}");
  }

  void toBoxStorage() {
    GetStorage box = GetStorage();
    box.remove("AppConfig");
    box.write("AppConfig", toJson());
    if (kDebugMode) print("AppConfig ${box.read("AppConfig")}");
  }
}
