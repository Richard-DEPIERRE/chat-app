import 'package:chat_app/model/user.dart';

class Message {
  CustomUser sender;
  String time;
  String text;
  bool isLiked;
  bool unread;
  Function onTap;

  Message(
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
    this.onTap,
  );
}
