// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;

import '../app_bloc_observer.dart' as _i744;
import '../blocs/internet_connection_cubit.dart' as _i671;
import '../blocs/user_list_bloc.dart' as _i307;
import '../data/apis/base/dio_client.dart' as _i654;
import '../data/apis/user/user_api.dart' as _i498;
import 'get_it.dart' as _i241;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i654.DioClient>(() => registerModule.dioClient);
    gh.singleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.singleton<_i973.InternetConnectionChecker>(
      () => registerModule.internetConnectionChecker,
    );
    gh.lazySingleton<_i744.AppBlocObserver>(() => _i744.AppBlocObserver());
    gh.lazySingleton<_i671.InternetConnectionCubit>(
      () => _i671.InternetConnectionCubit(),
    );
    gh.factory<_i361.Dio>(
      () => registerModule.dioAuth,
      instanceName: 'AuthDio',
    );
    gh.lazySingleton<_i498.UserApi>(
      () => _i498.UserApi(gh<_i361.Dio>(instanceName: 'AuthDio')),
    );
    gh.factoryParam<_i307.UserListBloc, _i671.InternetConnectionCubit, dynamic>(
      (internetConnectionCubit, _) =>
          _i307.UserListBloc(gh<_i498.UserApi>(), internetConnectionCubit),
    );
    return this;
  }
}

class _$RegisterModule extends _i241.RegisterModule {}
