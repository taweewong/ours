import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ours/presentation/camera/camera_screen.dart';
import 'package:ours/presentation/login/login_screen.dart';
import 'package:ours/presentation/parking/parking_screen.dart';
import 'package:ours/presentation/parking_preview/parking_preview_screen.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: "/parking",
        builder: (BuildContext context, GoRouterState state) {
          return const ParkingScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: "preview",
            pageBuilder: (BuildContext context, GoRouterState state) {
              return state.transitionPage(const ParkingPreviewScreen());
            },
          ),
        ],
      ),
      GoRoute(
        path: "/camera",
        builder: (BuildContext context, GoRouterState state) {
          return const CameraScreen();
        },
      ),
    ],
  );
}

extension GoRouterExtensions on GoRouterState {
  CustomTransitionPage transitionPage(Widget screen) {
    return CustomTransitionPage(
      key: pageKey,
      child: screen,
      transitionDuration: const Duration(milliseconds: 100),
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeIn)),
          ),
          child: child,
        );
      },
    );
  }
}
