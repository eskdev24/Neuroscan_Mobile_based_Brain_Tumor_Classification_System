import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/routing/routes.dart';
import '../application/scan_controller.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final scanState = ref.watch(scanControllerProvider);

    if (!scanState.hasValue || scanState.value == null) {
      return Scaffold(
        body: Center(
          child: Text('No result available', style: TextStyle(color: cs.onSurface)),
        ),
      );
    }

    final result = scanState.value!;
    final (statusColor, containerColor) = _getStatusColors(result.type);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.check_circle, color: statusColor, size: 32),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Prediction',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: cs.onSurfaceVariant,
                                        ),
                                      ),
                                      Text(result.type,
                                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text('Confidence:',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: cs.onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text('${result.confidence.toStringAsFixed(1)}%',
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: cs.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text('Inference Time:',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: cs.onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text('${result.inferenceTimeMs} ms',
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                              color: cs.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info, size: 20, color: cs.onSurfaceVariant),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _getDescription(result.type),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Confidence Scores',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ..._getScoreEntries(result.scores).map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _ConfidenceBar(
                                  label: entry.key,
                                  score: entry.value,
                                  color: _getBarColor(entry.key),
                                ),
                              );
                            }),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: cs.outlineVariant),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info, size: 16, color: cs.onSurfaceVariant),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'This prediction is generated by AI and should be reviewed by a medical professional.',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(scanControllerProvider.notifier).saveResult();
                    ref.read(scanControllerProvider.notifier).clearResult();
                    if (context.mounted) {
                      context.go('/${Routes.home}');
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Result', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primaryContainer,
                    foregroundColor: cs.onPrimaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  (Color, Color) _getStatusColors(String type) {
    switch (type) {
      case 'Glioma':
        return (const Color(0xFF4EDEA3), const Color(0x334EDEA3));
      case 'Meningioma':
        return (const Color(0xFF2563EB), const Color(0x332563EB));
      case 'Pituitary Tumor':
        return (const Color(0xFF7D4CE7), const Color(0x337D4CE7));
      default:
        return (const Color(0xFF8D90A0), const Color(0x338D90A0));
    }
  }

  Color _getBarColor(String type) {
    switch (type) {
      case 'Glioma':
        return const Color(0xFF4EDEA3);
      case 'Meningioma':
        return const Color(0xFF2563EB);
      case 'Pituitary Tumor':
        return const Color(0xFF7D4CE7);
      default:
        return const Color(0xFF8D90A0);
    }
  }

  String _getDescription(String type) {
    switch (type) {
      case 'Glioma':
        return 'A primary brain tumor that originates from the glial cells in the brain or spinal cord.';
      case 'Meningioma':
        return 'A tumor that arises from the meninges, the membranes that surround the brain and spinal cord. Most are slow-growing and benign.';
      case 'Pituitary Tumor':
        return 'An abnormal growth in the pituitary gland. Most are noncancerous adenomas that may affect hormone levels.';
      case 'No Tumor':
        return 'The scan appears clear of these specific tumor types.';
      default:
        return 'Information not available.';
    }
  }

  List<MapEntry<String, double>> _getScoreEntries(Map<String, double> scores) {
    const keys = ['Glioma', 'Meningioma', 'Pituitary Tumor', 'No Tumor'];
    return keys.map((key) => MapEntry(key, scores[key] ?? 0)).toList();
  }
}

class _ConfidenceBar extends StatelessWidget {
  final String label;
  final double score;
  final Color color;

  const _ConfidenceBar({
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
            )),
            Text('${score.toStringAsFixed(1)}%', style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
            )),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF26364A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (score / 100).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
