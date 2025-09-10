import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_friend_controller.dart';

class SearchFriendView extends GetView<SearchFriendController> {
  const SearchFriendView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SearchFriendView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SearchFriendView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
