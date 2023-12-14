import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  GetStorage box = GetStorage();

  RxBool isLoading = true.obs;
  RxBool isSubscription = false.obs;

  void initAds() {
    isLoading.value = true;
    print("Init Ads");
    ItemModel itemModel = ItemModel();
    itemModel.admob_gdpr = true;
    itemModel.admob_open_ads = 'ca-app-pub-3940256099942544/5575463023';
    itemModel.admob_banner = 'ca-app-pub-3940256099942544/2934735716';
    itemModel.admob_interstitial = 'ca-app-pub-3940256099942544/4411468910';
    itemModel.admob_native = 'ca-app-pub-3940256099942544/3986624511';
    itemModel.admob_rewarded_ads = 'ca-app-pub-3940256099942544/1712485313';

    itemModel.facebook_banner = "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID";
    itemModel.facebook_native = "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID";
    itemModel.facebook_interstitial = "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID";
    itemModel.facebook_rewarded_ads = "VID_HD_16_9_15S_LINK#YOUR_PLACEMENT_ID";

    if (Platform.isAndroid) {
      itemModel.unity_game_id = "5440601";
      itemModel.unity_banner = "Banner_Android";
      itemModel.unity_interstitial = "Interstitial_Android";
      itemModel.unity_rewarded_ads = "Rewarded_Android";
    } else if (Platform.isIOS) {
      itemModel.unity_game_id = "5440600";
      itemModel.unity_banner = "Banner_iOS";
      itemModel.unity_interstitial = "Interstitial_iOS";
      itemModel.unity_rewarded_ads = "Rewarded_iOS";
    }

    itemModel.unity_test_mode = true;
    box.write("ItemModel", itemModel.toJson());

    AdsManager adsManager = Get.put(AdsManager());
    adsManager.initGDPRTest(isSubscription.value, () {
      adsManager.initAds(isSubscription.value);
      isLoading.value = false;
    }, "37DF55D8CB7FA08929CFD78ED866BA5C");
  }
}
