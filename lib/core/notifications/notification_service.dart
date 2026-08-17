import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static const _channelId = 'SCAN_NOTIFICATIONS';
  static const _channelName = 'MRI Scan Notifications';
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      await _plugin.initialize(initSettings);

      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        const channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: 'Notifications for completed brain MRI scans and cloud sync events',
          importance: Importance.defaultImportance,
        );
        await androidPlugin.createNotificationChannel(channel);
      }

      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService.initialize failed: $e');
    }
  }

  static Future<void> requestPermission() async {
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
    } catch (e) {
      debugPrint('NotificationService.requestPermission failed: $e');
    }
  }

  static Future<void> showNotification(String title, String message) async {
    if (!_initialized) return;

    try {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      );
      await _plugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        message,
        details,
      );
    } catch (e) {
      debugPrint('NotificationService.showNotification failed: $e');
    }
  }
}
