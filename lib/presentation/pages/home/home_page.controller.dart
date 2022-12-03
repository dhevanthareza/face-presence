import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';
import 'package:flutter_jett_boilerplate/data/repositories/presence.repository.dart';
import 'package:flutter_jett_boilerplate/data/repositories/user.repository.dart';
import 'package:flutter_jett_boilerplate/domain/entities/auth/user.entity.dart';
import 'package:flutter_jett_boilerplate/domain/entities/core/app_exception.dart';
import 'package:flutter_jett_boilerplate/domain/entities/face/photo_pick_result.dart';
import 'package:flutter_jett_boilerplate/domain/entities/rest_response/paginate_response.dart';
import 'package:flutter_jett_boilerplate/domain/service/auth/user.service.dart';
import 'package:flutter_jett_boilerplate/presentation/components/face_extractor.dart';
import 'package:flutter_jett_boilerplate/presentation/pages/home/widget/result_page.dart';
import 'package:flutter_jett_boilerplate/utils/date_utils.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:dio/dio.dart' as dio;

import '../../../domain/entities/presence/presence.entity.dart';

class HomePageController extends GetxController {
  bool currentPresenceLoading = true;
  String checkInTime = "00:00";
  String checkOutTime = "00:00";
  bool presenceHistoryLoading = true;
  List<PresenceEntity> presenceHistories = [];
  String currentTime = "00:00";
  bool submitLoading = false;
  bool isSubmitSuccess = false;
  String username = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchTodayData();
    fetchHistoryData();
    setCurrentTime();
    fetchUserData();
  }

  void refreshData() {
    fetchTodayData();
    fetchHistoryData();
  }

  void fetchUserData() async {
    UserEntity? user = await UserRepository.getSavedUserData();
    if (user != null) {
      username = user.fullname ?? "";
      update();
    }
  }

  void setCurrentTime() {
    currentTime = AppDateUtils.formatFromString(DateTime.now().toString(),
        format: "HH:mm");
    update();
    Timer.periodic(Duration(minutes: 1), (timer) {
      currentTime = AppDateUtils.formatFromString(
        DateTime.now().toString(),
        format: "HH:mm",
      );
      update();
    });
  }

  void checkIn() async {
    PhotoPickResult? result = await Get.to(() => const FaceExtractor());
    if (result == null) {
      Get.snackbar("Cancel", "Presensi dibatalkan");
      return;
    }
    submitLoading = true;
    Get.to(() => const ResultPage())!.then((value) => refreshData());

    try {
      Map<String, dynamic> payload = {
        'type': 'IN',
        'photo': await dio.MultipartFile.fromFile(result.cameraFile.path),
        'cropped_photo':
            await dio.MultipartFile.fromFile(result.croppedFile.path),
        'faceFeature': result.photoFeature,
        'extractionTimeMs': result.extarctionTimeMs,
        'modelRunTimeMs': result.modelRunTimeMs
      };
      await PresenceRepository.presence(payload);
      submitLoading = false;
      isSubmitSuccess = true;
      update();
      Get.snackbar("Presensi Berhasil", "presensi berhasil dilakukan");
    } on AppException catch (err) {
      submitLoading = false;
      isSubmitSuccess = false;
      update();
      Get.snackbar("Presensi Gagal", err.message ?? "undefined error");
    }
  }

  void checkOut() async {
    PhotoPickResult? result = await Get.to(() => const FaceExtractor());
    if (result == null) {
      Get.snackbar("Cancel", "Presensi dibatalkan");
      return;
    }
    submitLoading = true;
    Get.to(const ResultPage())!.then((value) => refreshData());
    try {
      Map<String, dynamic> payload = {
        'type': 'OUT',
        'photo': await dio.MultipartFile.fromFile(result.cameraFile.path),
        'cropped_photo':
            await dio.MultipartFile.fromFile(result.croppedFile.path),
        'faceFeature': result.photoFeature,
        'extractionTimeMs': result.extarctionTimeMs,
        'modelRunTimeMs': result.modelRunTimeMs
      };
      await PresenceRepository.presence(payload);
      submitLoading = false;
      isSubmitSuccess = true;
      update();
      Get.snackbar("Presensi Berhasil", "presensi berhasil dilakukan");
    } on AppException catch (err) {
      submitLoading = false;
      isSubmitSuccess = false;
      update();
      Get.snackbar("Presensi Gagal", err.message ?? "undefined error");
    }
  }

  void fetchTodayData() async {
    currentPresenceLoading = true;
    try {
      PresenceEntity currentPresence = await PresenceRepository.today();
      checkInTime = AppDateUtils.formatFromString(
          currentPresence.checkInDatetime,
          format: 'HH:mm',
          addHours: 7);
      checkOutTime = AppDateUtils.formatFromString(
          currentPresence.checkOutDatetime,
          format: 'HH:mm',
          addHours: 7);
      currentPresenceLoading = false;
      update();
    } on AppException catch (err) {
      currentPresenceLoading = false;
      update();
    }
  }

  void fetchHistoryData() async {
    presenceHistoryLoading = true;
    try {
      PaginateResponse presenceHistoriesResponse =
          await PresenceRepository.shortHistory();
      presenceHistories = presenceHistoriesResponse.rows
          .map((e) => PresenceEntity.fromJson(e))
          .toList();
      presenceHistoryLoading = false;
      update();
    } on AppException catch (err) {
      presenceHistoryLoading = false;
      update();
    }
  }

  void logout() async {
    showLoadingDialog();
    try {
      await UserService.logout();
      hideLoadingDialog();
      Get.offAllNamed("/user/register");
    } on AppException catch (err) {
      hideLoadingDialog();
      Get.snackbar(
        "Logout Gagal",
        err.message ?? "Unknown Error",
        backgroundColor: AppColor.failedColor,
        colorText: Colors.white,
      );
    }
  }
}
