import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:user_management_app/di/get_it.config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../data/apis/base/dio_client.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @singleton
  DioClient get dioClient => DioClient();

  @authDio
  Dio get dioAuth => dioClient.dio;

  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker.createInstance();
}
