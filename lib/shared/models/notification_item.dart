class NotificationItem {
  final String id;
  final String title;
  final String message;
  final int timestamp;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}
