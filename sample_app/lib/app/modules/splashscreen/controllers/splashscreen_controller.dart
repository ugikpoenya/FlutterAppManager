import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';
import 'package:sample_app/app/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  //TODO: Implement SplashscreenController

  RxBool isSubscription = false.obs;

  void initAds() {
    ServerManager serverManager = ServerManager();
    serverManager.setBaseUrl("https://master.ugikpoenya.net");
    serverManager.setApiKey("DA8BB129F7C1ED5BD07046961C995A77");
    serverManager.setPackageName("DA8BB129F7C1ED5BD07046961C995A77");

    serverManager.getApi(() {
      print(ItemModel.fromBoxStorage());

      AdsManager adsManager = Get.put(AdsManager());
      adsManager.admobTestIdentifiers = "37DF55D8CB7FA08929CFD78ED866BA5C";
      adsManager.initGDPR(isSubscription.value, () {
        print("Ads initialized");
        Get.offAllNamed(Routes.HOME);
      });
    });
  }
}
