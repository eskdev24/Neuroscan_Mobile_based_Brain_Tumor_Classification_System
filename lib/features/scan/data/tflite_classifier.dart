import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteClassifier {
  static TFLiteClassifier? _instance;
  Interpreter? _interpreter;
  TensorType? _inputType;
  TensorType? _outputType;
  List<int>? _inputShape;
  List<int>? _outputShape;

  TFLiteClassifier._();

  static Future<TFLiteClassifier> getInstance() async {
    if (_instance != null) return _instance!;
    final instance = TFLiteClassifier._();
    try {
      instance._interpreter = await Interpreter.fromAsset('assets/models/brain_tumor_model.tflite');
      instance._inputType = instance._interpreter!.getInputTensor(0).type;
      instance._outputType = instance._interpreter!.getOutputTensor(0).type;
      instance._inputShape = instance._interpreter!.getInputTensor(0).shape;
      instance._outputShape = instance._interpreter!.getOutputTensor(0).shape;
      print('[TFLiteClassifier] Model loaded successfully');
      print('[TFLiteClassifier] Input type: ${instance._inputType}, shape: ${instance._inputShape}');
      print('[TFLiteClassifier] Output type: ${instance._outputType}, shape: ${instance._outputShape}');
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

    print('[TFLiteClassifier] Classifying: inputH=$inputH, inputW=$inputW, channels=$channels');
    print('[TFLiteClassifier] Input imageBytes length: ${imageBytes.length}');
    print('[TFLiteClassifier] Input imageBytes first 20: ${imageBytes.take(20).toList()}');

    // Decode image using multiple approaches
    ui.Image? decodedImage;

    // Approach 1: Try ui.instantiateImageCodec
    try {
      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();
      decodedImage = frame.image;
      print('[TFLiteClassifier] Approach 1 - Decoded image: ${decodedImage.width}x${decodedImage.height}');
    } catch (e) {
      print('[TFLiteClassifier] Approach 1 failed: $e');
    }

    // Approach 2: If approach 1 failed, try with File
    if (decodedImage == null) {
      try {
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/temp_image.jpg');
        await tempFile.writeAsBytes(imageBytes);
        final fileBytes = await tempFile.readAsBytes();
        final codec = await ui.instantiateImageCodec(fileBytes);
        final frame = await codec.getNextFrame();
        decodedImage = frame.image;
        print('[TFLiteClassifier] Approach 2 - Decoded image: ${decodedImage.width}x${decodedImage.height}');
        await tempFile.delete();
      } catch (e) {
        print('[TFLiteClassifier] Approach 2 failed: $e');
      }
    }

    if (decodedImage == null) {
      print('[TFLiteClassifier] ERROR: Could not decode image');
      return {};
    }

    // Resize image to model input dimensions
    final resizedImage = await _resizeImage(decodedImage, inputW, inputH);
    print('[TFLiteClassifier] Resized image: ${resizedImage.width}x${resizedImage.height}');

    // Get raw pixel data
    final byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      print('[TFLiteClassifier] ERROR: Could not get byte data');
      return {};
    }
    final pixels = byteData.buffer.asUint8List();
    print('[TFLiteClassifier] Pixel buffer length: ${pixels.length}');
    print('[TFLiteClassifier] Pixel first 40 values: ${pixels.take(40).toList()}');

    // Check if image is all zeros
    final nonZeroCount = pixels.where((p) => p != 0).length;
    print('[TFLiteClassifier] Non-zero pixels: $nonZeroCount out of ${pixels.length}');

    // Prepare input as nested List matching tensor shape
    final isFloatInput = _inputType == TensorType.float32;
    final inputBuffer = isFloatInput
        ? _prepareFloatInput(pixels, inputH, inputW, channels)
        : _prepareUint8Input(pixels, inputH, inputW, channels);

    // Prepare output
    final outputTensor = interp.getOutputTensor(0);
    final outputShape = outputTensor.shape;
    final numClasses = outputShape.last;
    final isFloatOutput = _outputType == TensorType.float32;

    final outputBuffer = isFloatOutput
        ? List.filled(1 * numClasses, 0.0).reshape([1, numClasses])
        : List.filled(1 * numClasses, 0).reshape([1, numClasses]);

    print('[TFLiteClassifier] Running inference with input: ${isFloatInput ? "float32" : "uint8"}');
    print('[TFLiteClassifier] Running inference with output: ${isFloatOutput ? "float32" : "uint8"}');

    // Run inference
    interp.run(inputBuffer, outputBuffer);

    // Extract results
    final result = <String, double>{};
    const labels = ['Glioma', 'Meningioma', 'No Tumor', 'Pituitary Tumor'];

    if (isFloatOutput) {
      final outputList = outputBuffer[0] as List<double>;
      print('[TFLiteClassifier] Raw float output: $outputList');
      for (var i = 0; i < numClasses && i < labels.length; i++) {
        result[labels[i]] = outputList[i] * 100;
      }
    } else {
      final outputList = outputBuffer[0] as List<int>;
      print('[TFLiteClassifier] Raw uint8 output: $outputList');
      for (var i = 0; i < numClasses && i < labels.length; i++) {
        result[labels[i]] = (outputList[i] & 0xFF) / 255.0 * 100;
      }
    }

    print('[TFLiteClassifier] Final result: $result');
    return result;
  }

  List<List<List<List<double>>>> _prepareFloatInput(
      Uint8List pixels, int height, int width, int channels) {
    final input = List.generate(
      1,
      (_) => List.generate(
        height,
        (y) => List.generate(
          width,
          (x) {
            final pixelIdx = (y * width + x) * 4;
            if (channels == 3) {
              return [
                pixels[pixelIdx] / 255.0,
                pixels[pixelIdx + 1] / 255.0,
                pixels[pixelIdx + 2] / 255.0,
              ];
            } else {
              return [(pixels[pixelIdx] + pixels[pixelIdx + 1] + pixels[pixelIdx + 2]) / (3 * 255.0)];
            }
          },
        ),
      ),
    );
    return input;
  }

  List<List<List<List<int>>>> _prepareUint8Input(
      Uint8List pixels, int height, int width, int channels) {
    final input = List.generate(
      1,
      (_) => List.generate(
        height,
        (y) => List.generate(
          width,
          (x) {
            final pixelIdx = (y * width + x) * 4;
            if (channels == 3) {
              return [
                pixels[pixelIdx],
                pixels[pixelIdx + 1],
                pixels[pixelIdx + 2],
              ];
            } else {
              return [(pixels[pixelIdx] + pixels[pixelIdx + 1] + pixels[pixelIdx + 2]) ~/ 3];
            }
          },
        ),
      ),
    );
    return input;
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