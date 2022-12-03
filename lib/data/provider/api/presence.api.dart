import 'package:dio/dio.dart';
import 'package:flutter_jett_boilerplate/domain/entities/rest_response/paginate_response.dart';

import '../../../domain/entities/rest_response/default_response.entity.dart';
import '../../../utils/rest_client.dart';

class PresenceApi {
  static Future<DefaultResponseEntity> presence(
    Map<String, dynamic> payload,
  ) async {
    dynamic response = await RestClient.post(
      "/presence",
      data: FormData.fromMap(payload),
    );
    return DefaultResponseEntity.fromJson(response);
  }

  static Future<DefaultResponseEntity> today() async {
    dynamic response = await RestClient.get(
      "/presence/today",
    );
    return DefaultResponseEntity.fromJson(response);
  }

  static Future<PaginateResponse> history(int page, int limit) async {
    dynamic response = await RestClient.get("/presence/mine-datatable",
        queryParameter: {"limit": limit, "page": page});
    return PaginateResponse.fromJson(response);
  }
}
