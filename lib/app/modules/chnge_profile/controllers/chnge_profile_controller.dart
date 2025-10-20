// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChngeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;
  late ImagePicker imagePicker;

  // ignore: avoid_init_to_null
  XFile? pickedImage = null;

  void uploadImage() {
    if (pickedImage != null) {
      print(pickedImage!.name);
      print(pickedImage!.path);
      print(
          "Image uploaded || FITUR FIRERBASE STRORAGE BERBAYAR MAKANYA KITA PAKAI PRINT SAJA");
    }
  }

  void resetImage() {
    pickedImage = null;
    update();
  }

  void selectImage() async {
    try {
      final checkDataImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (checkDataImage != null) {
        print(checkDataImage.name);
        print(checkDataImage.path);
        pickedImage = checkDataImage;
        update();
      }
    } catch (e) {
      print(e);
      pickedImage = null;
      update();
    }
  }

  @override
  void onInit() {
    emailC = TextEditingController(text: 'LoremIpsum@gmail.com');
    nameC = TextEditingController(text: 'Lorem Ipsum');
    statusC = TextEditingController();
    imagePicker = ImagePicker();

    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    nameC.dispose();
    statusC.dispose();
    super.onClose();
  }
}
