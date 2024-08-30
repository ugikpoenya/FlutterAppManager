// ignore_for_file: non_constant_identifier_names
import 'package:app_manager/src/models/file_model.dart';
import 'package:app_manager/src/models/folder_model.dart';

class AssetModel {
  List<FolderModel> folders = [];
  List<FileModel> files = [];

  AssetModel.fromJson(Map<String, dynamic> json) {
    folders.clear();
    files.clear();
    json.forEach((key, value) {
      if (value["url"] == null) {
        FolderModel folder = FolderModel.fromJson(key, value);
        folders.add(folder);
        folder.files.forEach((file) {});
      } else {
        FileModel file = FileModel.fromJson(value);
        files.add(file);
      }
    });
  }
}
