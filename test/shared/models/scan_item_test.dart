import 'package:flutter_test/flutter_test.dart';
import 'package:neuroscan_ai/shared/models/scan_item.dart';

void main() {
  test('ScanItem defaults', () {
    const item = ScanItem(resultType: 'Glioma', confidence: 95.0, timestamp: 1000);
    expect(item.id, 0);
    expect(item.gliomaScore, 0.0);
    expect(item.inferenceTimeMs, 0);
  });

  test('ScanItem JSON round-trip', () {
    const item = ScanItem(
      id: 1,
      resultType: 'Meningioma',
      confidence: 87.5,
      timestamp: 2000,
      gliomaScore: 5.0,
      meningiomaScore: 87.5,
      pituitaryScore: 2.0,
      noTumorScore: 5.5,
      inferenceTimeMs: 120,
    );
    final json = item.toJson();
    final restored = ScanItem.fromJson(json);
    expect(restored, item);
  });
}
