import 'dart:developer';

import 'package:chat_app/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Conversations extends StatefulWidget {
  const Conversations({Key? key, required this.chatRoomId}) : super(key: key);
  final String chatRoomId;

  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  final TextEditingController _messengerController = TextEditingController();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _databaseMethods.getConversationMessages(widget.chatRoomId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> list = snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return {
                  'message': data['message'],
                  'sendBy': data['sendBy'],
                  'time': data['time'],
                };
              })
              .toList()
              .reversed
              .toList();
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return MessageTile(
                  message: list[index]['message'],
                  me: list[index]['sendBy'] == Constants.myName);
            },
            reverse: true,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  sendMessage() {
    if (_messengerController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": _messengerController.text,
        "sendBy": Constants.myName.toString(),
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      _databaseMethods.sendMessage(widget.chatRoomId, messageMap);
      _messengerController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: () async {}),
        ],
        toolbarHeight: height * 0.1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3383CD),
                Color(0xFF11249F),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.6),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0.0, 0, height * 0.16),
                child: chatMessageList(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: messageBar(height, width),
              ),
            ],
          );
        },
      ),
    );
  }

  Container messageBar(double height, double width) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.1),
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      height: height * 0.16,
      child: Column(
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.emoji_emotions_outlined,
                  size: 40,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.camera_alt,
                  size: 40,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.photo,
                  size: 40,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.mic,
                  size: 40,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, width * 0.2, 0.0),
                child: TextField(
                  controller: _messengerController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Type in your text",
                      fillColor: Colors.white70),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(width * 0.2, 15.0, 25.0, 0.0),
                  child: IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key, required this.message, required this.me})
      : super(key: key);
  final String message;
  final bool me;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    EdgeInsets padding;
    Alignment align;
    String image = "";
    if (me) {
      padding = EdgeInsets.fromLTRB(width * 0.2, 0, 40, 0);
      align = Alignment.topRight;
      image = "https://c.tenor.com/fFntTHJYFPMAAAAM/random.gif";
    } else {
      padding = EdgeInsets.fromLTRB(40, 20, width * 0.2, 0);
      align = Alignment.topLeft;
      image = "https://img-9gag-fun.9cache.com/photo/a3Q5VW5_460s.jpg";
    }
    return Column(
      children: [
        Align(
          alignment: align,
          child: Padding(
            padding: padding,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 10, 15.0, 10.0),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: align,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(image),
            ),
          ),
        ),
      ],
    );
  }
}
