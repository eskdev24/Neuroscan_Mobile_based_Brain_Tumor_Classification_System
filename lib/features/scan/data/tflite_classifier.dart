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
    instance._interpreter = await Interpreter.fromAsset('models/brain_tumor_model.tflite');
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
    final image = frame.image;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
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

  void close() {
    _interpreter?.close();
    _interpreter = null;
    _instance = null;
  }
}
