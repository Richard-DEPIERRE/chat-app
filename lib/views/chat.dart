import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              authMethods.signout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await showSearch(context: context, delegate: SearchScreen());
        },
      ),
    );
  }
}

class SearchScreen extends SearchDelegate<String> {
  SearchScreen({Key? key});
  DatabaseMethods databaseMethods = DatabaseMethods();
  AuthMethods authMethods = AuthMethods();

  // Create chat room, send user to chat room, pushreplacement
  createChatRoom(String userName) async {
    // List<String> users = [
    //   userName,
    //   ,
    // ];
    // databaseMethods.createChatRoom(chatRoomId, chatRoomMap)
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
                  createChatRoom(query),
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
