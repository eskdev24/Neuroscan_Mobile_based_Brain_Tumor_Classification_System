import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

final goRouter = GoRouter(
  initialLocation: '/${Routes.splash}',
  routes: [
    GoRoute(path: '/${Routes.splash}', builder: (_, __) => const Placeholder()),
    GoRoute(path: '/${Routes.welcome}', builder: (_, __) => const Placeholder()),
    GoRoute(path: '/${Routes.auth}', builder: (_, __) => const Placeholder()),
    GoRoute(path: '/${Routes.home}', builder: (_, __) => const Placeholder()),
    GoRoute(path: '/${Routes.scan}', builder: (_, __) => const Placeholder()),
    GoRoute(path: '/${Routes.results}', builder: (_, __) => const Placeholder()),
    GoRoute(path: '/${Routes.history}', builder: (_, __) => const Placeholder()),
    GoRoute(path: '/${Routes.about}', builder: (_, __) => const Placeholder()),
    GoRoute(path: '/${Routes.notifications}', builder: (_, __) => const Placeholder()),
    GoRoute(path: '/${Routes.profile}', builder: (_, __) => const Placeholder()),
  ],
);
