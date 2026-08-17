import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context),
          _buildInfoCard(
            context: context,
            icon: Icons.info,
            title: 'About the App',
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Neuroscan AI is an advanced mobile application that utilizes deep learning and TensorFlow Lite to analyze brain MRI images for tumor detection. The app is designed to assist healthcare professionals and patients in the early screening of brain tumors.',
                  style: TextStyle(height: 1.6),
                ),
                SizedBox(height: 12),
                Text(
                  'Using state-of-the-art convolutional neural networks trained on extensive medical datasets, Neuroscan AI can classify brain MRI scans into four categories: Glioma, Meningioma, Pituitary, and No Tumor.',
                  style: TextStyle(height: 1.6),
                ),
              ],
            ),
          ),
          _buildInfoCard(
            context: context,
            icon: Icons.star,
            title: 'Key Features',
            child: const Text(
              '• Instant AI-powered MRI analysis\n'
              '• Support for 4 tumor type classifications\n'
              '• On-device processing (no internet required)\n'
              '• Prediction history with images\n'
              '• User-friendly interface\n'
              '• Fast inference time\n'
              '• Privacy-focused (images stay on device)',
              style: TextStyle(height: 1.6),
            ),
          ),
          _buildInfoCard(
            context: context,
            icon: Icons.settings,
            title: 'How It Works',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1. Capture or select a brain MRI image\n'
                  '2. The AI model processes the image locally\n'
                  '3. Get instant classification results\n'
                  '4. View detailed predictions and confidence scores\n'
                  '5. Save results to history for future reference',
                  style: TextStyle(height: 1.6),
                ),
                const SizedBox(height: 12),
                Text(
                  'The entire analysis happens on your device, ensuring fast response times and complete privacy.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          _buildInfoCard(
            context: context,
            icon: Icons.local_hospital,
            title: 'Tumor Types Detected',
            child: Column(
              children: [
                _buildTumorTypeRow(
                  color: const Color(0xFF4EDEA3),
                  name: 'Glioma',
                  colorName: 'Mint Green',
                  definition:
                      'Tumors originating in glial cells, which are the supportive cells wrapping around and protecting neurons in the brain or spine.',
                ),
                const SizedBox(height: 8),
                _buildTumorTypeRow(
                  color: const Color(0xFF2563EB),
                  name: 'Meningioma',
                  colorName: 'Cobalt Blue',
                  definition:
                      'Slow-growing tumors originating in the meninges, which are the protective membranes shielding the brain and spinal cord.',
                ),
                const SizedBox(height: 8),
                _buildTumorTypeRow(
                  color: const Color(0xFF7D4CE7),
                  name: 'Pituitary Tumor',
                  colorName: 'Amethyst Purple',
                  definition:
                      'Tumors growing in the pituitary gland, a pea-sized gland located at the base of the brain that regulates essential hormone balances.',
                ),
                const SizedBox(height: 8),
                _buildTumorTypeRow(
                  color: const Color(0xFF8D90A0),
                  name: 'No Tumor',
                  colorName: 'Slate Gray',
                  definition:
                      'A healthy, normal brain diagnostic scan displaying no structural abnormalities, cell masses, or lesions.',
                ),
                const SizedBox(height: 16),
                Text(
                  'Each on-device classification includes a confidence probability index and a detailed medical review description of the diagnosed category.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          _buildDisclaimerCard(context),
          const SizedBox(height: 24),
          Column(
            children: [
              Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                'Built with Flutter & TensorFlow Lite',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1565C0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child:               const Icon(
                Icons.psychology,
                size: 40,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Neuroscan AI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'AI-Powered Brain Tumor Classifier',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: const Color(0xFF1565C0)),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          border: Border.all(color: const Color(0xFFFBC02D)),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, size: 24, color: Color(0xFFF57F17)),
                SizedBox(width: 12),
                Text(
                  'Medical Disclaimer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'This application is intended for educational and screening purposes only. The AI predictions should NOT be used as a substitute for professional medical advice, diagnosis, or treatment. Always consult with a qualified healthcare provider for any medical concerns. Early detection and professional medical evaluation are crucial for proper treatment.',
              style: TextStyle(
                color: Color(0xFF5D4037),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTumorTypeRow({
    required Color color,
    required String name,
    required String colorName,
    required String definition,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      colorName,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                definition,
                style: const TextStyle(fontSize: 14, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
