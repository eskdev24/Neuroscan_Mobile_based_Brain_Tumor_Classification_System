// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScanItem _$ScanItemFromJson(Map<String, dynamic> json) {
  return _ScanItem.fromJson(json);
}

/// @nodoc
mixin _$ScanItem {
  int get id => throw _privateConstructorUsedError;
  String get resultType => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  double get gliomaScore => throw _privateConstructorUsedError;
  double get meningiomaScore => throw _privateConstructorUsedError;
  double get pituitaryScore => throw _privateConstructorUsedError;
  double get noTumorScore => throw _privateConstructorUsedError;
  int get inferenceTimeMs => throw _privateConstructorUsedError;

  /// Serializes this ScanItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanItemCopyWith<ScanItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanItemCopyWith<$Res> {
  factory $ScanItemCopyWith(ScanItem value, $Res Function(ScanItem) then) =
      _$ScanItemCopyWithImpl<$Res, ScanItem>;
  @useResult
  $Res call({
    int id,
    String resultType,
    double confidence,
    int timestamp,
    String? imagePath,
    double gliomaScore,
    double meningiomaScore,
    double pituitaryScore,
    double noTumorScore,
    int inferenceTimeMs,
  });
}

/// @nodoc
class _$ScanItemCopyWithImpl<$Res, $Val extends ScanItem>
    implements $ScanItemCopyWith<$Res> {
  _$ScanItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resultType = null,
    Object? confidence = null,
    Object? timestamp = null,
    Object? imagePath = freezed,
    Object? gliomaScore = null,
    Object? meningiomaScore = null,
    Object? pituitaryScore = null,
    Object? noTumorScore = null,
    Object? inferenceTimeMs = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            resultType: null == resultType
                ? _value.resultType
                : resultType // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
            imagePath: freezed == imagePath
                ? _value.imagePath
                : imagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            gliomaScore: null == gliomaScore
                ? _value.gliomaScore
                : gliomaScore // ignore: cast_nullable_to_non_nullable
                      as double,
            meningiomaScore: null == meningiomaScore
                ? _value.meningiomaScore
                : meningiomaScore // ignore: cast_nullable_to_non_nullable
                      as double,
            pituitaryScore: null == pituitaryScore
                ? _value.pituitaryScore
                : pituitaryScore // ignore: cast_nullable_to_non_nullable
                      as double,
            noTumorScore: null == noTumorScore
                ? _value.noTumorScore
                : noTumorScore // ignore: cast_nullable_to_non_nullable
                      as double,
            inferenceTimeMs: null == inferenceTimeMs
                ? _value.inferenceTimeMs
                : inferenceTimeMs // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScanItemImplCopyWith<$Res>
    implements $ScanItemCopyWith<$Res> {
  factory _$$ScanItemImplCopyWith(
    _$ScanItemImpl value,
    $Res Function(_$ScanItemImpl) then,
  ) = __$$ScanItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String resultType,
    double confidence,
    int timestamp,
    String? imagePath,
    double gliomaScore,
    double meningiomaScore,
    double pituitaryScore,
    double noTumorScore,
    int inferenceTimeMs,
  });
}

/// @nodoc
class __$$ScanItemImplCopyWithImpl<$Res>
    extends _$ScanItemCopyWithImpl<$Res, _$ScanItemImpl>
    implements _$$ScanItemImplCopyWith<$Res> {
  __$$ScanItemImplCopyWithImpl(
    _$ScanItemImpl _value,
    $Res Function(_$ScanItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resultType = null,
    Object? confidence = null,
    Object? timestamp = null,
    Object? imagePath = freezed,
    Object? gliomaScore = null,
    Object? meningiomaScore = null,
    Object? pituitaryScore = null,
    Object? noTumorScore = null,
    Object? inferenceTimeMs = null,
  }) {
    return _then(
      _$ScanItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        resultType: null == resultType
            ? _value.resultType
            : resultType // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        imagePath: freezed == imagePath
            ? _value.imagePath
            : imagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        gliomaScore: null == gliomaScore
            ? _value.gliomaScore
            : gliomaScore // ignore: cast_nullable_to_non_nullable
                  as double,
        meningiomaScore: null == meningiomaScore
            ? _value.meningiomaScore
            : meningiomaScore // ignore: cast_nullable_to_non_nullable
                  as double,
        pituitaryScore: null == pituitaryScore
            ? _value.pituitaryScore
            : pituitaryScore // ignore: cast_nullable_to_non_nullable
                  as double,
        noTumorScore: null == noTumorScore
            ? _value.noTumorScore
            : noTumorScore // ignore: cast_nullable_to_non_nullable
                  as double,
        inferenceTimeMs: null == inferenceTimeMs
            ? _value.inferenceTimeMs
            : inferenceTimeMs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanItemImpl implements _ScanItem {
  const _$ScanItemImpl({
    this.id = 0,
    required this.resultType,
    required this.confidence,
    required this.timestamp,
    this.imagePath,
    this.gliomaScore = 0.0,
    this.meningiomaScore = 0.0,
    this.pituitaryScore = 0.0,
    this.noTumorScore = 0.0,
    this.inferenceTimeMs = 0,
  });

  factory _$ScanItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanItemImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  final String resultType;
  @override
  final double confidence;
  @override
  final int timestamp;
  @override
  final String? imagePath;
  @override
  @JsonKey()
  final double gliomaScore;
  @override
  @JsonKey()
  final double meningiomaScore;
  @override
  @JsonKey()
  final double pituitaryScore;
  @override
  @JsonKey()
  final double noTumorScore;
  @override
  @JsonKey()
  final int inferenceTimeMs;

  @override
  String toString() {
    return 'ScanItem(id: $id, resultType: $resultType, confidence: $confidence, timestamp: $timestamp, imagePath: $imagePath, gliomaScore: $gliomaScore, meningiomaScore: $meningiomaScore, pituitaryScore: $pituitaryScore, noTumorScore: $noTumorScore, inferenceTimeMs: $inferenceTimeMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.resultType, resultType) ||
                other.resultType == resultType) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.gliomaScore, gliomaScore) ||
                other.gliomaScore == gliomaScore) &&
            (identical(other.meningiomaScore, meningiomaScore) ||
                other.meningiomaScore == meningiomaScore) &&
            (identical(other.pituitaryScore, pituitaryScore) ||
                other.pituitaryScore == pituitaryScore) &&
            (identical(other.noTumorScore, noTumorScore) ||
                other.noTumorScore == noTumorScore) &&
            (identical(other.inferenceTimeMs, inferenceTimeMs) ||
                other.inferenceTimeMs == inferenceTimeMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    resultType,
    confidence,
    timestamp,
    imagePath,
    gliomaScore,
    meningiomaScore,
    pituitaryScore,
    noTumorScore,
    inferenceTimeMs,
  );

  /// Create a copy of ScanItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanItemImplCopyWith<_$ScanItemImpl> get copyWith =>
      __$$ScanItemImplCopyWithImpl<_$ScanItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanItemImplToJson(this);
  }
}

abstract class _ScanItem implements ScanItem {
  const factory _ScanItem({
    final int id,
    required final String resultType,
    required final double confidence,
    required final int timestamp,
    final String? imagePath,
    final double gliomaScore,
    final double meningiomaScore,
    final double pituitaryScore,
    final double noTumorScore,
    final int inferenceTimeMs,
  }) = _$ScanItemImpl;

  factory _ScanItem.fromJson(Map<String, dynamic> json) =
      _$ScanItemImpl.fromJson;

  @override
  int get id;
  @override
  String get resultType;
  @override
  double get confidence;
  @override
  int get timestamp;
  @override
  String? get imagePath;
  @override
  double get gliomaScore;
  @override
  double get meningiomaScore;
  @override
  double get pituitaryScore;
  @override
  double get noTumorScore;
  @override
  int get inferenceTimeMs;

  /// Create a copy of ScanItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanItemImplCopyWith<_$ScanItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
