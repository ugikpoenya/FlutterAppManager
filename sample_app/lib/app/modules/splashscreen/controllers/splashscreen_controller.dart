import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';
import 'package:sample_app/app/Config.dart';
import 'package:sample_app/app/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  RxBool isProgress = true.obs;
  void initAds() {
    isProgress.value = true;
    ServerManager serverManager = ServerManager();

    String BASE_URL = (Platform.isAndroid) ? Config().BASE_URL_ANDROID : Config().BASE_URL_IOS;

    serverManager.admobTestIdentifiers = "11D517C6CAD1DEE0070D63332483D50E";
    serverManager.initSplashScreen(BASE_URL, (itemModel) {
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
