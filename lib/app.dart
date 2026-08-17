import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/routes.dart';
import 'core/theme/theme.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/welcome/presentation/welcome_screen.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/scan/presentation/scan_screen.dart';
import 'features/scan/presentation/results_screen.dart';
import 'features/history/presentation/history_screen.dart';
import 'features/about/presentation/about_screen.dart';
import 'features/notifications/presentation/notifications_screen.dart';
import 'features/profile/presentation/profile_screen.dart';

class NeuroscanApp extends ConsumerStatefulWidget {
  const NeuroscanApp({super.key});

  @override
  ConsumerState<NeuroscanApp> createState() => _NeuroscanAppState();
}

class _NeuroscanAppState extends ConsumerState<NeuroscanApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      initialLocation: '/${Routes.splash}',
      routes: [
        GoRoute(
          path: '/${Routes.splash}',
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/${Routes.welcome}',
          builder: (_, __) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/${Routes.auth}',
          builder: (_, __) => const AuthScreen(),
        ),
        GoRoute(
          path: '/${Routes.home}',
          builder: (_, __) => const _ScaffoldWithNav(body: HomeScreen()),
        ),
        GoRoute(
          path: '/${Routes.scan}',
          builder: (_, __) => const _ScaffoldWithBody(body: ScanScreen()),
        ),
        GoRoute(
          path: '/${Routes.results}',
          builder: (_, __) => const _ScaffoldWithBody(body: ResultsScreen()),
        ),
        GoRoute(
          path: '/${Routes.history}',
          builder: (_, __) => const _ScaffoldWithNav(body: HistoryScreen()),
        ),
        GoRoute(
          path: '/${Routes.about}',
          builder: (_, __) => const _ScaffoldWithNav(body: AboutScreen()),
        ),
        GoRoute(
          path: '/${Routes.notifications}',
          builder: (_, __) => const _ScaffoldWithBody(body: NotificationsScreen()),
        ),
        GoRoute(
          path: '/${Routes.profile}',
          builder: (_, __) => _ScaffoldWithNav(
            body: ProfileScreen(
              onSignOut: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) context.go('/${Routes.welcome}');
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Neuroscan AI',
      theme: appTheme,
      routerConfig: _router,
    );
  }
}

class _ScaffoldWithNav extends StatelessWidget {
  final Widget body;
  const _ScaffoldWithNav({required this.body});

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_getTitle(path)),
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getNavIndex(path),
        onDestinationSelected: (i) {
          final routes = [Routes.home, Routes.scan, Routes.history, Routes.profile];
          context.go('/${routes[i]}');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.document_scanner), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _getNavIndex(String path) {
    if (path.contains(Routes.scan)) return 1;
    if (path.contains(Routes.history)) return 2;
    if (path.contains(Routes.profile)) return 3;
    return 0;
  }

  String _getTitle(String path) {
    if (path.contains(Routes.home)) return 'Neuroscan AI';
    if (path.contains(Routes.scan)) return 'Scan';
    if (path.contains(Routes.results)) return 'Results';
    if (path.contains(Routes.history)) return 'History';
    if (path.contains(Routes.about)) return 'About';
    if (path.contains(Routes.notifications)) return 'Notifications';
    if (path.contains(Routes.profile)) return 'Profile';
    return 'Neuroscan AI';
  }
}

class _ScaffoldWithBody extends StatelessWidget {
  final Widget body;
  const _ScaffoldWithBody({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_getTitle(GoRouterState.of(context).uri.path)),
      ),
      body: body,
    );
  }

  String _getTitle(String path) {
    if (path.contains(Routes.scan)) return 'Scan';
    if (path.contains(Routes.results)) return 'Results';
    if (path.contains(Routes.notifications)) return 'Notifications';
    return '';
  }
}
