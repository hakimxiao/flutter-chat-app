import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  UpdateStatusView({super.key});

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controller.statusC.text = authC.user.value.status ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent[100],
        title: const Text('Update Status'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.statusC,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                authC.updateStatus(controller.statusC.text);
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
            SizedBox(height: 30),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  authC.updateStatus(controller.statusC.text);
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
