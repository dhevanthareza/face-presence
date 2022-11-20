import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MlKitService {
  static Future<List<Face>> detectFacesFromImage(
      CameraImage cameraImage, int rotation) async {
    final inputImage = camareImageToInputImage(cameraImage, rotation);
    final faceDetector = FaceDetector(
        options:
            FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));
    final List<Face> faces = await faceDetector.processImage(inputImage);
    return faces;
  }

  static InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  static InputImage camareImageToInputImage(
      CameraImage cameraImage, int rotation) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final inputImageData = InputImageData(
      size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
      imageRotation: MlKitService.rotationIntToImageRotation(rotation),
      inputImageFormat: cameraImage.format.group == ImageFormatGroup.yuv420
          ? InputImageFormat.yuv420
          : InputImageFormat.bgra8888,
      planeData: cameraImage.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    return inputImage;
  }
}
