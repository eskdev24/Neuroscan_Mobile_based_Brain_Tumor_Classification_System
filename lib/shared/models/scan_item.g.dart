// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanItemImpl _$$ScanItemImplFromJson(Map<String, dynamic> json) =>
    _$ScanItemImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      resultType: json['resultType'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: (json['timestamp'] as num).toInt(),
      imagePath: json['imagePath'] as String?,
      gliomaScore: (json['gliomaScore'] as num?)?.toDouble() ?? 0.0,
      meningiomaScore: (json['meningiomaScore'] as num?)?.toDouble() ?? 0.0,
      pituitaryScore: (json['pituitaryScore'] as num?)?.toDouble() ?? 0.0,
      noTumorScore: (json['noTumorScore'] as num?)?.toDouble() ?? 0.0,
      inferenceTimeMs: (json['inferenceTimeMs'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ScanItemImplToJson(_$ScanItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'resultType': instance.resultType,
      'confidence': instance.confidence,
      'timestamp': instance.timestamp,
      'imagePath': instance.imagePath,
      'gliomaScore': instance.gliomaScore,
      'meningiomaScore': instance.meningiomaScore,
      'pituitaryScore': instance.pituitaryScore,
      'noTumorScore': instance.noTumorScore,
      'inferenceTimeMs': instance.inferenceTimeMs,
    };
