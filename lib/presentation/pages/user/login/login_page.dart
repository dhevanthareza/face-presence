import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';
import 'package:flutter_jett_boilerplate/data/const/app_text.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_button.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_text_field.dart';
import 'package:flutter_jett_boilerplate/presentation/pages/user/login/login_page.controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginPageController>(
      init: LoginPageController(),
      builder: (state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: Column(
                children: [
                  _headContent(),
                  const SizedBox(height: 40),
                  _formContent(state),
                  const SizedBox(height: 60),
                  AppButton(
                    title: "Login",
                    onPressed: () {
                      state.login();
                    },
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Dont have an account ? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                              text: " Register now",
                              style: TextStyle(color: AppColor.primaryColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => state.goToRegister())
                        ],
                      ),
                    ),
                  )
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
          "Welcome Back 👋",
          style: AppText.H1(color: AppColor.primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          "I am so happy to see you, you can continue to login for doing your presence",
          style: TextStyle(color: AppColor.descriptionText),
        ),
      ],
    );
  }

  Widget _formContent(state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          controller: state.passwordTextController,
          obscureText: true,
        ),
      ],
    );
  }
}
