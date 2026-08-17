import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM background message: ${message.messageId}');
}

class NotificationService {
  static const _channelId = 'SCAN_NOTIFICATIONS';
  static const _channelName = 'MRI Scan Notifications';
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static String? _fcmToken;

  /// Callback to feed in-memory notification list
  static Function(String title, String message)? onNotificationAdded;

  static String? get fcmToken => _fcmToken;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
      const initSettings = InitializationSettings(android: androidSettings);
      await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint('Notification tapped: ${details.payload}');
        },
      );

      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        const channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: 'Notifications for completed brain MRI scans and cloud sync events',
          importance: Importance.high,
        );
        await androidPlugin.createNotificationChannel(channel);
        debugPrint('Notification channel created: $_channelId');
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('FCM foreground message: ${message.notification?.title}');
        final notification = message.notification;
        if (notification != null) {
          showNotification(
            notification.title ?? 'Neuroscan AI',
            notification.body ?? '',
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('FCM notification tapped (background): ${message.notification?.title}');
      });

      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('FCM notification opened app (cold start): ${initialMessage.notification?.title}');
      }

      _initialized = true;
      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('NotificationService.initialize failed: $e');
    }
  }

  static Future<void> requestPermission() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('FCM permission: ${settings.authorizationStatus}');

      _fcmToken = await messaging.getToken();
      debugPrint('FCM token: $_fcmToken');

      messaging.onTokenRefresh.listen((token) {
        _fcmToken = token;
        debugPrint('FCM token refreshed: $token');
      });
    } catch (e) {
      debugPrint('NotificationService.requestPermission failed: $e');
    }
  }

  static Future<void> showNotification(String title, String message) async {
    // Feed in-memory notification list
    onNotificationAdded?.call(title, message);

    if (!_initialized) {
      debugPrint('NotificationService not initialized, skipping system notification');
      return;
    }

    try {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Notifications for completed brain MRI scans',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
      );
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await _plugin.show(id, title, message, details);
      debugPrint('System notification shown: $title');
    } catch (e) {
      debugPrint('NotificationService.showNotification failed: $e');
    }
  }
}
