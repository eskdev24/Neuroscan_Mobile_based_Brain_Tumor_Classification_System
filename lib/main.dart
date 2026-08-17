import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/firebase/firebase_init.dart';
import 'core/notifications/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await FirebaseInit.initialize();
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }

  try {
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('Notification init failed: $e');
  }

  try {
    await NotificationService.requestPermission();
  } catch (e) {
    debugPrint('Notification permission failed: $e');
  }

  runApp(const ProviderScope(child: NeuroscanApp()));
}
