import 'package:chat_app/model/message.dart';
import 'package:flutter/material.dart';

Widget chatTile(Message chat, BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  chat.unread = true;
  return GestureDetector(
    onTap: () {
      chat.onTap(chat.sender.name, context);
    },
    child: Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: chat.unread ? const Color(0xFFFFEFEE) : Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    "https://c.tenor.com/fFntTHJYFPMAAAAM/random.gif"),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.sender.name,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      chat.text,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              Text(
                chat.time,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: chat.unread ? Colors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
  // Padding(
  //   padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
  //   child: ListTile(
  //     onTap: () {
  //       chat.onTap(chat.sender.name, context);
  //     },
  //     leading: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(25),
  //         gradient: const LinearGradient(
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //           colors: [
  //             Color(0xFF3383CD),
  //             Color(0xFF11249F),
  //           ],
  //         ),
  //       ),
  //       child: const CircleAvatar(
  //         radius: 25,
  //         backgroundImage: AssetImage(
  //           'assets/group.png',
  //         ),
  //         backgroundColor: Colors.transparent,
  //       ),
  //     ),
  //     title: Text(
  //       chat.sender.name + " - " + chat.text,
  //       style: const TextStyle(
  //         fontSize: 20,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     subtitle: Text(
  //       chat.time,
  //       style: const TextStyle(
  //         fontSize: 15,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   ),
  // );
}
