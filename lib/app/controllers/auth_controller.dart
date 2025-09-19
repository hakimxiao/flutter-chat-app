import 'package:chatapp/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isSkip = false.obs;
  var isAuth = false.obs;

  void login() {
    Get.offAllNamed(Routes.HOME);
  }

  void logout() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
