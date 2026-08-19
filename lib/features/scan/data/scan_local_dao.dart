import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import '../../../shared/models/scan_item.dart';

class ScanLocalDao {
  Database? _db;
  String? _currentUid;

  String get _dbName {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    return 'neuroscan_$uid';
  }

  Future<Database> get database async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    if (_db != null && _currentUid == uid) return _db!;
    _currentUid = uid;
    _db = await openDatabase(
      _dbName,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scan_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            resultType TEXT NOT NULL,
            confidence REAL NOT NULL,
            timestamp INTEGER NOT NULL,
            imagePath TEXT,
            gliomaScore REAL NOT NULL DEFAULT 0,
            meningiomaScore REAL NOT NULL DEFAULT 0,
            pituitaryScore REAL NOT NULL DEFAULT 0,
            noTumorScore REAL NOT NULL DEFAULT 0,
            inferenceTimeMs INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
    return _db!;
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      _currentUid = null;
    }
  }

  Future<int> insertScan(ScanItem scan) async {
    final db = await database;
    return db.insert('scan_history', scan.toJson()..remove('id'), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ScanItem>> getAllScans() async {
    final db = await database;
    final rows = await db.query('scan_history', orderBy: 'timestamp DESC');
    return rows.map((r) => ScanItem.fromJson(r)).toList();
  }

  Future<void> deleteScan(ScanItem scan) async {
    final db = await database;
    await db.delete('scan_history', where: 'id = ?', whereArgs: [scan.id]);
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('scan_history');
  }
}
