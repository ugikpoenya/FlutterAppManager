class FileModel {
  final String name;
  final String path;
  final String size;
  final String url;

  FileModel({
    required this.name,
    required this.path,
    required this.size,
    required this.url,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      name: json['name'],
      path: json['path'],
      size: json['size'],
      url: json['url'],
    );
  }
}
