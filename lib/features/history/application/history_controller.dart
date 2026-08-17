import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../shared/models/scan_item.dart';
import '../../scan/data/scan_repository.dart';
import '../../scan/data/scan_local_dao.dart';

final historyControllerProvider = StreamNotifierProvider<HistoryController, List<ScanItem>>(
  HistoryController.new,
);

class HistoryController extends StreamNotifier<List<ScanItem>> {
  late ScanRepository _repo;

  @override
  Stream<List<ScanItem>> build() {
    _repo = ScanRepository(ScanLocalDao());
    return _repo.allScans;
  }

  Future<void> deleteItem(ScanItem item) async {
    try {
      await _repo.deleteItem(item);
      NotificationService.showNotification(
        'Item Deleted',
        'The scan history item has been deleted.',
      );
    } catch (e) {
      NotificationService.showNotification(
        'Error Deleting Item',
        'Could not delete item: $e',
      );
    }
  }

  Future<void> clearHistory() async {
    try {
      await _repo.clear();
      NotificationService.showNotification(
        'History Cleared',
        'All scan history has been removed.',
      );
    } catch (e) {
      NotificationService.showNotification(
        'Error Clearing History',
        'Could not clear history: $e',
      );
    }
  }
}
