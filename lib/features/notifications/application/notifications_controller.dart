import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/notification_item.dart';

class NotificationsController extends Notifier<List<NotificationItem>> {
  @override
  List<NotificationItem> build() => [];

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
}
