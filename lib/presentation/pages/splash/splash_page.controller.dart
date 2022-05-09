import 'package:flutter_jett_boilerplate/data/repositories/user.repository.dart';
import 'package:get/get.dart';

import '../../../domain/entities/auth/user.entity.dart';

class SplashPageController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkUser();
  }

  void checkUser() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      UserEntity? user = UserRepository.getSavedUserData();
      if (user == null) {
        Get.offAllNamed("/user/register");
      } else {
        Get.offAllNamed("/home");
      }
    });
  }
}
