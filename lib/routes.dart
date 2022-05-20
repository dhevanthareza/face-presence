
import 'package:get/get.dart';

import 'presentation/pages/splash/splash_page.dart';
import 'presentation/pages/user/login/login_page.dart';

class Routes {
  static List<GetPage> routes = [
    GetPage(
      name: '/',
      page: () => SplashPage(),
    ),
    GetPage(
      name: '/user/login',
      page: () => LoginPage(),
    ),
    // GetPage(
    //   name: '/user/register',
    //   page: () => RegisterPage(),
    // ),
    // GetPage(
    //   name: '/home',
    //   page: () => HomePage(),
    // ),
    // GetPage(
    //   name: '/user/auth',
    //   page: () => AuthPage(),
    // ),
  ];
}
