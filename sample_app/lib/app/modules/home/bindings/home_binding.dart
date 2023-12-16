import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServerManager>(() => ServerManager());
    Get.lazyPut<AdsManager>(() => AdsManager());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
