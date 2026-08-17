// test/core/theme/theme_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroscan_ai/core/theme/theme.dart';

void main() {
  test('appTheme uses dark brightness', () {
    expect(appTheme.brightness, Brightness.dark);
  });

  test('appTheme uses Material 3', () {
    expect(appTheme.useMaterial3, isTrue);
  });
}
