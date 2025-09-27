import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => authC.logout(), icon: Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            child: Column(
              children: [
                AvatarGlow(
                    endRadius: 110,
                    glowColor: Colors.black,
                    duration: Duration(seconds: 2),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      width: 175,
                      height: 175,
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
                Obx(
                  () => Text(
                    "${authC.user.value.name}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  "${authC.user.value.email}",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              child: Column(
                children: [
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                    leading: Icon(Icons.note_add_outlined),
                    title: Text(
                      "Update Status",
                      style: TextStyle(fontSize: 22, color: Colors.black54),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.CHNGE_PROFILE),
                    leading: Icon(Icons.person),
                    title: Text(
                      "Change Profile",
                      style: TextStyle(fontSize: 22, color: Colors.black54),
                    ),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.color_lens),
                    title: Text(
                      "Change Theme",
                      style: TextStyle(fontSize: 22, color: Colors.black54),
                    ),
                    trailing: Text("light"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(
              bottom: context.mediaQueryPadding.bottom + 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chat App",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
                Text(
                  "V.1.0",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
