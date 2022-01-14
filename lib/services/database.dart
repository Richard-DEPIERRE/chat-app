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

  getUserByUserEmail(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();
      Map<String, String> user = {
        "username": querySnapshot.docs[0]['username'],
        "email": querySnapshot.docs[0]['email']
      };
      return user;
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
      String user = doc['username'].toString().toLowerCase();
      _authMethods.getCurrentUser();
      if (user.startsWith(query) &&
          doc['email'] != await _authMethods.getCurrentUserEmail()) {
        documents.add(doc['username']);
      }
    }
    inspect(documents);
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

  createChatRoom(String? chatRoomId, chatRoomMap) {
    try {
      FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatRoomId)
          .set({"chatroomid": chatRoomId, "users": chatRoomMap});
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getConversationMessages(
      String chatRoomId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
    return stream;
  }

  Future<Map<String, dynamic>> getLatestConversation(
      String chatRoomId, String myName) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .get();
    if (querySnapshot.docs.isEmpty) {
      return {
        "message": "No messages yet",
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
        "name": myName,
      };
    }
    DocumentSnapshot<Map<String, dynamic>> querySnapshot2 =
        await FirebaseFirestore.instance
            .collection('chatroom')
            .doc(chatRoomId)
            .collection('chats')
            .doc(querySnapshot.docs[querySnapshot.docs.length - 1].id)
            .get();
    List<String> name = chatRoomId.split("_");
    return {
      "message": querySnapshot2.data()?['message'].toString(),
      "time": querySnapshot2.data()?['time'].toString(),
      "name": name[0] == myName ? name[1] : name[0],
    };
  }

  sendMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats(String itIsMyName) {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
