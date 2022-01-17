import 'dart:developer';
import 'package:chat_app/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatrooms.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeFunction {
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  createChatRoom(String userName, BuildContext context) async {
    List<String> users = [
      userName,
      Constants.myName.toString(),
    ];
    users.sort();
    String? chatRoomId = users.join("_");
    await _databaseMethods.createChatRoom(chatRoomId, users);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRooms(
          chatRoomId: chatRoomId.toString(),
        ),
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
  }

  Widget chatRoomsList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _databaseMethods
          .getUserChats(Constants.myName.toString())
          .asyncMap((event) async {
        List<String> chatRoomIds = event.docs.map((DocumentSnapshot doc) {
          return doc.id;
        }).toList();
        List<Map<String, dynamic>> data = [];
        for (int i = 0; i < chatRoomIds.length; i++) {
          data.add(await _databaseMethods.getLatestConversation(
              chatRoomIds[i], Constants.myName.toString()));
        }
        inspect(data);
        return data;
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          snapshot.data!.sort((a, b) {
            return int.parse(b['time']) - int.parse(a['time']);
          });
          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return chatTile(
                  snapshot.data![index]['name'],
                  snapshot.data![index]['message'],
                  readTimestamp(int.parse(snapshot.data![index]['time'])),
                  createChatRoom,
                  context);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
