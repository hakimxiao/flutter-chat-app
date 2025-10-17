// ignore_for_file: deprecated_member_use, non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  ChatRoomView({super.key});

  final authC = Get.find<AuthController>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)["chat_id"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => Get.back(),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 5),
                const Icon(Icons.arrow_back),
                const SizedBox(width: 5),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  child: StreamBuilder<DocumentSnapshot<dynamic>>(
                      stream: controller.streamFriendData(
                        (Get.arguments as Map<String, dynamic>)["friendEmail"],
                      ),
                      builder: (context, snapFriendUser) {
                        if (snapFriendUser.connectionState ==
                            ConnectionState.active) {
                          var dataFriend = snapFriendUser.data!.data()
                              as Map<String, dynamic>;
                          if (dataFriend["photoUrl"] == "noimage") {
                            return ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(50),
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(50),
                                child: Image.asset(
                                  'assets/logo/noimage.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(50),
                              child: Image.network(dataFriend["photoUrl"],
                                  fit: BoxFit.cover),
                            );
                          }
                        }
                        return ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(50),
                          child: Image.asset(
                            'assets/logo/noimage.png',
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent[100],
        title: StreamBuilder<DocumentSnapshot<dynamic>>(
          stream: controller.streamFriendData(
            (Get.arguments as Map<String, dynamic>)["friendEmail"],
          ),
          builder: (context, snapFriendUser) {
            if (snapFriendUser.connectionState == ConnectionState.active) {
              var dataFriend =
                  snapFriendUser.data!.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataFriend["name"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(dataFriend["status"], style: TextStyle(fontSize: 14)),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loading ...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text('Loading ...', style: TextStyle(fontSize: 14)),
              ],
            );
          },
        ),
        centerTitle: false,
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.isShowEmoji.isTrue) {
            controller.isShowEmoji.value = false;
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            // GANTI BAGIAN INI
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamChats(chat_id),
                builder: (context, snapshot) {
                  // 1. Tampilkan loading jika data belum siap
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // 2. (Opsional tapi direkomendasikan) Tampilkan pesan jika tidak ada chat
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Belum ada pesan."),
                    );
                  }

                  // 3. Jika data sudah ada, baru tampilkan list chat
                  var allData = snapshot.data!.docs;
                  Timer(
                      Duration.zero,
                      () => controller.scrollC
                          .jumpTo(controller.scrollC.position.maxScrollExtent));
                  return ListView.builder(
                      controller: controller.scrollC,
                      itemCount: allData.length,
                      itemBuilder: (context, index) => ItemChat(
                          isSender: allData[index]["pengirim"] ==
                                  authC.user.value.email
                              ? true
                              : false,
                          time: allData[index]["time"],
                          message: allData[index]["msg"]));
                },
              ),
            ),
            // SAMPAI SINI
            Container(
              margin: EdgeInsets.only(
                bottom: controller.isShowEmoji.isTrue
                    ? 5
                    : context.mediaQueryPadding.bottom,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        autocorrect: false,
                        controller: controller.chatC,
                        focusNode: controller.focusNode,
                        onEditingComplete: () => controller.newChat(
                            authC.user.value.email!,
                            Get.arguments as Map<String, dynamic>,
                            controller.chatC.text),
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {
                              controller.focusNode.unfocus();
                              controller.isShowEmoji.toggle();
                            },
                            icon: const Icon(Icons.emoji_emotions_outlined),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.purple[100],
                    child: InkWell(
                      onTap: () => controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text),
                      child: const Padding(
                        padding: EdgeInsets.all(13),
                        child: Icon(Icons.send),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Offstage(
                offstage: !controller.isShowEmoji.value,
                child: SizedBox(
                  height: 325,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      controller.addEmojiToChat(emoji);
                    },
                    onBackspacePressed: () {
                      controller.deleteEmoji();
                    },
                    config: Config(
                      height: 256,
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 28 *
                            (foundation.defaultTargetPlatform ==
                                    TargetPlatform.iOS
                                ? 1.2
                                : 1.0),
                      ),
                      viewOrderConfig: const ViewOrderConfig(),
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                      searchViewConfig: const SearchViewConfig(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat(
      {super.key,
      required this.isSender,
      required this.message,
      required this.time});

  final bool isSender;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: isSender
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
              color: Colors.deepPurpleAccent[200],
            ),
            padding: const EdgeInsets.all(15),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 5),
          Text(time),
        ],
      ),
    );
  }
}
