import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/domain/entities/core/app_exception.dart';
import 'package:flutter_jett_boilerplate/domain/entities/face/photo_pick_result.dart';
import 'package:flutter_jett_boilerplate/domain/service/auth/user.service.dart';
import 'package:flutter_jett_boilerplate/presentation/components/face_extractor.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';

class RegisterPageController extends GetxController {
  static RegisterPageController get to => Get.find();

  // final List<Widget> registerStepWidgets = [
  //   FaceDetectionWidget(),
  //   FaceDetectionResult()
  // ];
  int currentStep = 0;
  File? croppedFile;
  File? photo;
  List<dynamic> photoFeature = [];
  TextEditingController fullnameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController photoTextController = TextEditingController();
  bool isAgree = false;
  int extractionTimeMs = 0;
  int modelRunTimeMs = 0;

  void nextStep() {
    currentStep += 1;
    update();
  }

  void toogleAgreement() {
    isAgree = !isAgree;
    update();
  }

  void goToLogin() {
    Get.offAndToNamed("/user/login");
  }

  void goToHome() {
    Get.offAndToNamed("/home");
  }

  void pickPhoto() async {
    PhotoPickResult photoPickResult = await Get.to(
      const FaceExtractor(
        isNeedConfirmation: true,
      ),
    );
    croppedFile = photoPickResult.croppedFile;
    photoFeature = photoPickResult.photoFeature;
    photo = photoPickResult.cameraFile;
    extractionTimeMs = photoPickResult.extarctionTimeMs;
    modelRunTimeMs = photoPickResult.modelRunTimeMs;
    update();
  }

  void register() async {
    try {
      showLoadingDialog();
      Map<String, dynamic> payload = {
        'fullname': fullnameTextController.text,
        'email': emailTextController.text,
        'password': passwordTextController.text,
        'photo': await dio.MultipartFile.fromFile(photo!.path),
        'cropped_photo': await dio.MultipartFile.fromFile(croppedFile!.path),
        'photo_feature': photoFeature,
        'extractionTimeMs': extractionTimeMs,
        'modelRunTimeMs': modelRunTimeMs
      };
      await UserService.register(payload);
      hideLoadingDialog();
      goToHome();
    } on AppException catch (err) {
      hideLoadingDialog();
      Get.snackbar("Terjadi Error",
          err.message != null ? err.message! : "Unknown Error");
    } catch (err) {
      print(err);
      hideLoadingDialog();
      Get.snackbar("Terjadi Error", err.toString());
    }
  }
}
