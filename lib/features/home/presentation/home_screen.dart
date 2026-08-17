import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _currentTime = DateTime.now());
      return true;
    });
  }

  String get _greeting {
    final hour = _currentTime.hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateStr = DateFormat('EEEE, MMMM d, yyyy • hh:mm a').format(_currentTime);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(_greeting, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: cs.onSurface)),
          Text(dateStr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 32),
          _ActionCard(
            title: 'Scan MRI', subtitle: 'Upload or capture an MRI image',
            icon: Icons.document_scanner, iconBg: cs.primaryContainer, iconTint: cs.onPrimaryContainer,
            borderColor: cs.primaryContainer,
            onTap: () => context.push('/${Routes.scan}'),
          ),
          const SizedBox(height: 16),
          _ActionCard(
            title: 'History', subtitle: 'View previous predictions',
            icon: Icons.history, iconBg: cs.tertiaryContainer, iconTint: cs.onSecondaryContainer,
            borderColor: cs.tertiaryContainer,
            onTap: () => context.push('/${Routes.history}'),
          ),
          const SizedBox(height: 16),
          _ActionCard(
            title: 'About', subtitle: 'Learn more about the application',
            icon: Icons.info, iconBg: cs.secondaryContainer, iconTint: cs.onSecondaryContainer,
            borderColor: cs.secondaryContainer,
            onTap: () => context.push('/${Routes.about}'),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info, color: cs.primaryContainer, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('AI analysis is intended to assist medical professionals and should not replace clinical judgment.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color iconBg, iconTint, borderColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title, required this.subtitle, required this.icon,
    required this.iconBg, required this.iconTint, required this.borderColor, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(width: 4, height: 64, decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 16),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconTint, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: cs.onSurface)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
