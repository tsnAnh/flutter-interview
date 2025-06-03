import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:user_management_app/data/apis/base/base_api.dart';


class DioClient {
  DioClient() {
    final baseOptions = createBaseOptions();
    dio = Dio(baseOptions);
  }

  BaseOptions createBaseOptions() {
    return BaseOptions(
      baseUrl: Api.baseUrl,
      headers: {
        'x-api-key': Api.apiKey,
      },
      connectTimeout: Duration(milliseconds: Api.defaultConnectTimeout),
      receiveTimeout: Duration(milliseconds: Api.defaultReceiveTimeout),
      sendTimeout: Duration(milliseconds: Api.defaultSendTimeout),
    );
  }

  late final Dio dio;
}

const authDio = Named('AuthDio');
