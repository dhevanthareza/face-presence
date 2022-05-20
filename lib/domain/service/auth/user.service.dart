import 'package:flutter_jett_boilerplate/data/repositories/auth.repository.dart';
import 'package:flutter_jett_boilerplate/data/repositories/user.repository.dart';
import 'package:flutter_jett_boilerplate/domain/entities/auth/auth.entity.dart';
import 'package:flutter_jett_boilerplate/domain/entities/auth/user.entity.dart';
import 'package:get_storage/get_storage.dart';

class UserService {
  static Future<UserEntity> login(String email, String password) async {
    AuthEntity auth = await UserRepository.login(email, password);
    await AuthRepository.saveToken(auth.accessToken!);
    UserEntity user = await UserRepository.getUserData();
    await UserRepository.saveUserData(user.toJson());
    return user;
  }
  static Future<UserEntity> register(Map<String, dynamic> payload) async {
    AuthEntity auth = await UserRepository.register(payload);
    await AuthRepository.saveToken(auth.accessToken!);
    UserEntity user = await UserRepository.getUserData();
    await UserRepository.saveUserData(user.toJson());
    return user;
  }

  static Future<void> logout() async {
    await GetStorage().erase();
  }
}
