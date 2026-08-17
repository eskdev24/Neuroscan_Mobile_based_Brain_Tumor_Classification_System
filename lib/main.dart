import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/firebase/firebase_init.dart';
import 'core/notifications/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.red.shade900,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          '${details.exceptionAsString()}\n\n${details.stack ?? ""}',
          style: const TextStyle(color: Colors.yellow, fontSize: 12),
        ),
      ),
    );
  };

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };

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
