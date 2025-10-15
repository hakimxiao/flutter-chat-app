import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(String email) {
    return firestore
        .collection('users')
        .doc(email)
        .collection("chats")
        .orderBy("lastTime")
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  void goToChatRoom(String chat_id, String email, String friendEmail) async {
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    final updateStatusChat = await chats
        .doc(chat_id)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: email)
        .get();

    // ignore: avoid_function_literals_in_foreach_calls
    updateStatusChat.docs.forEach(
      (element) async {
        element.id;
        await chats
            .doc(chat_id)
            .collection("chat")
            .doc(element.id)
            .update({"isRead": true});
      },
    );

    await users.doc(email).collection("chats").doc(chat_id).update({
      "total_unread": 0,
    });

    Get.toNamed(Routes.CHAT_ROOM,
        arguments: {"chat_id": chat_id, "friendEmail": friendEmail});
  }
}
