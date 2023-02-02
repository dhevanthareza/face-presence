import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';
import 'package:flutter_jett_boilerplate/data/const/app_text.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_button.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_text_field.dart';
import 'package:flutter_jett_boilerplate/presentation/pages/user/register/register_page.controller.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<RegisterPageController>(
        init: RegisterPageController(),
        builder: (state) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headContent(),
                  const SizedBox(height: 35),
                  _formContent(state),
                  const SizedBox(height: 60),
                  AppButton(
                    title: "Create Account",
                    onPressed: () {
                      state.register();
                    },
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Already have an account ? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                              text: " Login now",
                              style: TextStyle(color: AppColor.primaryColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => state.goToLogin())
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _headContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create a New Account",
          style: AppText.H1(color: AppColor.primaryColor),
        ),
        const SizedBox(height: 5),
        Text(
          "Create an account so you can doing your presence in app easily",
          style: TextStyle(color: AppColor.descriptionText),
        ),
      ],
    );
  }

  Widget _formContent(RegisterPageController state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          title: "Full Name",
          hintText: "Full Name",
          controller: state.fullnameTextController,
        ),
        const SizedBox(
          height: 15,
        ),
        AppTextField(
          title: "Email",
          hintText: "Email",
          controller: state.emailTextController,
        ),
        const SizedBox(
          height: 15,
        ),
        AppTextField(
          title: "Password",
          hintText: "Password",
          obscureText: true,
          controller: state.passwordTextController,
        ),
        const SizedBox(
          height: 15,
        ),
        AppTextField(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            state.pickPhoto();
          },
          title: state.photo != null
              ? "Tekan untuk ambil ulang foto"
              : "Ambil Foto",
          hintText: state.photo != null
              ? "Tekan untuk ambil U=ulang foto"
              : "Ambil Foto",
          controller: state.photoTextController,
          prefixIcon: const Icon(Icons.camera_alt_outlined),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Checkbox(
              value: state.isAgree,
              onChanged: (val) {
                state.toogleAgreement();
              },
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "I Agree to the ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "Terms of Service ",
                      style: TextStyle(color: AppColor.primaryColor),
                    ),
                    const TextSpan(
                      text: "and ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "Privacy Policy ",
                      style: TextStyle(color: AppColor.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
