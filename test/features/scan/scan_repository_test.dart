import 'package:flutter_test/flutter_test.dart';
import 'package:neuroscan_ai/shared/models/scan_item.dart';

void main() {
  test('ScanItem copyWith overrides fields', () {
    const item = ScanItem(resultType: 'Glioma', confidence: 90, timestamp: 1000);
    final updated = item.copyWith(id: 42, confidence: 95);
    expect(updated.id, 42);
    expect(updated.confidence, 95);
    expect(updated.resultType, 'Glioma');
  });
}
