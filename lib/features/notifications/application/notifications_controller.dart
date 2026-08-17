import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../shared/models/notification_item.dart';

final notificationsProvider = NotifierProvider<NotificationsController, List<NotificationItem>>(
  NotificationsController.new,
);

class NotificationsController extends Notifier<List<NotificationItem>> {
  @override
  List<NotificationItem> build() {
    // Wire up NotificationService to feed this in-memory list
    NotificationService.onNotificationAdded = (title, message) {
      addNotification(title, message);
    };
    return [];
  }

  void addNotification(String title, String message) {
    state = [
      NotificationItem(
        id: '${DateTime.now().millisecondsSinceEpoch}_${100 + (900 * (DateTime.now().microsecond / 1000000)).toInt()}',
        title: title,
        message: message,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      ...state,
    ];
  }

  int get unreadCount => state.length;
}
