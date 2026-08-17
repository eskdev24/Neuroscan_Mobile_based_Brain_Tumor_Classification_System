class PredictionResult {
  final String type;
  final double confidence;
  final Map<String, double> scores;
  final int inferenceTimeMs;

  const PredictionResult({
    required this.type,
    required this.confidence,
    required this.scores,
    required this.inferenceTimeMs,
  });
}
