import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';
import 'package:sample_app/app/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  void initAds() {
    ServerManager serverManager = ServerManager();
    AppConfig appConfig = AppConfig(
      "https://master.ugikpoenya.net/",
      "DA8BB129F7C1ED5BD07046961C995A77",
      "com.ugikpoenya.sampleapp",
    );
    appConfig.EMAIL = "ugikpoenya@gmail.com?subject=Image%20To%20Anime";
    appConfig.PRIVACY_POLICY = "https://ugikpoenya.koncodewe.com/privacy-policy";
    appConfig.TERMS_OF_USE = "https://ugikpoenya.koncodewe.com/terms-of-use";
    if (Platform.isAndroid) appConfig.API_KEY = "DA8BB129F7C1ED5BD07046961C995A77";
    if (Platform.isIOS) appConfig.API_KEY = "f9ab6889e85f61d7ef988a6b1e57fcd4";
    appConfig.toBoxStorage();

    serverManager.getApi((p0) {
      AdsManager adsManager = Get.put(AdsManager());
      adsManager.admobTestIdentifiers = "37DF55D8CB7FA08929CFD78ED866BA5C";

      adsManager.initGDPR(() {
        Get.offAllNamed(Routes.HOME);
      });
    });
  }
}
