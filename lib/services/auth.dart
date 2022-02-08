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

  Future<String?> getCurrentUserEmail() async {
    try {
      User? user = _auth.currentUser;
      if (kDebugMode) {
        print(user?.email);
      }
      return user?.email;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<CustomUser> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (kDebugMode) {
        print(user?.email);
      }
      return _userUserFromFirebaseUser(user);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return CustomUser('', '');
    }
  }

  signInWithEmailAndPassword(
      String email, String password) async {
    try {
      User? user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      final userT = await DatabaseMethods().getUserByUserEmail(user!.email!);
      return _userGetFromFirebaseUser(userT);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          return "Wrong user found";
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          return "Wrong password provided";
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<CustomUser?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      inspect(user);
      var res = _userUserFromFirebaseUser(user);
      return res;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}
