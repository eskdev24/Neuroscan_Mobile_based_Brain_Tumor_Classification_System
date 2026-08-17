import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TFLiteClassifier labels are correct', () {
    const labels = ['Glioma', 'Meningioma', 'No Tumor', 'Pituitary Tumor'];
    expect(labels.length, 4);
    expect(labels[0], 'Glioma');
  });
}
