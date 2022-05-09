import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';

class AppTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Icon? prefixIcon;
  final void Function()? onTap;
  const AppTextField(
      {Key? key,
      required this.title,
      required this.hintText,
      required this.controller,
      this.prefixIcon,
      this.onTap,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: 20,
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      style: const TextStyle(fontSize: 15),
      onTap: onTap,
      decoration: InputDecoration(
        // label: Text(title),
        // labelStyle: TextStyle(color: AppColor.primaryColor),
        filled: true,
        isDense: true,
        prefixIcon: prefixIcon,
        fillColor: const Color(0xFFF4F6F8),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Color(0xFFA4ACAF),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFF4F6F8),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFF4F6F8),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFF4F6F8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
      ),
    );
  }
}
