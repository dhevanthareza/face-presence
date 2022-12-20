import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  FacePainter({required this.imageSize, required this.face});
  final Size imageSize;
  Face face;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint;
    if (face.headEulerAngleY! > 10 ||
        face.headEulerAngleY! < -10 ||
        face.headEulerAngleX! > 10 ||
        face.headEulerAngleX! < -10) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.red;
    } else {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.green;
    }
    double scaleX = size.width / imageSize.width;
    double scaleY = size.height / imageSize.height;
    canvas.drawRRect(
        _scaleRect(
          rect: face.boundingBox,
          imageSize: imageSize,
          widgetSize: size,
          scaleX: scaleX,
          scaleY: scaleY,
        ),
        paint);
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.face != face;
  }
}

RRect _scaleRect(
    {required Rect rect,
    required Size imageSize,
    required Size widgetSize,
    required double scaleX,
    required double scaleY}) {
  return Platform.isIOS
      ? RRect.fromLTRBR(
          rect.left.toDouble() * scaleX,
          rect.top.toDouble() * scaleY,
          rect.right.toDouble() * scaleX,
          rect.bottom.toDouble() * scaleY,
          Radius.circular(10),
        )
      : RRect.fromLTRBR(
          widgetSize.width - rect.left.toDouble() * scaleX,
          rect.top.toDouble() * scaleY,
          widgetSize.width - rect.right.toDouble() * scaleX,
          rect.bottom.toDouble() * scaleY,
          Radius.circular(10),
        );
}
