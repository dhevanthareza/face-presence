import 'package:flutter_jett_boilerplate/domain/entities/rest_response/error_response_object.entity.dart';

class DefaultResponseEntity {
  String? message;
  String? code;
  dynamic data;

  DefaultResponseEntity({this.data, this.message, this.code});

  // expected json
  // {
  //   'data': {},
  //   'error': null / {'message': 'Terjadi Error', 'code': },
  //   'success': true / false
  // }
  DefaultResponseEntity.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    code = json['code'];
    message = json['message'];
  }
}
