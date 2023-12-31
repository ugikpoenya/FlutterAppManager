import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';
import 'package:sample_app/app/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  RxBool isProgress = true.obs;
  void initAds() {
    isProgress.value = true;
    ServerManager serverManager = ServerManager(
      "https://master.ugikpoenya.net/",
      "DA8BB129F7C1ED5BD07046961C995A77",
      "com.ugikpoenya.sampleapp",
    );
    if (Platform.isAndroid) serverManager.API_KEY = "DA8BB129F7C1ED5BD07046961C995A77";
    if (Platform.isIOS) serverManager.API_KEY = "f9ab6889e85f61d7ef988a6b1e57fcd4";

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
