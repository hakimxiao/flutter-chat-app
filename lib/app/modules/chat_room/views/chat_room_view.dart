import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({super.key});
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
                SizedBox(width: 5),
                Icon(Icons.arrow_back),
                SizedBox(width: 5),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  child: Image.asset('assets/logo/noimage.png'),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent[100],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lorem ipsum',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text('Status Lorem', style: TextStyle(fontSize: 14)),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: ListView(
                children: [ItemChat(isSender: true), ItemChat(isSender: false)],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.emoji_emotions_outlined),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Material(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.purple[100],
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Icon(Icons.send),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({super.key, required this.isSender});

  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
              color: Colors.deepPurpleAccent[200],
            ),
            padding: EdgeInsets.all(15),
            child: Text(
              'hsdhaeuhueafuyieg',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 5),
          Text('18:22'),
        ],
      ),
    );
  }
}
