// ignore_for_file: non_constant_identifier_names

import 'package:app_manager/app_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart';

class ServerManager {
  final adsManager = Get.put(AdsManager());
  final dio = Dio();
  String admobTestIdentifiers = "";

  ServerManager();

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
  void initSplashScreen(url, Function(ItemModel?) function) async {
    firstLoad = true;
    getApiItem(url, (itemModel) {
      if (firstLoad) {
        firstLoad = false;
        adsManager.initAds();
        function(itemModel);
      }
    });
  }

  void getApiItem(url, Function(ItemModel?) function) async {
    try {
      final response = await getServerUrl(url);
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

  void getPosts(url, Function(List<PostModel>?) function) async {
    print("getPosts ");
    try {
      final response = await getServerUrl(url);
      List<PostModel> posts = PostModel.fromJsonMap(response["posts"]);
      function(posts);
    } catch (e) {
      function(null);
      print(e);
    }
  }

  void getAssets(url, Function(AssetModel?) function) async {
    try {
      final response = await getServerUrl(url);
      AssetModel assetsModel = AssetModel.fromJson(response);
      function(assetsModel);
    } catch (e) {
      function(null);
      print(e);
    }
  }
}
