import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Berinteraksi dengan mudah",
            body: "Mulai mengobrol hanya dengan beberapa ketukan saja.",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.height * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/main-laptop-duduk.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Mari temukan teman baru di berbagai tempat",
            body:
                "Dengan ChatApp, kamu bisa terhubung dengan orang-orang di seluruh dunia.",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.height * 0.6,
              child: Center(child: Lottie.asset('assets/lottie/ojek.json')),
            ),
          ),
          PageViewModel(
            title: "Gratis, Ringan Dan Efesien.",
            body:
                "Aplikasi ini dibuat dengan sangatan ringan dan efesien untuk semua kalangan.",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.height * 0.6,
              child: Center(child: Lottie.asset('assets/lottie/payment.json')),
            ),
          ),
          PageViewModel(
            title: "Mari Daftarkan Diri Anda Sekarang.",
            body:
                "Sudah banyak yang bergabung dengan kami sekarang kesempatan anda.",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.height * 0.6,
              child: Center(child: Lottie.asset('assets/lottie/register.json')),
            ),
          ),
        ],
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Text("Next"),
        done: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onDone: () => Get.offAllNamed(Routes.LOGIN),
      ),
    );
  }
}
