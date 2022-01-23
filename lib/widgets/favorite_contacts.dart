import 'dart:developer';

import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatrooms.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class FavoriteContacts extends StatefulWidget {
  const FavoriteContacts({Key? key}) : super(key: key);

  @override
  State<FavoriteContacts> createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  createChatRoom(String userName) async {
    List<String> users = [
      userName,
      Constants.myName.toString(),
    ];
    users.sort();
    String? chatRoomId = users.join("_");

    await _databaseMethods.createChatRoom(chatRoomId, users);
    return chatRoomId;
  }

  favourites() {
    return FutureBuilder<List<Map<String, String>>>(
        future: _databaseMethods.getFaourites(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 120.0,
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      final res = await createChatRoom(
                          snapshot.data![index]['username']!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRooms(
                            chatRoomId: res.toString(),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: CircleAvatar(
                            radius: 35.0,
                            backgroundImage: NetworkImage(
                              snapshot.data![index]['image'] ??
                                  'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          snapshot.data![index]['username'] ?? '',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return const SizedBox(
              height: 120.0,
              child: Center(
                child: Text("No Contacts"),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Contacts",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                  color: Colors.blueGrey,
                  iconSize: 30.0,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          favourites()
        ],
      ),
    );
  }
}
