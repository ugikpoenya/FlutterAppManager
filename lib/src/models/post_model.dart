// ignore_for_file: non_constant_identifier_names

class PostModel {
  String post_id = "";
  String post_date = "";
  String post_title = "";
  String post_image = "";
  String post_content = "";

  PostModel.fromJson(Map<String, dynamic> json) {
    post_id = json["post_id"];
    post_date = json["post_date"];
    post_title = json["post_title"];
    post_image = json["post_image"];
    post_content = json["post_content"];
  }

  String getPostImageThumb() {
    return post_image.replaceAll("/uploads/", "/thumbs/");
  }

  static List<PostModel> fromJsonList(List data) {
    if (data.isEmpty) return [];
    return data.map((e) => PostModel.fromJson(e)).toList();
  }
}
