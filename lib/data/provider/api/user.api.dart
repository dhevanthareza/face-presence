import 'package:dio/dio.dart';
import 'package:flutter_jett_boilerplate/utils/rest_client.dart';

import '../../../domain/entities/rest_response/default_response.entity.dart';

class UserApi {
  static Future<DefaultResponseEntity> login(
    String email,
    String password,
  ) async {
    dynamic response = await RestClient.post(
      "/user/login",
      data: {
        'email': email,
        'password': password,
      },
    );
    return DefaultResponseEntity.fromJson(response);
  }

  static Future<DefaultResponseEntity> register(
    Map<String, dynamic> payload,
  ) async {
    dynamic response = await RestClient.post(
      "/user/register",
      data: FormData.fromMap(payload),
    );
    return DefaultResponseEntity.fromJson(response);
  }

  static Future<DefaultResponseEntity> me() async {
    dynamic response = await RestClient.get(
      "/user/me",
    );
    return DefaultResponseEntity.fromJson(response);
  }
}
