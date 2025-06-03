import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_management_app/models/users_response.dart';
import 'package:user_management_app/screens/user_detail_screen.dart';
import 'package:user_management_app/screens/user_list_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class AppRoutes {
  AppRoutes._();

  static const userList = '/user-list';
  static const userDetail = '/user-detail';
}

abstract class AppRouter {
  AppRouter._();

  static final routerConfig = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.userList,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: AppRoutes.userList,
        builder: (_, state) => const UserListScreen(),
      ),
      GoRoute(
        path: AppRoutes.userDetail,
        builder: (_, state) {
          final user = state.extra as UserData;
          return UserDetailScreen(user: user);
        },
      ),
    ],
    errorBuilder: (_, __) => const Text('Error'),
  );
}
