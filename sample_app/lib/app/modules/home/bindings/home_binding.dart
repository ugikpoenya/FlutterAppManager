import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    ServerManager serverManager = ServerManager(
      "https://master.ugikpoenya.net/",
      "DA8BB129F7C1ED5BD07046961C995A77",
      "com.ugikpoenya.sampleapp",
    );
    if (Platform.isAndroid) serverManager.API_KEY = "DA8BB129F7C1ED5BD07046961C995A77";
    if (Platform.isIOS) serverManager.API_KEY = "f9ab6889e85f61d7ef988a6b1e57fcd4";
    Get.lazyPut<AdsManager>(() => AdsManager());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
