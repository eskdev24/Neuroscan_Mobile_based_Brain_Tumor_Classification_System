import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteClassifier {
  static TFLiteClassifier? _instance;
  Interpreter? _interpreter;

  TFLiteClassifier._();

  static Future<TFLiteClassifier> getInstance() async {
    if (_instance != null) return _instance!;
    final instance = TFLiteClassifier._();
    try {
      instance._interpreter = await Interpreter.fromAsset('assets/models/brain_tumor_model.tflite');
    } catch (e) {
      print('[TFLiteClassifier] Error loading model: $e');
      rethrow;
    }
    _instance = instance;
    return instance;
  }

  Future<Map<String, double>> classify(Uint8List imageBytes) async {
    final interp = _interpreter!;
    final inputTensor = interp.getInputTensor(0);
    final inputShape = inputTensor.shape;
    final inputH = inputShape[1];
    final inputW = inputShape[2];
    final channels = inputShape.length == 4 ? inputShape[3] : 1;

    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final originalImage = frame.image;

    // Resize image to model input dimensions
    final resizedImage = await _resizeImage(originalImage, inputW, inputH);
    final byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    final pixels = byteData!.buffer.asUint8List();

    final inputBuffer = Float32List(inputH * inputW * channels);
    var idx = 0;
    for (var y = 0; y < inputH; y++) {
      for (var x = 0; x < inputW; x++) {
        final pixelIdx = (y * inputW + x) * 4;
        final r = pixels[pixelIdx] / 255.0;
        final g = pixels[pixelIdx + 1] / 255.0;
        final b = pixels[pixelIdx + 2] / 255.0;
        if (channels == 3) {
          inputBuffer[idx++] = r;
          inputBuffer[idx++] = g;
          inputBuffer[idx++] = b;
        } else {
          inputBuffer[idx++] = (r + g + b) / 3;
        }
      }
    }

    final outputTensor = interp.getOutputTensor(0);
    final outputShape = outputTensor.shape;
    final numClasses = outputShape.last;
    final outputBuffer = Float32List(numClasses);
    interp.run(inputBuffer.reshape([1, inputH, inputW, channels]), outputBuffer.reshape([1, numClasses]));

    final result = <String, double>{};
    const labels = ['Glioma', 'Meningioma', 'No Tumor', 'Pituitary Tumor'];
    for (var i = 0; i < numClasses && i < labels.length; i++) {
      result[labels[i]] = outputBuffer[i] * 100;
    }
    return result;
  }

  Future<ui.Image> _resizeImage(ui.Image image, int targetWidth, int targetHeight) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()..filterQuality = ui.FilterQuality.high;
    canvas.drawImageRect(
      image,
      ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      ui.Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
      paint,
    );
    final picture = recorder.endRecording();
    return picture.toImage(targetWidth, targetHeight);
  }

  void close() {
    _interpreter?.close();
    _interpreter = null;
    _instance = null;
  }
}
