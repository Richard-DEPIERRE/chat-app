import 'dart:async';
import 'dart:developer';

import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/helper/homefunctions.dart';
import 'package:chat_app/helper/search_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatrooms.dart';
import 'package:chat_app/widgets/category_selector.dart';
import 'package:chat_app/widgets/favorite_contacts.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HelperFunction _helperFunction = HelperFunction();
  final HomeFunction _homeFunction = HomeFunction();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  createChatRoom(String userName, BuildContext context) async {
    List<String> users = [
      userName,
      Constants.myName.toString(),
    ];
    users.sort();
    String? chatRoomId = users.join("_");
    await _databaseMethods.createChatRoom(chatRoomId, users);
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRooms(
          chatRoomId: chatRoomId.toString(),
        ),
      ),
    ).then((value) => {setState(() {})});
  }

  getUserInfo() async {
    Constants.myName = await _helperFunction.getUserNameSharedPreference();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
        centerTitle: true,
        title: const Text('RiChat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              var res = await showSearch(
                  context: context, delegate: SearchScreen(context: context));
              if (res != "close") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRooms(
                      chatRoomId: res.toString(),
                    ),
                  ),
                ).then((value) => setState(() {}));
              }
            },
          ),
        ],
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
        elevation: 0,
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
        child: Column(
          children: [
            const CategorySelector(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF9EB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    const FavoriteContacts(),
                    _homeFunction.chatRoomsList(createChatRoom),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
