import 'dart:developer';
import 'dart:io';

import 'package:chat_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  final AuthMethods _authMethods = AuthMethods();

  getUsersByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  // TODO: implement build
  getUserByUserEmail(String userEmail) async {
  }

  // TODO: implement build
  Future<List<Map<String, String>>?> getFaourites() async {
  }

  // TODO: implement build
  Future<List<String>?> getSuggestionByQuery(String query) async {
  }

  // TODO: implement build
  Future<String?> uploadImage(
      String fileName, File imageFile, String username) async {
  }

  // TODO: implement build
  uploadUserInfo(userData) {
  }

  // TODO: implement build
  createChatRoom(String? chatRoomId, chatRoomMap) {
  }

  // TODO: implement build
  Stream<QuerySnapshot<Map<String, dynamic>>>? getConversationMessages(
      String chatRoomId) {
  }

  // TODO: implement build
  Future updateMessage(String chatRoomId, String id, String message,
      String sentBy, time, bool liked, bool seen) async {
  }

  // TODO: implement build
  Future<Map<String, dynamic>?> getLatestConversation(
      String chatRoomId, String myName) async {
  }

  // TODO: implement build
  sendMessage(String chatRoomId, messageMap) {
  }

  // TODO: implement build
  Stream<QuerySnapshot<Map<String, dynamic>>>? getUserChats(String itIsMyName) {
  }
}
