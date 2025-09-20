import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final firebaseAuth = FirebaseAuth.instance;
  final Rxn<User> firebaseUser = Rxn<User>();

  var isSkip = false.obs;
  var isAuth = false.obs;

  late GoogleSignIn _googleSignIn;

  @override
  void onInit() {
    super.onInit();
    _googleSignIn = GoogleSignIn();

    firebaseAuth.authStateChanges().listen((user) {
      firebaseUser.value = user;
      isAuth.value = user != null;
    });
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return;

      final GoogleSignInAuthentication auth = await account.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint("Google SignIn error: $e");
    }
  }

  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint("Logout error: $e");
    } finally {
      isAuth.value = false;
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
