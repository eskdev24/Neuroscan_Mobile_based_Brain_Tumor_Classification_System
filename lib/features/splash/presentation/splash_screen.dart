import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/routing/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.reload();
      } catch (_) {}
      if (!mounted) return;
      if (user.emailVerified) {
        context.go('/${Routes.home}');
      } else {
        FirebaseAuth.instance.signOut();
        context.go('/${Routes.welcome}');
      }
    } else {
      context.go('/${Routes.welcome}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.psychology, size: 160, color: cs.primary),
            const SizedBox(height: 32),
            Text('Neuroscan AI', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: cs.onSurface)),
            Text('AI-Powered Brain Tumor Diagnosis',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 64),
            CircularProgressIndicator(color: cs.primary, strokeWidth: 4),
            const SizedBox(height: 16),
            Text('LOADING MODEL...', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: cs.primary)),
          ],
        ),
      ),
    );
  }
}
