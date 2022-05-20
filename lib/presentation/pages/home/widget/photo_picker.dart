import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:load/load.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';
import '../../../../domain/service/face/face_detector.service.dart';
import '../../../components/app_button.dart';
import '../../../components/face_painter.dart';

class PresencePhotoPickerPage extends StatefulWidget {
  const PresencePhotoPickerPage({Key? key}) : super(key: key);

  @override
  State<PresencePhotoPickerPage> createState() =>
      _PresencePhotoPickerPageState();
}

class _PresencePhotoPickerPageState extends State<PresencePhotoPickerPage> {
  late CameraController cameraController;
  bool _detectingFaces = false;
  Face? faceDetected;
  CameraImage? cameraImage;
  File? cameraFile;
  File? croppedFile;
  List<dynamic> photoFeature = [];
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
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
    await initiateFaceDetection(description);
    hideLoadingDialog();
  }

  initiateFaceDetection(CameraDescription cameraDescription) async {
    cameraController.startImageStream((CameraImage image) async {
      if (_detectingFaces) return;

      _detectingFaces = true;
      List<Face> faces = await FaceDetectorService.detectFacesFromImage(
          image, cameraDescription.sensorOrientation);
      if (faces.isNotEmpty) {
        setState(() {
          faceDetected = faces[0];
          cameraImage = image;
        });
        _detectingFaces = false;
      } else {
        setState(() {
          faceDetected = null;
        });
        _detectingFaces = false;
      }
    });
  }

  handlePickPhotoClick() async {
    showLoadingDialog();
    try {
      if (cameraController.value.isTakingPicture) {
        return null;
      }
      cameraController.stopImageStream();
      XFile file = await cameraController.takePicture();
      cameraFile = File(file.path);

      // Building Cropped File
      imglib.Image cropImage =
          FaceDetectorService.cropFace(cameraImage!, faceDetected!);
      Directory directory = await getTemporaryDirectory();
      File cropFile = await File('${directory.path}/${getRandomString(10)}.png')
          .writeAsBytes(imglib.encodePng(cropImage));
      croppedFile = cropFile;

      // Building Feaature
      List<dynamic> _photoFeature =
          await FaceDetectorService.createFeature(cameraImage!, faceDetected!);
      photoFeature = _photoFeature;

      hideLoadingDialog();
      Get.back(
        result: PhotoPickResult(
          cameraFile: cameraFile!,
          croppedFile: croppedFile!,
          photoFeature: photoFeature,
        ),
      );
    } catch (err) {
      hideLoadingDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _cameraPreview(),
        SizedBox(
          width: double.infinity,
          child: _header(),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          left: 10,
          child: AppButton(
            title: "Ambil Foto",
            onPressed: () {
              handlePickPhotoClick();
            },
          ),
        )
      ],
    ));
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Ambil Foto",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            textAlign: TextAlign.center,
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
                        faceDetected == null
                            ? SizedBox()
                            : CustomPaint(
                                painter: FacePainter(
                                  face: faceDetected!,
                                  imageSize: Size(
                                      cameraController
                                          .value.previewSize!.height,
                                      cameraController
                                          .value.previewSize!.width),
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

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}

class PhotoPickResult {
  File cameraFile;
  File croppedFile;
  List<dynamic> photoFeature = [];

  PhotoPickResult({
    required this.cameraFile,
    required this.croppedFile,
    required this.photoFeature,
  });
}
