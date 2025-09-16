import 'package:get/get.dart';

import '../controllers/chnge_profile_controller.dart';

class ChngeProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChngeProfileController>(
      () => ChngeProfileController(),
    );
  }
}
