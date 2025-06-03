import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


@lazySingleton
final class AppBlocObserver extends BlocObserver {
  AppBlocObserver();

  static var enableLogging = false;


  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (!enableLogging) return;
    log('onChange: ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (!enableLogging) return;
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
  }
}
