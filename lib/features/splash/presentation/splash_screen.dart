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
    return const Scaffold(
      backgroundColor: Color(0xFF0B1426),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(flex: 3),
            Image(
              image: AssetImage('assets/images/img_splash.png'),
              width: 120,
              height: 120,
            ),
            SizedBox(height: 32),
            Text(
              'Neuroscan AI',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'AI-Powered Brain Tumor Diagnosis',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8B9CB6),
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(flex: 3),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFF5B7BA5),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'LOADING MODEL...',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 2,
                color: Color(0xFF5B7BA5),
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
