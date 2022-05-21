import 'package:flutter/material.dart';
import 'package:flutter_jett_boilerplate/config.dart';
import 'package:flutter_jett_boilerplate/data/const/app_color.dart';
import 'package:flutter_jett_boilerplate/presentation/components/app_loading.dart';
import 'package:flutter_jett_boilerplate/routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/provider/singleton/falvor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
    flavor: AppConfig.flavor,
    color: Colors.deepPurple,
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  requestPermission() async {
    await requestCameraPermission();
    await requestStoragePermission();
  }

  requestCameraPermission() async {
    if (await Permission.camera.request().isDenied) {
      requestCameraPermission();
    }
  }

  requestStoragePermission() async {
    if (await Permission.storage.request().isDenied) {
      requestStoragePermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: AppColor.primaryColor,
      ),
      builder: (BuildContext context, dynamic child) {
        return LoadingProvider(
          child: child,
          themeData: LoadingThemeData(),
          loadingWidgetBuilder: (ctx, data) => Center(child: AppLoading()),
        );
      },
      title: 'Jett Boilerplate',
      initialRoute: '/',
      getPages: Routes.routes,
    );
  }
}
