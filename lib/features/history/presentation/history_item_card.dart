import 'dart:io';
import 'package:flutter/material.dart';
import '../../../shared/models/scan_item.dart';

class HistoryItemCard extends StatelessWidget {
  final ScanItem item;
  final VoidCallback onClick;

  const HistoryItemCard({
    super.key,
    required this.item,
    required this.onClick,
  });

  Color get _statusColor {
    return switch (item.resultType) {
      'Glioma' => const Color(0xFF4EDEA3),
      'Meningioma' => const Color(0xFF2563EB),
      'Pituitary Tumor' => const Color(0xFF7D4CE7),
      _ => const Color(0xFF8D90A0),
    };
  }

  Color get _containerColor {
    return switch (item.resultType) {
      'Glioma' => const Color(0x264EDEA3),
      'Meningioma' => const Color(0x262563EB),
      'Pituitary Tumor' => const Color(0x267D4CE7),
      _ => const Color(0x268D90A0),
    };
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final month = _monthAbbr(date.month);
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$month ${date.day.toString().padLeft(2, '0')}, ${date.year} \u2022 ${hour.toString().padLeft(2, '0')}:$minute $amPm';
  }

  String _monthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateStr = _formatDate(item.timestamp);

    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 64,
              decoration: BoxDecoration(
                color: _statusColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.imagePath != null && File(item.imagePath!).existsSync()
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(item.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.search,
                      size: 32,
                      color: cs.onSurfaceVariant,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.resultType,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _containerColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _statusColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '${item.confidence.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: _statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
