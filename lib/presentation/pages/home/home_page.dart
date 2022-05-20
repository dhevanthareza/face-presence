import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';
import 'package:flutter_jett_boilerplate/data/const/app_text.dart';
import 'package:flutter_jett_boilerplate/domain/entities/presence/presence.entity.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_button.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_shimmer.dart';
import 'package:flutter_jett_boilerplate/presentation/pages/home/home_page.controller.dart';
import 'package:flutter_jett_boilerplate/utils/date_utils.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomePageController(),
      builder: (HomePageController state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headContent(state),
                  const SizedBox(height: 40),
                  _presenceCard(state),
                  const SizedBox(height: 40),
                  _currentPresence(state),
                  const SizedBox(height: 40),
                  Text(
                    "Presence History",
                    style: AppText.H2(color: AppColor.darkColor),
                  ),
                  const SizedBox(height: 20),
                  _presenceHistoryList(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headContent(HomePageController state) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning",
                style: AppText.H1(color: AppColor.primaryColor),
              ),
              Text(
                state.username,
                style: AppText.H1(color: AppColor.darkColor),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 25,
        ),
        IconButton(
          onPressed: () {
            state.logout();
          },
          icon: Icon(
            Icons.exit_to_app_rounded,
            color: AppColor.failedColor,
            size: 30,
          ),
        )
      ],
    );
  }

  Widget _presenceCard(HomePageController state) {
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
                  state.currentTime,
                  style: AppText.H5(color: AppColor.primaryColor),
                ),
                Text(
                  AppDateUtils.formatFromString(DateTime.now().toString(),
                      format: "EEEE, dd MMM yyyy"),
                  style: AppText.H5(color: AppColor.darkColor),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          AppButton(
              title: "Check In",
              onPressed: () {
                state.checkIn();
              }),
          const SizedBox(
            width: 5,
          ),
          AppButton(
            title: "Check Out",
            onPressed: () {
              state.checkOut();
            },
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

  Widget _currentPresence(HomePageController state) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                "${state.checkInTime}",
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
                "${state.checkOutTime}",
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
              Text("00:00", style: AppText.H5(color: AppColor.darkColor)),
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

  Widget _presenceHistoryCard(PresenceEntity presence) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppDateUtils.formatFromString(presence.date, format: "EEEE, dd MMM yyyy", addHours: 7)}",
                style: AppText.H5(color: AppColor.darkColor),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppDateUtils.formatFromString(
                  presence.checkInDatetime,
                  format: "HH:mm",
                  addHours: 7,
                ),
                style: AppText.H5(color: AppColor.primaryColor),
              ),
              Text(
                AppDateUtils.formatFromString(
                  presence.checkOutDatetime,
                  format: "HH:mm",
                  addHours: 7,
                ),
                style: AppText.H5(color: Colors.red),
              ),
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

  Widget _presenceHistoryList(HomePageController state) {
    return state.presenceHistoryLoading
        ? ListShimmer()
        : Column(
            children: state.presenceHistories
                .map(
                  (PresenceEntity history) => _presenceHistoryCard(history),
                )
                .toList(),
          );
    // return Shimmer(
    //   linearGradient: _shimmerGradient,
    //   child: Column(
    //     children: [
    //       _presenceHistoryCard(),
    //       _presenceHistoryCard(),
    //       _presenceHistoryCard(),
    //     ],
    //   ),
    // );
  }
}
