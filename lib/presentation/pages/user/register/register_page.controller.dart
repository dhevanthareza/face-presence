import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/domain/entities/core/app_exception.dart';
import 'package:flutter_jett_boilerplate/domain/service/auth/user.service.dart';
import 'package:flutter_jett_boilerplate/domain/service/face/face_detector.service.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;
import 'package:load/load.dart';
import 'package:path_provider/path_provider.dart';

class RegisterPageController extends GetxController {
  static RegisterPageController get to => Get.find();

  // final List<Widget> registerStepWidgets = [
  //   FaceDetectionWidget(),
  //   FaceDetectionResult()
  // ];
  int currentStep = 0;
  Face? faceDetected;
  CameraImage? cameraImage;
  File? cameraFile;
  File? croppedFile;
  List<dynamic> photoFeature = [];
  TextEditingController fullnameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController photoTextController = TextEditingController();

  void nextStep() {
    currentStep += 1;
    update();
  }

  void setFaceAndImage(Face face, CameraImage image) {
    faceDetected = face;
    cameraImage = image;
    update();
  }

  Future<void> setCroppedFile(CameraImage image, Face faceDetected) async {
    imglib.Image cropImage = FaceDetectorService.cropFace(image, faceDetected);
    Directory directory = await getTemporaryDirectory();
    bool isTempImageExist =
        await File('${directory.path}/cropfile.png').exists();
    if (isTempImageExist) {
      await File('${directory.path}/cropfile.png').delete();
    }
    File cropFile = await File('${directory.path}/${getRandomString(10)}.png')
        .writeAsBytes(imglib.encodePng(cropImage));
    croppedFile = cropFile;
    List<dynamic> _photoFeature =
        await FaceDetectorService.createFeature(image, faceDetected);
    photoFeature = _photoFeature;
    update();
  }

  void setCameraFile(XFile file) {
    cameraFile = File(file.path);
    update();
  }

  void goToLogin() {
    Get.offAndToNamed("/user/login");
  }

  void goToHome() {
    Get.offAndToNamed("/home");
  }

  void register() async {
    try {
      showLoadingDialog(tapDismiss: false);
      Map<String, dynamic> payload = {
        'fullname': fullnameTextController.text,
        'email': emailTextController.text,
        'password': passwordTextController.text,
        'photo': await dio.MultipartFile.fromFile(cameraFile!.path),
        'cropped_photo': await dio.MultipartFile.fromFile(croppedFile!.path),
        'photo_feature': photoFeature
      };
      await UserService.register(payload);
      hideLoadingDialog();
      goToHome();
    } on AppException catch (err) {
      hideLoadingDialog();
      Get.snackbar("Terjadi Error", err.message!);
    } catch (err) {
      print(err);
      hideLoadingDialog();
      Get.snackbar("Terjadi Error", "Silahkan coba lagi");
    }
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
