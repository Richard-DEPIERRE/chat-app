import 'package:chat_app/model/user.dart';

class Message {
  CustomUser sender;
  String time;
  String text;
  bool isLiked;
  bool seen;
  Function onTap;

  Message(
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.seen,
    this.onTap,
  );
}
