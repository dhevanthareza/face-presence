import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_text.dart';
import 'package:flutter_jett_boilerplate/domain/service/face/face.service.dart';
import 'package:flutter_jett_boilerplate/domain/service/image/image.service.dart';
import 'package:flutter_jett_boilerplate/domain/service/mlkit/mlkit.service.dart';
import 'package:flutter_jett_boilerplate/presentation/components/face_painter.dart';
import 'package:flutter_jett_boilerplate/presentation/pages/home/widget/photo_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:load/load.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;

class FaceExtractor extends StatefulWidget {
  const FaceExtractor({Key? key}) : super(key: key);

  @override
  State<FaceExtractor> createState() => _FaceExtractorState();
}

class _FaceExtractorState extends State<FaceExtractor>
    with SingleTickerProviderStateMixin {
  String HOLD_POSITION_MESSAGE = "Pertahankan posisi wajah";
  late CameraController cameraController;
  bool _detectingFaces = false;
  Face? faceDetected;
  CameraImage? cameraImage;
  File? cameraFile;
  File? croppedFile;
  List<dynamic> photoFeature = [];
  bool isCameraInitialized = false;
  bool isFaceExtractionLoading = false;

  Duration facePickDelay = Duration(seconds: 3);
  bool isCanPickFace = false;

  @override
  void initState() {
    super.initState();
    startFacePickDelayTimer();
    initializeCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  startFacePickDelayTimer() {
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final seconds = facePickDelay.inSeconds - 1;
      if (seconds < 0) {
        timer.cancel();
        isCanPickFace = true;
      } else {
        facePickDelay = Duration(seconds: seconds);
      }
    });
  }

  initializeCamera() async {
    showLoadingDialog();
    List<CameraDescription> cameras = await availableCameras();
    CameraDescription description = cameras.firstWhere(
        (CameraDescription camera) =>
            camera.lensDirection == CameraLensDirection.front);
    cameraController = CameraController(description, ResolutionPreset.high,
        enableAudio: false);
    await cameraController.initialize();
    setState(() {
      isCameraInitialized = true;
    });
    hideLoadingDialog();
    initiateFaceDetection(description);
  }

  initiateFaceDetection(CameraDescription cameraDescription) async {
    cameraController.startImageStream((CameraImage image) async {
      if (_detectingFaces) return;

      _detectingFaces = true;
      List<Face> faces = await MlKitService.detectFacesFromImage(
          image, cameraDescription.sensorOrientation);
      if (faces.isEmpty) {
        _detectingFaces = false;
        return;
      }
      setState(() {
        faceDetected = faces[0];
      });
      if (_faceMessage() != HOLD_POSITION_MESSAGE) {
        _detectingFaces = false;
        return;
      }
      cameraImage = image;
      if (!isCanPickFace) {
        _detectingFaces = false;
        return;
      }
      handleResultFile();
    });
  }

  _faceMessage() {
    if (faceDetected == null) {
      return null;
    }
    if (faceDetected!.headEulerAngleY! > 10) {
      return "Wajah terlalu menghadap kiri luruskan wajah";
    }
    if (faceDetected!.headEulerAngleY! < -10) {
      return "Wajah terlalu menghadap kanan luruskan wajah";
    }
    if (faceDetected!.headEulerAngleX! > 10) {
      return "Wajah terlalu menghadap atas luruskan wajah";
    }
    if (faceDetected!.headEulerAngleX! < -10) {
      return "Wajah terlalu menghadap bawah luruskan wajah";
    }
    if (faceDetected!.headEulerAngleZ! > 10) {
      return "Wajah terlalu miring ke kanan luruskan wajah";
    }
    if (faceDetected!.headEulerAngleZ! < -5) {
      return "Wajah terlalu miring ke kiri luruskan wajah";
    }
    return HOLD_POSITION_MESSAGE;
  }

  handleResultFile() async {
    try {
      setState(() {
        isFaceExtractionLoading = true;
      });
      if (cameraController.value.isTakingPicture) {
        return null;
      }
      await cameraController.stopImageStream();
      XFile file = await cameraController.takePicture();
      cameraFile = File(file.path);

      // Building Cropped File
      imglib.Image cropImage =
          ImageService.cropFace(cameraImage!, faceDetected!);
      Directory directory = await getTemporaryDirectory();
      File cropFile = await File('${directory.path}/${getRandomString(10)}.png')
          .writeAsBytes(imglib.encodePng(cropImage));
      croppedFile = cropFile;

      // Building Feaature
      List<dynamic> _photoFeature =
          await FaceService.createFeature(cameraImage!, faceDetected!);
      photoFeature = _photoFeature;

      PhotoPickResult extractionResult = PhotoPickResult(
        cameraFile: cameraFile!,
        croppedFile: croppedFile!,
        photoFeature: photoFeature,
      );
      Get.back(result: extractionResult);
    } catch (err) {
      print(err);
      setState(() {
        isFaceExtractionLoading = true;
      });
    }
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _cameraPreview(),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: _buildFaceDescriptionContainer(),
          )
        ],
      ),
    );
  }

  Widget _cameraPreview() {
    final width = MediaQuery.of(context).size.width;

    return !isCameraInitialized
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Transform.scale(
            scale: 1.0,
            child: AspectRatio(
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              child: OverflowBox(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Container(
                    width: width,
                    height: width * cameraController.value.aspectRatio,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CameraPreview(cameraController),
                        faceDetected == null || isFaceExtractionLoading
                            ? SizedBox()
                            : CustomPaint(
                                painter: FacePainter(
                                  face: faceDetected!,
                                  imageSize: Size(
                                    cameraController.value.previewSize!.height,
                                    cameraController.value.previewSize!.width,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildFaceDescriptionContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          isFaceExtractionLoading
              ? CircularProgressIndicator()
              : Image.asset(
                  "assets/face.png",
                  height: 60,
                  width: 60,
                ),
          const SizedBox(
            height: 20,
          ),
          Text(
            _faceMessage() ?? "Sedang mengambil gambar wajah",
            style: AppText.H4(),
          )
        ],
      ),
    );
  }
}
