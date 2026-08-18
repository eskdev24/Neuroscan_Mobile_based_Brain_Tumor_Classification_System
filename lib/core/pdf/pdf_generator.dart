import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../shared/models/scan_item.dart';

class PdfGenerator {
  static Future<Uint8List> generate(ScanItem item, Uint8List? imageBytes, {Uint8List? logoBytes}) async {
    final pdf = pw.Document();
    final description = _getDescription(item.resultType);
    final date = DateTime.fromMillisecondsSinceEpoch(item.timestamp);
    final dateStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final timeStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    final statusColor = _getStatusColor(item.resultType);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Top accent bar
              pw.Container(
                width: double.infinity,
                height: 4,
                decoration: const pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [PdfColor.fromInt(0xFF0D9488), PdfColor.fromInt(0xFF06B6D4)],
                  ),
                ),
              ),

              // Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.fromLTRB(40, 28, 40, 20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                // App Logo
                                logoBytes != null
                                    ? pw.Container(
                                        width: 32,
                                        height: 32,
                                        child: pw.Image(pw.MemoryImage(logoBytes)),
                                      )
                                    : pw.Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const pw.BoxDecoration(
                                          color: PdfColor.fromInt(0xFF0D9488),
                                          shape: pw.BoxShape.circle,
                                        ),
                                        child: pw.Center(
                                          child: pw.Text(
                                            '+',
                                            style: pw.TextStyle(
                                              color: PdfColors.white,
                                              fontSize: 20,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                pw.SizedBox(width: 10),
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'NEUROSCAN AI',
                                      style: pw.TextStyle(
                                        color: PdfColor.fromInt(0xFF0F172A),
                                        fontSize: 18,
                                        fontWeight: pw.FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    pw.Text(
                                      'Neuroimaging Classification System',
                                      style: pw.TextStyle(
                                        color: PdfColor.fromInt(0xFF64748B),
                                        fontSize: 9,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: pw.BoxDecoration(
                                color: statusColor,
                                borderRadius: pw.BorderRadius.circular(4),
                              ),
                              child: pw.Text(
                                item.resultType.toUpperCase(),
                                style: const pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 6),
                            pw.Text(
                              'Report ID: NRS-${item.timestamp.toString().substring(item.timestamp.toString().length - 8)}',
                              style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF94A3B8),
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 16),
                    pw.Container(
                      width: double.infinity,
                      height: 1,
                      color: PdfColor.fromInt(0xFFE2E8F0),
                    ),
                  ],
                ),
              ),

              // Scan Details Bar
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                decoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFF8FAFC),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    _detailItem('EXAMINATION', 'Brain MRI'),
                    _divider(),
                    _detailItem('DATE', dateStr),
                    _divider(),
                    _detailItem('TIME', timeStr),
                    _divider(),
                    _detailItem('INFERENCE', '${item.inferenceTimeMs}ms'),
                    _divider(),
                    _detailItem('STATUS', 'Completed'),
                  ],
                ),
              ),

              pw.SizedBox(height: 24),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 40),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Section: Classification Result
                    _sectionHeader('CLASSIFICATION RESULT'),
                    pw.SizedBox(height: 12),
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(20),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: PdfColor.fromInt(0xFFE2E8F0)),
                        boxShadow: [
                          pw.BoxShadow(
                            color: PdfColor.fromInt(0xFF000000),
                            blurRadius: 8,
                            offset: const PdfPoint(0, 2),
                          ),
                        ],
                      ),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Primary Finding',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColor.fromInt(0xFF94A3B8),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                pw.SizedBox(height: 6),
                                pw.Text(
                                  item.resultType,
                                  style: pw.TextStyle(
                                    fontSize: 32,
                                    fontWeight: pw.FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                                pw.SizedBox(height: 6),
                                pw.Text(
                                  'Confidence Level: ${item.confidence.toStringAsFixed(1)}%',
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    color: PdfColor.fromInt(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 16),
                          pw.Container(
                            width: 80,
                            height: 80,
                            decoration: pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                              border: pw.Border.all(color: statusColor, width: 3),
                            ),
                            child: pw.Center(
                              child: pw.Text(
                                '${item.confidence.toStringAsFixed(1)}%',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    pw.SizedBox(height: 24),

                    // Section: Image & Scores
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // MRI Image
                        pw.Expanded(
                          flex: 45,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _sectionHeader('NEUROIMAGE'),
                              pw.SizedBox(height: 10),
                              pw.Container(
                                width: double.infinity,
                                height: 220,
                                decoration: pw.BoxDecoration(
                                  color: PdfColor.fromInt(0xFF1E293B),
                                  borderRadius: pw.BorderRadius.circular(8),
                                ),
                                child: imageBytes != null
                                    ? pw.ClipRRect(
                                        horizontalRadius: 8,
                                        verticalRadius: 8,
                                        child: pw.Image(
                                          pw.MemoryImage(imageBytes),
                                          fit: pw.BoxFit.cover,
                                        ),
                                      )
                                    : pw.Center(
                                        child: pw.Text(
                                          'No Image',
                                          style: pw.TextStyle(
                                            color: PdfColor.fromInt(0xFF64748B),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 24),
                        // Score Bars
                        pw.Expanded(
                          flex: 55,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _sectionHeader('PROBABILITY DISTRIBUTION'),
                              pw.SizedBox(height: 10),
                              _medicalScoreBar('Glioma', item.gliomaScore, const PdfColor.fromInt(0xFF10B981)),
                              pw.SizedBox(height: 12),
                              _medicalScoreBar('Meningioma', item.meningiomaScore, const PdfColor.fromInt(0xFF2563EB)),
                              pw.SizedBox(height: 12),
                              _medicalScoreBar('Pituitary Tumor', item.pituitaryScore, const PdfColor.fromInt(0xFF8B5CF6)),
                              pw.SizedBox(height: 12),
                              _medicalScoreBar('No Tumor', item.noTumorScore, const PdfColor.fromInt(0xFF64748B)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 24),

                    // Clinical Notes
                    _sectionHeader('CLINICAL INTERPRETATION'),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFF8FAFC),
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: PdfColor.fromInt(0xFFE2E8F0)),
                      ),
                      child: pw.Text(
                        description,
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColor.fromInt(0xFF475569),
                          lineSpacing: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Footer
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.fromLTRB(40, 16, 40, 20),
                decoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFF1F5F9),
                ),
                child: pw.Column(
                  children: [
                    pw.Container(
                      width: double.infinity,
                      height: 1,
                      color: PdfColor.fromInt(0xFFE2E8F0),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'IMPORTANT NOTICE',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromInt(0xFFEF4444),
                                  letterSpacing: 1,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                'This AI-generated report is for screening purposes only. Results must be reviewed by a certified radiologist or neurologist. Not for clinical diagnosis without professional medical evaluation.',
                                style: pw.TextStyle(
                                  fontSize: 7.5,
                                  color: PdfColor.fromInt(0xFF64748B),
                                  lineSpacing: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 20),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Generated by',
                              style: pw.TextStyle(
                                fontSize: 7,
                                color: PdfColor.fromInt(0xFF94A3B8),
                              ),
                            ),
                            pw.Text(
                              'Neuroscan AI v1.0',
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromInt(0xFF0D9488),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return pdf.save();
  }

  static pw.Widget _sectionHeader(String title) {
    return pw.Row(
      children: [
        pw.Container(
          width: 3,
          height: 14,
          decoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF0D9488),
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(0xFF334155),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  static pw.Widget _detailItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 7,
            color: PdfColor.fromInt(0xFF94A3B8),
            letterSpacing: 1,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  static pw.Widget _divider() {
    return pw.Container(
      width: 1,
      height: 30,
      color: PdfColor.fromInt(0xFFE2E8F0),
    );
  }

  static pw.Widget _medicalScoreBar(String label, double score, PdfColor color) {
    final percentage = score.clamp(0.0, 100.0);
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 9,
                color: PdfColor.fromInt(0xFF475569),
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${percentage.toStringAsFixed(1)}%',
              style: pw.TextStyle(
                fontSize: 9,
                color: color,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Container(
          width: double.infinity,
          height: 12,
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFE2E8F0),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Container(
              width: (percentage / 100) * 500,
              height: 12,
              decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  colors: [color, color],
                ),
                borderRadius: pw.BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static PdfColor _getStatusColor(String type) {
    return switch (type) {
      'Glioma' => const PdfColor.fromInt(0xFF10B981),
      'Meningioma' => const PdfColor.fromInt(0xFF2563EB),
      'Pituitary Tumor' => const PdfColor.fromInt(0xFF8B5CF6),
      _ => const PdfColor.fromInt(0xFF1E293B),
    };
  }

  static String _getDescription(String type) {
    return switch (type) {
      'Glioma' => 'Glioma detected. A primary brain tumor originating from glial cells. These tumors can range from low-grade (benign) to high-grade (malignant) and may affect surrounding brain tissue. Histopathological confirmation and MRI follow-up with contrast enhancement are recommended for treatment planning.',
      'Meningioma' => 'Meningioma detected. A tumor arising from the arachnoid membrane surrounding the brain. Most meningiomas are WHO Grade I (benign) with slow growth patterns. Surgical resection is the primary treatment for symptomatic cases. Regular imaging surveillance is advised for asymptomatic presentations.',
      'Pituitary Tumor' => 'Pituitary adenoma detected. A benign neoplasm of the anterior pituitary gland. May be functional (hormone-secreting) or non-functional. Endocrine evaluation including hormone panel testing is essential. Treatment options include transsphenoidal surgery, medication, or observation based on tumor size and hormonal activity.',
      'No Tumor' => 'No intracranial mass lesion identified. The MRI scan demonstrates normal brain parenchyma without evidence of space-occupying lesions. The four-class classification model indicates normal tissue patterns across all evaluated parameters. Clinical correlation is recommended.',
      _ => 'Analysis complete. AI classification performed on brain MRI. Professional medical review required for definitive interpretation.',
    };
  }
}