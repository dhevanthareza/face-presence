import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/domain/entities/face/photoe_extraction_result.dart';
import 'package:flutter_jett_boilerplate/domain/service/camera/camera_service.dart';
import 'package:flutter_jett_boilerplate/domain/service/image/image.service.dart';
import 'package:flutter_jett_boilerplate/domain/service/mlkit/mlkit.service.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceService {
  static Future<PhotoExtractionResult> createFeature(
      CameraImage cameraImage, Face face) async {
    Delegate? delegate;
    if (Platform.isAndroid) {
      delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
        isPrecisionLossAllowed: false,
        inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
        inferencePriority1: TfLiteGpuInferencePriority.minLatency,
        inferencePriority2: TfLiteGpuInferencePriority.auto,
        inferencePriority3: TfLiteGpuInferencePriority.auto,
      ));
    } else if (Platform.isIOS) {
      delegate = GpuDelegate(
        options: GpuDelegateOptions(
            allowPrecisionLoss: true, waitType: TFLGpuDelegateWaitType.active),
      );
    }
    var interpreterOptions = InterpreterOptions()..addDelegate(delegate!);
    Interpreter interpreter = await Interpreter.fromAsset(
        'mobile_face_net_sirius.tflite',
        options: interpreterOptions);
    List input = _preProcess(cameraImage, face);
    input = input.reshape([1, 112, 112, 3]);
    print("INPUT = ${input}");
    List output = List.generate(1, (index) => List.filled(192, 0));
    Stopwatch stopwatch = Stopwatch()..start();
    interpreter.run(input, output);
    Duration creatingFeatureDuration = stopwatch.elapsed;
    stopwatch.stop();
    print("MODEL RUN ON ${creatingFeatureDuration.inMilliseconds}ms");
    print("===========output length=========");
    print(output.length);
    print(output[0].length);
    output = output.reshape([192]);
    List features = List.from(output);
    return PhotoExtractionResult(
      photoFeature: features,
      modelRunTimeMs: creatingFeatureDuration.inMilliseconds,
    );
  }

  static List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = ImageService.cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = ImageService.imageToByteListFloat32(img);
    return imageAsList;
  }

  static double euclideanDistance(List? e1, List? e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }
}
