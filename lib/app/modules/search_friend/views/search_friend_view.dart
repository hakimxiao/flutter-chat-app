import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_friend_controller.dart';

class SearchFriendView extends GetView<SearchFriendController> {
  SearchFriendView({super.key});

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(140),
          child: AppBar(
            backgroundColor: Colors.deepPurpleAccent[100],
            title: const Text('Search'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back),
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  onChanged: (value) => controller.searchFriend(
                    value,
                    authC.user.value.email!,
                  ),
                  controller: controller.searchC,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    hintText: "Search new friend here..",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Obx(
          () => controller.tempSearch.isEmpty
              ? Center(
                  child: SizedBox(
                    height: Get.width * 0.7,
                    width: Get.width * 0.7,
                    child: Lottie.asset('assets/lottie/empty.json'),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.tempSearch.length,
                  itemBuilder: (context, index) => ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black26,
                      child: Image.asset('assets/logo/noimage.png',
                          fit: BoxFit.cover),
                    ),
                    title: Text(
                      '${controller.tempSearch[index]["name"]}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${controller.tempSearch[index]["email"]}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    trailing: GestureDetector(
                      onTap: () => authC.addNewConnection(
                          controller.tempSearch[index]["email"]),
                      child: Chip(label: Text("Message")),
                    ),
                  ),
                ),
        ));
  }
}
