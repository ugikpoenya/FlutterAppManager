import 'package:app_manager/app_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class ServerManager extends GetxController {
  GetStorage box = GetStorage();
  final dio = Dio();

  Future getServerUrl(url) async {
    if (kDebugMode) print("Get Url : ${AppConfig().getBaseUrl() + url}");

    final response = await dio.get(
      AppConfig().getBaseUrl() + url,
      options: Options(
        headers: {
          "api_key": AppConfig().getApiKey(),
          "package_name": AppConfig().getPackageName(),
        },
      ),
    );

    if (kDebugMode) print(response);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  void getApi(Function(ItemModel?) function) async {
    try {
      final response = await getServerUrl("api/");
      var itemModel = ItemModel.fromJson(response);
      ItemModel.toBoxStorage(itemModel);
      function(itemModel);
    } catch (e) {
      print(e);
      function(null);
    }
  }

  void getPosts(Function(List<PostModel>?) function) async {
    print("getPosts");
    try {
      final response = await getServerUrl("api/posts");
      List<PostModel> postModelList = PostModel.fromJsonList(response["data"]);
      function(postModelList);
    } catch (e) {
      function(null);
      print(e);
    }
  }

  void getAssets(Function(AssetModel?) function) async {
    try {
      final response = await getServerUrl("api/assets");
      AssetModel assetsModel = AssetModel.fromJson(response);
      function(assetsModel);
    } catch (e) {
      function(null);
      print(e);
    }
  }
}
