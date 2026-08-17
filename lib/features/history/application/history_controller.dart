import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> deleteItem(ScanItem item) => _repo.deleteItem(item);
  Future<void> clearHistory() => _repo.clear();
}
