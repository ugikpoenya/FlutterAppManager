// ignore_for_file: non_constant_identifier_names

import 'package:get_storage/get_storage.dart';

class ItemModel {
  String OPENAI_API_KEY = "";
  String IMAGINE_API_KEY = "";
  bool admob_gdpr = false;
  String admob_banner = "";
  String admob_interstitial = "";
  String admob_native = "";
  String admob_open_ads = "";
  String admob_rewarded_ads = "";

  String facebook_banner = "";
  String facebook_interstitial = "";
  String facebook_native = "";
  String facebook_rewarded_ads = "";

  String unity_game_id = "";
  String unity_banner = "";
  String unity_interstitial = "";
  String unity_rewarded_ads = "";
  bool unity_test_mode = false;

  ItemModel();

  ItemModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("item") && (json["item"] is! List)) {
      itemParser(json["item"]);
    }
  }

  Map toJson() => {
        'OPENAI_API_KEY ': OPENAI_API_KEY,
        'IMAGINE_API_KEY': IMAGINE_API_KEY,
        'admob_gdpr': admob_gdpr,
        'admob_banner': admob_banner,
        'admob_interstitial': admob_interstitial,
        'admob_native': admob_native,
        'admob_open_ads': admob_open_ads,
        'facebook_banner': facebook_banner,
        'facebook_interstitial': facebook_interstitial,
        'facebook_native': facebook_native,
        'facebook_rewarded_ads': facebook_rewarded_ads,
        'unity_game_id': unity_game_id,
        'unity_banner': unity_banner,
        'unity_interstitial': unity_interstitial,
        'unity_rewarded_ads': unity_rewarded_ads,
        'unity_test_mode': unity_test_mode,
      };

  void itemParser(dynamic item) {
    if (item != null) {
      try {
        if (item.containsKey("OPENAI_API_KEY ")) OPENAI_API_KEY = item["OPENAI_API_KEY "];
        if (item.containsKey("IMAGINE_API_KEY")) IMAGINE_API_KEY = item["IMAGINE_API_KEY"];
        if (item.containsKey("admob_gdpr")) admob_gdpr = (item["admob_gdpr"].toString() == "true");
        if (item.containsKey("admob_banner")) admob_banner = item["admob_banner"];
        if (item.containsKey("admob_interstitial")) admob_interstitial = item["admob_interstitial"];
        if (item.containsKey("admob_native")) admob_native = item["admob_native"];
        if (item.containsKey("admob_open_ads")) admob_open_ads = item["admob_open_ads"];
        if (item.containsKey("admob_rewarded_ads")) admob_rewarded_ads = item["admob_rewarded_ads"];

        if (item.containsKey("facebook_banner")) facebook_banner = item["facebook_banner"];
        if (item.containsKey("facebook_interstitial")) facebook_interstitial = item["facebook_interstitial"];
        if (item.containsKey("facebook_native")) facebook_native = item["facebook_native"];
        if (item.containsKey("facebook_rewarded_ads")) facebook_rewarded_ads = item["facebook_rewarded_ads"];

        if (item.containsKey("unity_game_id")) unity_game_id = item["unity_game_id"];
        if (item.containsKey("unity_banner")) unity_banner = item["unity_banner"];
        if (item.containsKey("unity_interstitial")) unity_interstitial = item["unity_interstitial"];
        if (item.containsKey("unity_rewarded_ads")) unity_rewarded_ads = item["unity_rewarded_ads"];
        if (item.containsKey("unity_test_mode")) unity_test_mode = (item["unity_test_mode"].toString() == "true");
      } catch (e) {
        print(e);
      }
    }
  }

  ItemModel.fromBoxStorage() {
    GetStorage box = GetStorage();
    itemParser(box.read("ItemModel"));
  }

  ItemModel.toBoxStorage(ItemModel itemModel) {
    GetStorage box = GetStorage();
    box.write("ItemModel", itemModel.toJson());
  }
}
