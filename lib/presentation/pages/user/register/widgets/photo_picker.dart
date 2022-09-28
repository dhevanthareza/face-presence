import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/domain/service/report_service/report_service.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:load/load.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../domain/service/face/face_detector.service.dart';
import '../../../../components/app_button.dart';
import '../../../../components/face_painter.dart';
import '../register_page.controller.dart';

class PhotoPicker extends StatefulWidget {
  const PhotoPicker({Key? key}) : super(key: key);

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  late CameraController cameraController;
  bool _detectingFaces = false;
  Face? faceDetected;
  CameraImage? cameraImage;
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
    try {
      List<CameraDescription> cameras = await availableCameras();
      CameraDescription description = cameras.firstWhere(
        (CameraDescription camera) =>
            camera.lensDirection == CameraLensDirection.front,
      );
      cameraController = CameraController(
        description,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await cameraController.initialize().catchError((Object e) async {
        if (e is CameraException) {
          return ReportService.reportCameraException(e);
        } else {
          return ReportService.reportException(e.toString());
        }
      });
      setState(() {
        isCameraInitialized = true;
      });
      await initiateFaceDetection(description);
      hideLoadingDialog();
    } catch (err) {
      ReportService.reportException(err.toString());
    }
  }

  initiateFaceDetection(CameraDescription cameraDescription) async {
    cameraController.startImageStream((CameraImage image) async {
      if (_detectingFaces) return;

      _detectingFaces = true;
      List<Face> faces = await FaceDetectorService.detectFacesFromImage(
        image,
        cameraDescription.sensorOrientation,
      );
      if (faces.isNotEmpty) {
        setState(() {
          faceDetected = faces[0];
          cameraImage = image;
        });
        RegisterPageController.to.setFaceAndImage(faceDetected!, cameraImage!);
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
    showLoadingDialog(tapDismiss: true);
    try {
      if (cameraController.value.isTakingPicture) {
        return null;
      }
      cameraController.stopImageStream();
      XFile file = await cameraController.takePicture();
      RegisterPageController.to.setCameraFile(file);
      await RegisterPageController.to
          .setCroppedFile(cameraImage!, faceDetected!);
      hideLoadingDialog();
      Navigator.pop(context);
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
}
