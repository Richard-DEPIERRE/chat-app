import 'dart:developer';

import 'package:chat_app/model/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomUser _userUserFromFirebaseUser(User? user) {
    return user != null
        ? CustomUser(user.email!,
            "https://firebasestorage.googleapis.com/v0/b/my-chat-app-richi.appspot.com/o/uploads%2Fuser.png?alt=media&token=a5e87fbf-fa25-4671-acf3-90b69a1cb223")
        : CustomUser('', '');
  }

  CustomUser _userGetFromFirebaseUser(user) {
    return user != null ? CustomUser(user["email"], '') : CustomUser('', '');
  }

  // TODO: implement build
  Future<String?> getCurrentUserEmail() async {
  }

  // TODO: implement build
  Future<CustomUser?> getCurrentUser() async {
  }

  // TODO: implement build
  signInWithEmailAndPassword(
      String email, String password) async {
  }

  // TODO: implement build
  Future<CustomUser?> signUpWithEmailAndPassword(
      String email, String password) async {
  }

  // TODO: implement build
  Future resetPassword(String email) async {
  }

  // TODO: implement build
  Future signout() async {
  }
}
