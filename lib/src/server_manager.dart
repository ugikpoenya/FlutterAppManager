// ignore_for_file: non_constant_identifier_names

import 'package:app_manager/app_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart';

class ServerManager {
  String BASE_URL = "";
  String API_KEY = "";
  String PACKAGE_NAME = "";

  final adsManager = Get.put(AdsManager());
  final dio = Dio();
  String admobTestIdentifiers = "";

  ServerManager(this.BASE_URL, this.API_KEY, this.PACKAGE_NAME);

  Future getServerUrl(url) async {
    if (kDebugMode) print("Get Url : ${url}");

    final response = await dio.get(url);

    if (kDebugMode) print(response.data);
    if (response.statusCode == 200) {
      if (response.data["status"] != null) {
        if (response.data["status"].toString() == "false") {
          return null;
        } else {
          return response.data;
        }
      } else {
        return response.data;
      }
    } else {
      return null;
    }
  }

  bool firstLoad = true;
  void initSplashScreen(Function(ItemModel?) function) async {
    firstLoad = true;
    getApiItem((itemModel) {
      if (firstLoad) {
        firstLoad = false;
        adsManager.initAds();
        function(itemModel);
      }
    });
  }

  void getApiItem(Function(ItemModel?) function) async {
    try {
      final response = await getServerUrl("${BASE_URL}apps/${API_KEY}.json");
      if (response == null) {
        function(null);
      } else {
        ItemModel.fromJson(response).toBoxStorage();
        adsManager.admobTestIdentifiers = admobTestIdentifiers;
        adsManager.initGDPR(function);
      }
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
