// ignore_for_file: non_constant_identifier_names

class PostModel {
  String key = "";
  String post_id = "";
  String post_date = "";
  String post_title = "";
  String post_image = "";
  String post_content = "";
  String post_audio = "";
  String post_video = "";
  String post_asset = "";

  PostModel.fromJson(Map<String, dynamic> json) {
    key = json["key"] ?? "";
    post_id = json["post_id"] ?? "";
    post_date = json["post_date"] ?? "";
    post_title = json["post_title"] ?? "";
    post_image = json["post_image"] ?? "";
    post_content = json["post_content"] ?? "";
    post_audio = json["post_audio"] ?? "";
    post_video = json["post_video"] ?? "";
    post_asset = json["post_asset"] ?? "";
  }

  static List<PostModel> fromJsonMap(Map<String, dynamic> data) {
    if (data.isEmpty) return [];
    return data.entries.map((entry) {
      Map<String, dynamic> postJson = entry.value;
      postJson['key'] = entry.key; // Set post_id from the key
      return PostModel.fromJson(postJson);
    }).toList();
  }
}
