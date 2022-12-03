import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_button.dart';
import 'package:get/get.dart';

class FaceConfirmation extends StatelessWidget {
  final File cameraFile;
  const FaceConfirmation({Key? key, required this.cameraFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: Image.file(
                cameraFile,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            _buildActionButton()
          ],
        ),
      ),
    );
  }

  _buildActionButton() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            title: "Ulangi",
            backgroundColor: AppColor.failedColor,
            onPressed: () {
              Get.back(result: false);
            },
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: AppButton(
            title: "Simpan",
            backgroundColor: AppColor.successColor,
            onPressed: () {
              Get.back(result: true);
            },
          ),
        ),
      ],
    );
  }
}
