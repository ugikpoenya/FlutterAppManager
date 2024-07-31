import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';
import 'package:sample_app/app/Config.dart';
import 'package:sample_app/app/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  RxBool isProgress = true.obs;
  void initAds() {
    isProgress.value = true;
    ServerManager serverManager = ServerManager(
      Config().BASE_URL,
      Config().API_KEY_ANDROID,
      Config().PACKAGE_NAME,
    );
    if (Platform.isAndroid) serverManager.API_KEY = Config().API_KEY_ANDROID;
    if (Platform.isIOS) serverManager.API_KEY = Config().API_KEY_IOS;

    serverManager.admobTestIdentifiers = "11D517C6CAD1DEE0070D63332483D50E";
    serverManager.initSplashScreen((itemModel) {
      if (itemModel == null) {
        print("itemModel NUll");
        isProgress.value = false;
      } else {
        print(itemModel.toString());
        AdsManager().loadAppOpenAd(() {
          Get.offAllNamed(Routes.HOME);
        });
      }
    });
  }
}
