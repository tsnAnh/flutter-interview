import 'package:dart3z/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:user_management_app/data/apis/base/base_api.dart';
import 'package:user_management_app/data/apis/base/dio_client.dart';
import 'package:user_management_app/data/apis/base/error.dart';
import 'package:user_management_app/models/users_response.dart';

@lazySingleton
final class UserApi extends Api {
  UserApi(@authDio super.dio);

  Future<Either<NetworkError, UsersResponse>> getUserList({
    int page = 1,
    int perPage = 10,
    int delay = 2,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return withTimeoutRequest(() async {
      final response = await dio.get(
        ApiPath.userList,
        queryParameters: {'page': page, 'per_page': perPage, 'delay': delay},
      );

      // debugPrint('API Response: ${response.data}');
      return UsersResponse.fromJson(response.data as Map<String, dynamic>);
    });
  }
}
