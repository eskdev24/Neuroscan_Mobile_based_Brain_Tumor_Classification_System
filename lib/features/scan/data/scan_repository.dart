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
    _backupToFirebase(scan.copyWith(id: id));
    return id;
  }

  Future<void> deleteItem(ScanItem scan) async {
    await _dao.deleteScan(scan);
    _removeFromFirebase(scan);
  }

  Future<void> clear() async {
    await _dao.clearHistory();
    _clearFirebase();
  }

  void _backupToFirebase(ScanItem scan) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    FirebaseDatabase.instance.ref('scans/$uid/${scan.id}').set(scan.toJson());
  }

  void _removeFromFirebase(ScanItem scan) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    FirebaseDatabase.instance.ref('scans/$uid/${scan.id}').remove();
  }

  void _clearFirebase() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    FirebaseDatabase.instance.ref('scans/$uid').remove();
  }
}
