import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/prediction_result.dart';
import '../../../shared/models/scan_item.dart';
import '../data/tflite_classifier.dart';
import '../data/scan_repository.dart';
import '../data/scan_local_dao.dart';

class ScanController extends Notifier<AsyncValue<PredictionResult?>> {
  late TFLiteClassifier _classifier;
  late ScanRepository _repo;
  Uint8List? _currentImageBytes;

  @override
  AsyncValue<PredictionResult?> build() {
    _repo = ScanRepository(ScanLocalDao());
    return const AsyncValue.data(null);
  }

  Future<void> initClassifier() async {
    _classifier = await TFLiteClassifier.getInstance();
  }

  Future<void> analyzeImage(Uint8List imageBytes) async {
    _currentImageBytes = imageBytes;
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final sw = Stopwatch()..start();
      final scores = await _classifier.classify(imageBytes);
      sw.stop();
      if (scores.isEmpty) {
        state = AsyncValue.error('Failed to classify image.', StackTrace.current);
        return;
      }
      String primaryType = 'No Tumor';
      double maxConfidence = 0;
      for (final entry in scores.entries) {
        if (entry.value > maxConfidence) {
          maxConfidence = entry.value;
          primaryType = entry.key;
        }
      }
      state = AsyncValue.data(PredictionResult(
        type: primaryType,
        confidence: maxConfidence,
        scores: scores,
        inferenceTimeMs: sw.elapsedMilliseconds,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveResult() async {
    final result = state.value;
    if (result == null || _currentImageBytes == null) return;
    final item = ScanItem(
      resultType: result.type,
      confidence: result.confidence,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      gliomaScore: result.scores['Glioma'] ?? 0,
      meningiomaScore: result.scores['Meningioma'] ?? 0,
      pituitaryScore: result.scores['Pituitary Tumor'] ?? 0,
      noTumorScore: result.scores['No Tumor'] ?? 0,
      inferenceTimeMs: result.inferenceTimeMs,
    );
    await _repo.insert(item);
  }

  void clearResult() {
    _currentImageBytes = null;
    state = const AsyncValue.data(null);
  }

  Uint8List? get currentImageBytes => _currentImageBytes;
}

final scanControllerProvider =
    NotifierProvider<ScanController, AsyncValue<PredictionResult?>>(ScanController.new);
