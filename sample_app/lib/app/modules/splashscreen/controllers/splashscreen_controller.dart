import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';
import 'package:sample_app/app/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  void initAds() {
    ServerManager serverManager = ServerManager();
    AppConfig().setPackageName("com.ugikpoenya.sampleapp");
    AppConfig().setBaseUrl("https://master.ugikpoenya.net/");
    if (Platform.isAndroid) AppConfig().setApiKey("DA8BB129F7C1ED5BD07046961C995A77");
    if (Platform.isIOS) AppConfig().setApiKey("f9ab6889e85f61d7ef988a6b1e57fcd4");

    serverManager.getApi((p0) {
      AdsManager adsManager = Get.put(AdsManager());
      adsManager.admobTestIdentifiers = "37DF55D8CB7FA08929CFD78ED866BA5C";

      adsManager.initGDPR(() {
        Get.offAllNamed(Routes.HOME);
      });
    });
  }
}
