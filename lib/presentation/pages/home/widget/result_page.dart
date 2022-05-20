import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';
import 'package:flutter_jett_boilerplate/data/const/app_text.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_button.dart';
import 'package:flutter_jett_boilerplate/presentation/pages/home/home_page.controller.dart';
import 'package:get/get.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      builder: (HomePageController state) {
        return Scaffold(
          body: Center(
            child: state.submitLoading
                ? CircularProgressIndicator()
                : submitResult(state),
          ),
        );
      },
    );
  }

  Widget submitResult(HomePageController state) {
    return state.isSubmitSuccess
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColor.successColor,
                size: 60,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Verifikasi Presensi Berhasil",
                style: AppText.H2(
                  color: AppColor.darkColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                  title: "Kembali",
                  onPressed: () {
                    Get.back();
                  })
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColor.failedColor,
                size: 60,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Verifikasi Presensi Gagal",
                style: AppText.H2(
                  color: AppColor.darkColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                  title: "Kembali",
                  onPressed: () {
                    Get.back();
                  })
            ],
          );
  }
}
