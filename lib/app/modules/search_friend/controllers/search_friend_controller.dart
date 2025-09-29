import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SearchFriendController extends GetxController {
  late TextEditingController searchC;

  var queryAwal = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data) async {
    debugPrint("SEARCH : $data");

    if (data.isEmpty) {
      queryAwal.value = [];
      tempSearch.value = [];
    } else {
      var capitalize = data.substring(0, 1).toUpperCase() + data.substring(1);
      debugPrint("CAPITALIZE : $capitalize");

      if (queryAwal.isEmpty && data.length == 1) {
        // fungsi yang akan dijalankan pada 1 huruf ketikan pertama
        CollectionReference users = firestore.collection('users');
        final keyNameResult = await users
            .where('keyName', isEqualTo: data.substring(0, 1).toUpperCase())
            .get();
        debugPrint("TOTAL DATA : ${keyNameResult.docs.length}");
        if (keyNameResult.docs.isNotEmpty) {
          for (int i = 0; i < keyNameResult.docs.length; i++) {
            queryAwal.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }
          debugPrint("QUERY RESULT : ");
          debugPrint("$queryAwal");
        } else {
          debugPrint("TIDAK ADA DATA");
        }
      }

      tempSearch.value = [];
      if (queryAwal.isNotEmpty) {
        // ignore: avoid_function_literals_in_foreach_calls
        queryAwal.forEach(
          (element) {
            if (element["name"]
                .toString()
                .toLowerCase()
                .startsWith(data.toLowerCase())) {
              tempSearch.add(element);
            }
          },
        );
      }
    }

    queryAwal.refresh();
    tempSearch.refresh();
  }

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
