import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chatapp/app/utils/error_screen.dart';
import 'package:chatapp/app/utils/loading_screen.dart';
import 'package:chatapp/app/utils/splash_screen.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            title: "ChatApp",
            initialRoute: Routes.UPDATE_STATUS,
            getPages: AppPages.routes,
          );
          // return FutureBuilder(
          //   future: Future.delayed(Duration(seconds: 4)),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return Obx(
          //         () => GetMaterialApp(
          //           title: "ChatApp",
          //           initialRoute: authC.isSkip.isTrue
          //               ? authC.isAuth.isTrue
          //                     ? Routes.HOME
          //                     : Routes.LOGIN
          //               : Routes.INTRODUCTION,
          //           getPages: AppPages.routes,
          //         ),
          //       );
          //     }
          //     return SplashScreen();
          //   },
          // );
        }

        return LoadingScreen();
      },
    );
  }
}
