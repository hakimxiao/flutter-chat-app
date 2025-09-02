import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

// plugin app level
//id("com.google.gms.google-services")

// add plugin project level 
// plugins {
//   // ...

//   // Add the dependency for the Google services Gradle plugin
//   id("com.google.gms.google-services") version "4.4.3" apply false

// }

