import 'package:app_manager/app_manager.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class ServerManager extends GetxController {
  GetStorage box = GetStorage();
  RxBool isProgresLoading = false.obs;
  final dio = Dio();

  Future getServerUrl(url) async {
    final response = await dio.get(
      AppConfig().getBaseUrl() + url,
      options: Options(
        headers: {
          "api_key": AppConfig().getApiKey(),
          "package_name": AppConfig().getPackageName(),
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  void getApi(Function function) async {
    isProgresLoading.value = true;
    try {
      final response = await getServerUrl("api/");
      var itemModel = ItemModel.fromJson(response);
      ItemModel.toBoxStorage(itemModel);
      isProgresLoading.value = false;
      function();
    } catch (e) {
      print(e);
      isProgresLoading.value = false;
      function();
    }
  }
}
