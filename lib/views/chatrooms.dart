import 'dart:developer';

import 'package:chat_app/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({Key? key, required this.chatRoomId}) : super(key: key);
  final String chatRoomId;

  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  final TextEditingController _messengerController = TextEditingController();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo),
            iconSize: 25.0,
            color: Colors.blue,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messengerController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color: const Color(0xFF11249F),
            onPressed: () {
              sendMessage();
            },
          ),
        ],
      ),
    );
  }

  _buildMessage(
      String message,
      String time,
      bool isMe,
      double width,
      bool isLiked,
      String chatRoomId,
      String id,
      String sentBy,
      dateTime,
      bool seen) {
    final Widget msg = Row(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: isMe ? width * 0.2 : 0.0,
            right: isMe ? 0.0 : width * 0.05,
          ),
          width: width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : const Color(0xFFFFEFEE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 15.0 : 0.0),
                bottomLeft: Radius.circular(isMe ? 15.0 : 0.0),
                topRight: Radius.circular(isMe ? 0.0 : 15.0),
                bottomRight: Radius.circular(isMe ? 0.0 : 15.0),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: [
        msg,
        IconButton(
          onPressed: () {
            _databaseMethods.updateMessage(
                chatRoomId, id, message, sentBy, dateTime, !isLiked, seen);
          },
          icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
          iconSize: 30.0,
          color: isLiked ? Colors.red : Colors.blueGrey,
        ),
      ],
    );
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm');
    var formatDay = DateFormat('HH:mm - EEEEE');
    var formatYear = DateFormat('HH:mm - dd-MM-yyyy');
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      if (diff.inDays == -1) {
        time = format.format(date) + " - Yesterday";
      } else if (diff.inDays > -5 && diff.inDays < -1) {
        time = formatDay.format(date);
      } else if (diff.inDays <= -5) {
        time = formatYear.format(date);
      } else {
        time = format.format(date);
      }
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
  }

  chatMessageList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _databaseMethods.getConversationMessages(widget.chatRoomId),
      builder: (context, snapshot) {
        final width = MediaQuery.of(context).size.width;
        if (snapshot.hasData) {
          List<Map<String, dynamic>> list = snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return {
                  'id': document.id,
                  'message': data['message'],
                  'sentBy': data['sentBy'],
                  'time': data['time'],
                  'liked': data['liked'],
                  'seen': data['seen'],
                };
              })
              .toList()
              .reversed
              .toList();
          for (int i = 0; i < list.length; i++) {
            if (list[i]['sentBy'] != Constants.myName) {
              _databaseMethods.updateMessage(
                  widget.chatRoomId,
                  list[i]['id'],
                  list[i]["message"],
                  list[i]["sentBy"],
                  list[i]["time"],
                  list[i]['liked'],
                  true);
            }
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 15.0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: list.length,
            reverse: true,
            itemBuilder: (context, index) {
              inspect(list[index]);
              return _buildMessage(
                list[index]['message'],
                readTimestamp(list[index]['time']),
                list[index]['sentBy'] == Constants.myName,
                width,
                list[index]['liked'],
                widget.chatRoomId,
                list[index]['id'],
                list[index]['sentBy'],
                list[index]['time'],
                list[index]['seen'],
              );
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

  sendMessage() {
    if (_messengerController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": _messengerController.text,
        "sentBy": Constants.myName.toString(),
        "time": DateTime.now().millisecondsSinceEpoch,
        "liked": false,
        "seen": false,
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
    final names = widget.chatRoomId.split('_');
    final name = names[0] == Constants.myName ? names[1] : names[0];
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(name),
        actions: [
          IconButton(
              icon: const Icon(Icons.more_horiz), onPressed: () async {}),
        ],
        centerTitle: true,
        elevation: 0,
        toolbarHeight: height * 0.1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF3383CD),
                Color(0xFF11249F),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.6),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF3383CD),
              Color(0xFF11249F),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: chatMessageList(),
                  ),
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ),
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
