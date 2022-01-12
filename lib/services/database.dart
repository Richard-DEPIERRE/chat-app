import 'dart:developer';
import 'package:chat_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DatabaseMethods {
  final AuthMethods _authMethods = AuthMethods();

  getUsersByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();
      print(querySnapshot.docs[0]['username']);
      return "hello";
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<List<String>> getSuggestionByQuery(String query) async {
    query = query.toLowerCase();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<String> documents = [];
    for (var doc in querySnapshot.docs) {
      if (kDebugMode) {
        String user = doc['username'].toString().toLowerCase();
        _authMethods.getCurrentUser();
        if (user.startsWith(query) &&
            doc['email'] != await _authMethods.getCurrentUserEmail()) {
          documents.add(doc['username']);
        }
      }
    }
    return documents;
  }

  uploadUserInfo(userData) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser?.uid)
          .set(userData);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    try {
      FirebaseFirestore.instance.collection('users').doc(chatRoomId).set(chatRoomMap);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
