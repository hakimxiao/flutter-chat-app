import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final firebaseAuth = FirebaseAuth.instance;
  final Rxn<User> firebaseUser = Rxn<User>();

  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  late GoogleSignIn _googleSignIn;

  Future<void> firstInitialize() async {
    // 1. AUTOLOGIN
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    // 2. INTRODUCTION HANYA DIKIRIM JIKA BELUM PERNAH LOGIN
    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Terjadi error : $e");
      return false;
    }
  }

  Future<bool> skipIntro() async {
    try {
      final box = GetStorage();
      if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Terjadi error : $e");
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _googleSignIn = GoogleSignIn();

    firebaseAuth.authStateChanges().listen((user) {
      firebaseUser.value = user;
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

      // * Simpan Status User Bahwa Pernah Login || Dengan Get Storage || Agar Introduction Screen Hanya Ditampilkan Jika Belum Pernah Login
      final box = GetStorage();
      if (box.read('skipIntro') != null) {
        box.remove('skipIntro');
      }
      box.write('skipIntro', true);

      Get.offAllNamed(Routes.HOME);
      debugPrint('USER CREDENTIAL:  ${credential.toString()}');
    } catch (e) {
      debugPrint("Google SignIn error: $e");
    }
  }

  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    } catch (e) {
      debugPrint("Logout error: $e");
    } finally {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
