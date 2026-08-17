import 'dart:async';
import 'package:flutter/foundation.dart';
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
    debugPrint('Stack: ${details.stack}');
  };

  runZonedGuarded<Future<void>>(() async {
    try {
      await FirebaseInit.initialize();
    } catch (e, st) {
      debugPrint('Firebase init failed: $e');
      debugPrint('Stack: $st');
    }

    try {
      await NotificationService.initialize();
    } catch (e, st) {
      debugPrint('Notification init failed: $e');
      debugPrint('Stack: $st');
    }

    try {
      await NotificationService.requestPermission();
    } catch (e, st) {
      debugPrint('Notification permission failed: $e');
      debugPrint('Stack: $st');
    }

    runApp(const ProviderScope(child: NeuroscanApp()));
  }, (error, stack) {
    debugPrint('Uncaught error: $error');
    debugPrint('Stack: $stack');
  });
}
