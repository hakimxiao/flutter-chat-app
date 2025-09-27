import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chnge_profile_controller.dart';

class ChngeProfileView extends GetView<ChngeProfileController> {
  ChngeProfileView({super.key});

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // variabel obx
    controller.emailC.text = authC.user.value.email!;
    controller.nameC.text = authC.user.value.name!;
    controller.statusC.text = authC.user.value.status ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent[100],
        title: const Text('Change Profile'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                authC.changeProfile(
                    controller.nameC.text, controller.statusC.text);
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            AvatarGlow(
                endRadius: 75,
                glowColor: Colors.black,
                duration: Duration(seconds: 2),
                child: Container(
                  margin: EdgeInsets.all(15),
                  width: 120,
                  height: 120,
                  child: Obx(() => ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(200),
                        child: authC.user.value.photoUrl == 'noimage'
                            ? Image.asset(
                                'assets/logo/noimage.png',
                                fit: BoxFit.cover,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: Image.network(
                                  authC.user.value.photoUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      )),
                )),
            SizedBox(height: 20),
            TextField(
              controller: controller.emailC,
              readOnly: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                label: Text("Email"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller.nameC,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                label: Text("Name"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller.statusC,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                authC.changeProfile(
                    controller.nameC.text, controller.statusC.text);
              },
              decoration: InputDecoration(
                label: Text("Status"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('No Image'),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Pilih file',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  authC.changeProfile(
                      controller.nameC.text, controller.statusC.text);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  "Update",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
