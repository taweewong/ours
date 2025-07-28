import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ours/presentation/login/login_screen.dart';
import 'package:ours/presentation/splash/splash_screen.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: "login",
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
          ),
        ],
      ),
    ],
  );
}
