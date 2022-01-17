import 'package:chat_app/model/user.dart';

class Message {
  final CustomUser? sender;
  final String? time;
  final String? text;
  final bool? isLiked;
  final bool? unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}