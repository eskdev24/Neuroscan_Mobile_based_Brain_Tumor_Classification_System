import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../shared/models/scan_item.dart';
import 'scan_local_dao.dart';

class ScanRepository {
  final ScanLocalDao _dao;
  ScanRepository(this._dao);

  Stream<List<ScanItem>> get allScans async* {
    while (true) {
      yield await _dao.getAllScans();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<int> insert(ScanItem scan) async {
    final id = await _dao.insertScan(scan);
    await _backupToFirebase(scan.copyWith(id: id));
    return id;
  }

  Future<void> deleteItem(ScanItem scan) async {
    await _dao.deleteScan(scan);
    await _removeFromFirebase(scan);
  }

  Future<void> clear() async {
    await _dao.clearHistory();
    await _clearFirebase();
  }

  Future<void> syncFromFirebase() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final snapshot =
          await FirebaseDatabase.instance.ref('scans/$uid').get();
      if (!snapshot.exists || snapshot.value == null) return;

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final localScans = await _dao.getAllScans();
      final localIds = localScans.map((s) => s.id).toSet();

      for (final entry in data.entries) {
        try {
          final scanData = Map<String, dynamic>.from(entry.value as Map);
          final scan = ScanItem.fromJson(scanData);
          if (!localIds.contains(scan.id)) {
            await _dao.insertScan(scan);
          }
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> _backupToFirebase(ScanItem scan) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await FirebaseDatabase.instance
          .ref('scans/$uid/${scan.id}')
          .set(scan.toJson());
    } catch (_) {}
  }

  Future<void> _removeFromFirebase(ScanItem scan) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await FirebaseDatabase.instance
          .ref('scans/$uid/${scan.id}')
          .remove();
    } catch (_) {}
  }

  Future<void> _clearFirebase() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await FirebaseDatabase.instance.ref('scans/$uid').remove();
    } catch (_) {}
  }
}
