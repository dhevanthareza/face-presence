import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double? width;
  final Function() onPressed;
  final EdgeInsets margin;
  final Color? backgroundColor;
  const AppButton({
    Key? key,
    required this.title,
    this.width,
    this.backgroundColor,
    this.margin = EdgeInsets.zero,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xff2A3FC5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10)
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
