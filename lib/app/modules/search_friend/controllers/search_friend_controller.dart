import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SearchFriendController extends GetxController {
  late TextEditingController searchC;

  @override
  void onInit() {
    searchC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
