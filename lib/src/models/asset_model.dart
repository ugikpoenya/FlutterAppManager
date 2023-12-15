// ignore_for_file: non_constant_identifier_names
class AssetModel {
  List<String> files = [];
  Map<String, List<String>> folders = {};

  AssetModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("files")) {
      files = List<String>.from(json["files"]);
    }
    if (json.containsKey("folders")) {
      folders = convertDynamicToMap(json["folders"]);
    }
  }

  Map<String, List<String>> convertDynamicToMap(dynamic dynamicObject) {
    // Buat Map<String, List<String>> untuk menyimpan hasil
    Map<String, List<String>> resultMap = {};

    // Jika objek dynamic adalah Map<String, dynamic>
    if (dynamicObject is Map<String, dynamic>) {
      // Iterasi melalui setiap entri dalam dynamicObject
      dynamicObject.forEach((key, value) {
        // Pastikan nilai adalah List<String> atau String
        if (value is List) {
          // Jika nilai adalah List<String>, tambahkan langsung
          resultMap[key] = List<String>.from(value);
        } else if (value is String) {
          // Jika nilai adalah String, tambahkan ke dalam List<String>
          resultMap[key] = [value];
        }
      });
    }

    return resultMap;
  }
}
