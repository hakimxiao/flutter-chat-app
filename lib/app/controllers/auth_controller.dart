import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/app/routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> firstInitialize() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

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
      debugPrint("Terjadi error autoLogin: $e");
      return false;
    }
  }

  Future<bool> skipIntro() async {
    try {
      final box = GetStorage();
      if (box.read('skipIntro') == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Terjadi error skipIntro: $e");
      return false;
    }
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = await _googleSignIn.signIn();

      if (_currentUser != null) {
        debugPrint('BERHASIL MENDAPATKAN AKUN GOOGLE: ${_currentUser!.email}');

        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );

        debugPrint(
          'BERHASIL LOGIN KE FIREBASE AUTH: ${userCredential!.user!.uid}',
        );

        // Simpan status skip intro
        final box = GetStorage();
        box.write('skipIntro', true);

        // --- BLOK LOGIKA YANG DIPERBAIKI ---

        CollectionReference users = firestore.collection('users');
        final checkUser = await users.doc(_currentUser!.email).get();

        // Data timestamp untuk pengguna baru atau lama
        String now = DateTime.now().toIso8601String();
        String lastSignInTime = userCredential!.user!.metadata.lastSignInTime!
            .toIso8601String();

        if (!checkUser.exists) {
          // PENGGUNA BARU: Buat dokumen baru di Firestore
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "",
            "creationTime": userCredential!.user!.metadata.creationTime!
                .toIso8601String(),
            "lastSignInTime": lastSignInTime,
            "updatedTime": now,
          });
          debugPrint("Data pengguna baru berhasil dibuat di Firestore.");
        } else {
          // PERBAIKAN 1: Pengguna lama, update data waktu login terakhir
          await users.doc(_currentUser!.email).update({
            "lastSignInTime": lastSignInTime,
            "updatedTime": now,
          });
          debugPrint("Data pengguna lama berhasil diupdate.");
        }

        // PERBAIKAN 2: Navigasi hanya dilakukan sekali di sini untuk pengguna baru & lama
        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);

        // --- AKHIR BLOK LOGIKA YANG DIPERBAIKI ---
      } else {
        debugPrint("Login Google dibatalkan oleh pengguna.");
      }
    } catch (e) {
      debugPrint("Terjadi error saat proses login: $e");
      // Opsional: Tampilkan snackbar atau dialog jika terjadi error
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak dapat login. Silakan coba lagi.",
      );
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    isAuth.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }
}
