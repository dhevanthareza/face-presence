import 'dart:io';

class PhotoPickResult {
  File cameraFile;
  File croppedFile;
  List<dynamic> photoFeature = [];
  int extarctionTimeMs;
  int modelRunTimeMs;

  PhotoPickResult({
    required this.cameraFile,
    required this.croppedFile,
    required this.photoFeature,
    required this.extarctionTimeMs,
    required this.modelRunTimeMs,
  });
}
