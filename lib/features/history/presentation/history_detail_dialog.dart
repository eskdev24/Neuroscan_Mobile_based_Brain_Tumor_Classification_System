import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../shared/models/scan_item.dart';
import '../../../core/pdf/pdf_generator.dart';
import '../../../core/notifications/notification_service.dart';

class HistoryDetailDialog extends StatefulWidget {
  final ScanItem item;
  final VoidCallback onDismiss;
  final VoidCallback onDelete;

  const HistoryDetailDialog({
    super.key,
    required this.item,
    required this.onDismiss,
    required this.onDelete,
  });

  @override
  State<HistoryDetailDialog> createState() => _HistoryDetailDialogState();
}

class _HistoryDetailDialogState extends State<HistoryDetailDialog> {
  bool _isGeneratingPdf = false;

  Color get _statusColor {
    return switch (widget.item.resultType) {
      'Glioma' => const Color(0xFF4EDEA3),
      'Meningioma' => const Color(0xFF2563EB),
      'Pituitary Tumor' => const Color(0xFF7D4CE7),
      _ => const Color(0xFF8D90A0),
    };
  }

  Color get _containerColor {
    return switch (widget.item.resultType) {
      'Glioma' => const Color(0x264EDEA3),
      'Meningioma' => const Color(0x262563EB),
      'Pituitary Tumor' => const Color(0x267D4CE7),
      _ => const Color(0x268D90A0),
    };
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('MMM dd, yyyy \u2022 hh:mm a').format(date);
  }

  String get _description {
    return switch (widget.item.resultType) {
      'Glioma' => 'A primary brain tumor that originates from the glial cells in the brain or spinal cord.',
      'Meningioma' => 'A tumor that arises from the meninges, the membranes that surround the brain and spinal cord. Most are slow-growing and benign.',
      'Pituitary Tumor' => 'An abnormal growth in the pituitary gland. Most are noncancerous adenomas that may affect hormone levels.',
      'No Tumor' => 'The scan appears clear of these specific tumor types.',
      _ => 'Information not available.',
    };
  }

  Future<void> _sharePdf() async {
    setState(() => _isGeneratingPdf = true);
    try {
      Uint8List? imageBytes;
      if (widget.item.imagePath != null && File(widget.item.imagePath!).existsSync()) {
        imageBytes = await File(widget.item.imagePath!).readAsBytes();
      }
      
      // Load logo
      final logoData = await rootBundle.load('assets/images/app_icon.png');
      final logoBytes = logoData.buffer.asUint8List();
      
      final pdfBytes = await PdfGenerator.generate(widget.item, imageBytes, logoBytes: logoBytes);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/neuroscan_report_${widget.item.timestamp}.pdf');
      await file.writeAsBytes(pdfBytes);
      
      if (mounted) {
        widget.onDismiss();
      }
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'NEUROSCAN AI Report',
      );
      
      NotificationService.showNotification(
        'Report Shared',
        'Neuroscan AI report has been shared successfully.',
      );
    } catch (e) {
      print('[SharePdf] Error: $e');
      NotificationService.showNotification(
        'Share Failed',
        'Could not share the report: $e',
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _downloadPdf() async {
    setState(() => _isGeneratingPdf = true);
    try {
      Uint8List? imageBytes;
      if (widget.item.imagePath != null && File(widget.item.imagePath!).existsSync()) {
        imageBytes = await File(widget.item.imagePath!).readAsBytes();
      }
      
      // Load logo
      final logoData = await rootBundle.load('assets/images/app_icon.png');
      final logoBytes = logoData.buffer.asUint8List();
      
      print('[DownloadPdf] Generating PDF...');
      final pdfBytes = await PdfGenerator.generate(widget.item, imageBytes, logoBytes: logoBytes);
      print('[DownloadPdf] PDF generated, size: ${pdfBytes.length} bytes');
      
      final fileName = 'neuroscan_report_${widget.item.timestamp}.pdf';
      final downloadsPath = '/storage/emulated/0/Download';
      
      final file = File('$downloadsPath/$fileName');
      await file.writeAsBytes(pdfBytes);
      
      final fileExists = await file.exists();
      final fileSize = await file.length();
      print('[DownloadPdf] File saved to: $downloadsPath/$fileName, exists: $fileExists, size: $fileSize bytes');
      
      if (mounted) {
        widget.onDismiss();
      }
      
      NotificationService.showNotification(
        'Report Downloaded',
        'PDF saved to Downloads folder: $fileName',
      );
    } catch (e, st) {
      print('[DownloadPdf] Error: $e');
      print('[DownloadPdf] Stack trace: $st');
      NotificationService.showNotification(
        'Download Failed',
        'Could not generate report: $e',
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateStr = _formatDate(widget.item.timestamp);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: cs.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scan Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onDismiss,
                    icon: Icon(Icons.close, color: cs.onSurface),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: widget.item.imagePath != null && File(widget.item.imagePath!).existsSync()
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(widget.item.imagePath!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.search,
                              size: 48,
                              color: cs.outlineVariant,
                            ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.item.resultType,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _statusColor,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                            '${widget.item.confidence.toStringAsFixed(1)}%',
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
                    if (widget.item.inferenceTimeMs > 0)
                      Text(
                        'Inference time: ${widget.item.inferenceTimeMs} ms',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info,
                            size: 20,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _description,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Confidence Scores',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ConfidenceBar(label: 'Glioma', score: widget.item.gliomaScore, color: const Color(0xFF4EDEA3)),
                    const SizedBox(height: 12),
                    _ConfidenceBar(label: 'Meningioma', score: widget.item.meningiomaScore, color: const Color(0xFF2563EB)),
                    const SizedBox(height: 12),
                    _ConfidenceBar(label: 'Pituitary Tumor', score: widget.item.pituitaryScore, color: const Color(0xFF7D4CE7)),
                    const SizedBox(height: 12),
                    _ConfidenceBar(label: 'No Tumor', score: widget.item.noTumorScore, color: const Color(0xFF8D90A0)),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isGeneratingPdf ? null : _sharePdf,
                        icon: _isGeneratingPdf
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.share, size: 16),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isGeneratingPdf ? null : _downloadPdf,
                        icon: _isGeneratingPdf
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.download, size: 16),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.secondaryContainer,
                          foregroundColor: cs.onSecondaryContainer,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
              ),
            ),
            Text(
              '${score.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
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
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: (score / 100).clamp(0.0, 1.0),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}