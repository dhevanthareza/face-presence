import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';
import 'package:flutter_jett_boilerplate/data/const/app_text.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_button.dart';
import 'package:flutter_jett_boilerplate/presentation/pages/home/home_page.controller.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomePageController(),
      builder: (state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headContent(),
                  const SizedBox(height: 40),
                  _presenceCard(),
                  const SizedBox(height: 40),
                  _currentPresence(),
                  const SizedBox(height: 40),
                  Text(
                    "Presence History",
                    style: AppText.H2(color: AppColor.darkColor),
                  ),
                  const SizedBox(height: 20),
                  _presenceHistoryCard(),
                  _presenceHistoryCard(),
                  _presenceHistoryCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Good Morning",
          style: AppText.H1(color: AppColor.primaryColor),
        ),
        Text(
          "Dhevan",
          style: AppText.H1(color: AppColor.darkColor),
        ),
      ],
    );
  }

  Widget _presenceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "09:12",
                  style: AppText.H5(color: AppColor.primaryColor),
                ),
                Text(
                  "Wednesday, Dec 22",
                  style: AppText.H5(color: AppColor.darkColor),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          AppButton(title: "Check In", onPressed: () {}),
          const SizedBox(
            width: 5,
          ),
          AppButton(
            title: "Check Out",
            onPressed: () {},
            backgroundColor: Colors.red,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 4),
              color: AppColor.primaryColor25, //edited
              spreadRadius: 1,
              blurRadius: 20 //edited
              )
        ],
      ),
    );
  }

  Widget _currentPresence() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                "09:10",
                style: AppText.H5(color: AppColor.darkColor),
              ),
              Text(
                "Check In",
                style: AppText.H5(color: AppColor.primaryColor),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                "16:10",
                style: AppText.H5(color: AppColor.darkColor),
              ),
              Text(
                "Check Out",
                style: AppText.H5(color: Colors.red),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text("24:30", style: AppText.H5(color: AppColor.darkColor)),
              Text(
                "Weekly Hours",
                style: AppText.H5(color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _presenceHistoryCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Wednesday, Dec 22", style: AppText.H5(color: AppColor.darkColor),),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "09:12",
                style: AppText.H5(color: AppColor.primaryColor),
              ),
              Text("16:10", style: AppText.H5(color: Colors.red),),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 4),
              color: AppColor.primaryColor25, //edited
              spreadRadius: 1,
              blurRadius: 8 //edited
              )
        ],
      ),
    );
  }
}
