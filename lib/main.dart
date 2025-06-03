import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_management_app/router.dart';

import 'app_bloc_observer.dart';
import 'blocs/internet_connection_cubit.dart';
import 'di/get_it.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFlutterApp();
}

Future<void> initializeFlutterApp() async {
  configureDependencies();
  final observer = getIt<AppBlocObserver>();
  FlutterError.onError = (FlutterErrorDetails details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), error: error, stackTrace: stack);
    return true;
  };

  Bloc.observer = observer;

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<InternetConnectionCubit>()),
      ],
      child: MaterialApp.router(routerConfig: AppRouter.routerConfig),
    );
  }
}
