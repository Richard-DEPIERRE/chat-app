
import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversations.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final HelperFunction _helperFunction = HelperFunction();

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
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              authMethods.signout();
              await _helperFunction.saveUserLoggedInSharedPreference(false);
              Navigator.of(context).pushReplacementNamed('/');
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 0.0),
              child: ListTile(
                onTap: () async {
                  var res = await showSearch(
                      context: context,
                      delegate: SearchScreen(context: context));
                  if (res != "close") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Conversations(
                          chatRoomId: res.toString(),
                        ),
                      ),
                    );
                  }
                },
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3383CD),
                        Color(0xFF11249F),
                      ],
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(
                      'assets/group.png',
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                title: const Text(
                  "+ New chat or create group",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () async {
      //     var res = await showSearch(
      //         context: context, delegate: SearchScreen(context: context));
      //     if (res != "close") {
      //       Navigator.of(context).pushNamed('/conversations');
      //     }
      //   },
      // ),
    );
  }
}

class SearchScreen extends SearchDelegate<String> {
  SearchScreen({Key? key, required this.context});
  BuildContext context;
  DatabaseMethods databaseMethods = DatabaseMethods();
  AuthMethods authMethods = AuthMethods();

  createChatRoom(String userName) async {
    List<String> users = [
      userName,
      Constants.myName.toString(),
    ];
    users.sort();
    String? chatRoomId = users.join("_");
    await databaseMethods.createChatRoom(chatRoomId, users);
    close(context, chatRoomId);
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, "Done");
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          close(context, "close");
        },
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) => FutureBuilder<List<String>>(
        future: databaseMethods.getSuggestionByQuery(query),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              return buildSuggestionsSuccess(snapshot.data);
          }
        },
      );

  Widget buildSuggestionsSuccess(users) => ListView.builder(
        itemCount: users!.length,
        itemBuilder: (context, index) {
          final suggestion = users[index];
          var queryText = "";
          var remainingText = "";
          if (suggestion != null) {
            queryText = suggestion.substring(0, query.length);
            remainingText = suggestion.substring(query.length);
          } else {
            queryText = "";
            remainingText = "";
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/OOjs_UI_icon_userAvatar.svg/2048px-OOjs_UI_icon_userAvatar.svg.png"),
                backgroundColor: Colors.grey,
              ),
              title: RichText(
                text: TextSpan(
                  text: queryText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: remainingText,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () => {
                  createChatRoom(users[index]),
                },
                child: const Text("Message"),
              ),
              onTap: () {
                query = suggestion;
                close(context, suggestion);
              },
            ),
          );
        },
      );
}
