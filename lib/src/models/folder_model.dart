import 'package:app_manager/src/models/file_model.dart';

class FolderModel {
  final String folderName;
  final List<FileModel> files;

  FolderModel({
    required this.folderName,
    required this.files,
  });

  factory FolderModel.fromJson(String folderName, Map<String, dynamic> json) {
    List<FileModel> files = json.entries.map((entry) {
      return FileModel.fromJson(entry.value);
    }).toList();

    return FolderModel(
      folderName: folderName,
      files: files,
    );
  }
}
