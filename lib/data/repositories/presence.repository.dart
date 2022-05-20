import 'package:flutter_jett_boilerplate/data/provider/api/presence.api.dart';
import 'package:flutter_jett_boilerplate/domain/entities/core/app_exception.dart';
import 'package:flutter_jett_boilerplate/domain/entities/presence/presence.entity.dart';
import 'package:flutter_jett_boilerplate/domain/entities/rest_response/default_response.entity.dart';
import 'package:flutter_jett_boilerplate/domain/entities/rest_response/paginate_response.dart';

class PresenceRepository {
  static Future<DefaultResponseEntity> presence(
      Map<String, dynamic> payload) async {
    DefaultResponseEntity presenceResponse =
        await PresenceApi.presence(payload);
    return presenceResponse;
  }
  static Future<PresenceEntity> today() async {
    DefaultResponseEntity presenceResponse =
        await PresenceApi.today();
    if(presenceResponse.data == null) {
      throw AppException(code: "PRESENCE_STILL_EMPTY", message: "Belum ada record absen");
    }
    PresenceEntity presence = PresenceEntity.fromJson(presenceResponse.data);
    return presence;
  }

  static Future<PaginateResponse> shortHistory() async {
    PaginateResponse response = await PresenceApi.history(1, 5);
    return response;
  }
}
