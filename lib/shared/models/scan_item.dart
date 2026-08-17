import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_item.freezed.dart';
part 'scan_item.g.dart';

@freezed
class ScanItem with _$ScanItem {
  const factory ScanItem({
    @Default(0) int id,
    required String resultType,
    required double confidence,
    required int timestamp,
    String? imagePath,
    @Default(0.0) double gliomaScore,
    @Default(0.0) double meningiomaScore,
    @Default(0.0) double pituitaryScore,
    @Default(0.0) double noTumorScore,
    @Default(0) int inferenceTimeMs,
  }) = _ScanItem;

  factory ScanItem.fromJson(Map<String, dynamic> json) =>
      _$ScanItemFromJson(json);
}
