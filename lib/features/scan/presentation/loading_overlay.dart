import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 120, color: cs.primary),
            const SizedBox(height: 32),
            Text('Neuroscan AI', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: cs.onSurface)),
            Text('AI-Powered Brain Tumor Detection',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 64),
            CircularProgressIndicator(color: cs.primary, strokeWidth: 4),
            const SizedBox(height: 16),
            Text('LOADING MODEL...', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: cs.primary)),
          ],
        ),
      ),
    );
  }
}
