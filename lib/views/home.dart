import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/helper/homefunctions.dart';
import 'package:chat_app/helper/search_screen.dart';
import 'package:chat_app/views/chatrooms.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HelperFunction _helperFunction = HelperFunction();
  final HomeFunction _homeFunction = HomeFunction();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await _helperFunction.getUserNameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
        title: const Text('conversations'),
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
                );
              }
            },
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 90.0,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  _homeFunction.chatRoomsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
