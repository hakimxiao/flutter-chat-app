import 'package:chatapp/app/data/models/users_model.dart';
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

  var user = UsersModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // LOGIN

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

  Future<bool> skipIntro() async {
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn.signInSilently().then(
              (value) => _currentUser = value,
            );
        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential).then(
              (value) => userCredential = value,
            );

        debugPrint("USER CREDENTIALS DARI AUTO LOGIN : $userCredential");

        // # masukkan data ke firebase
        CollectionReference users = firestore.collection('users');

        await users.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });
        debugPrint("Data pengguna lama berhasil diupdate.");

        // # Mengisi model dengan data user yang ada di Firestore.
        final currentUser = await users.doc(_currentUser!.email).get();
        final currentUserData = currentUser.data() as Map<String, dynamic>;

        user(UsersModel(
          uid: currentUserData["uid"],
          name: currentUserData["name"],
          keyName: currentUserData["keyName"],
          email: currentUserData["email"],
          photoUrl: currentUserData["photoUrl"],
          status: currentUserData["status"],
          creationTime: currentUserData["creationTime"],
          lastSignInTime: currentUserData["lastSignInTime"],
          updatedTime: currentUserData["updatedTime"],
        ));

        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Terjadi error autoLogin: $e");
      return false;
    }
  }

  Future<void> login() async {
    try {
      // Ini untuk handle kebocoran data user sebelum login
      await _googleSignIn.signOut();

      // Ini digunakan untuk mendapatkan google account
      await _googleSignIn.signIn().then(
            (value) => _currentUser = value,
          );

      // ini untuk mengecek status login user
      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        // kondisi login berhasil
        debugPrint('SUDAH BERHASIL LOGIN DENGAN AKUN :');
        debugPrint('$_currentUser');

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(
              credential,
            )
            .then(
              (value) => userCredential = value,
            );

        debugPrint(
          'USER CREDENTIAL',
        );
        debugPrint(
          '$userCredential',
        );

        // simpan status user bahwa sudah pernah login & tidak akan menampilkan introduction kembali
        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        // # masukkan data ke firebase
        CollectionReference users = firestore.collection('users');

        final checkUser = await users.doc(_currentUser!.email).get();

        if (checkUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "",
            "updatedTime": DateTime.now().toIso8601String(),
          });

          debugPrint("Data pengguna baru berhasil dibuat di Firestore.");
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
          debugPrint("Data pengguna lama berhasil diupdate.");
        }

        // # Mengisi model dengan data user yang ada di Firestore.
        final currentUser = await users.doc(_currentUser!.email).get();
        final currentUserData = currentUser.data() as Map<String, dynamic>;

        // update model bertipe obx
        user(UsersModel(
          uid: currentUserData["uid"],
          name: currentUserData["name"],
          keyName: currentUserData["keyName"],
          email: currentUserData["email"],
          photoUrl: currentUserData["photoUrl"],
          status: currentUserData["status"],
          creationTime: currentUserData["creationTime"],
          lastSignInTime: currentUserData["lastSignInTime"],
          updatedTime: currentUserData["updatedTime"],
        ));

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        debugPrint("Login Google dibatalkan oleh pengguna.");
      }
    } catch (e) {
      debugPrint("Terjadi error saat proses login: $e");
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

// PROFILE

  void changeProfile(String name, String status) {
    String date = DateTime.now().toIso8601String();

    CollectionReference users = firestore.collection('users');
    users.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date
    });

    // update model
    user.update(
      (user) {
        user!.name = name;
        user.keyName = name.substring(0, 1).toUpperCase();
        user.status = status;
        user.lastSignInTime =
            userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
        user.updatedTime = date;
      },
    );

    user.refresh();
    Get.snackbar(
      "Berhasil Mengubah Profil",
      "Profil berhasil diubah",
    );
  }

  void updateStatus(String status) {
    String date = DateTime.now().toIso8601String();

    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date
    });

    // update model
    user.update(
      (user) {
        user!.status = status;
        user.lastSignInTime =
            userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
        user.updatedTime = date;
      },
    );

    user.refresh();
    Get.snackbar(
      "Berhasil Mengubah Status",
      "Update status success",
    );
  }
}
