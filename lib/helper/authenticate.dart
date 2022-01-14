import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/views/login.dart';
import 'package:chat_app/views/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final HelperFunction _helperFunction = HelperFunction();
  bool showSignIn = true;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await _helperFunction.getUserLoggedInSharedPreference().then((value) =>
        {if (value == true) Navigator.pushReplacementNamed(context, '/chat')});
  }

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _helperFunction.getUserLoggedInSharedPreference(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Home'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {},
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {},
              ),
            );
          } else {
            return showSignIn
                ? LoginScreen(toggleView: toggleView)
                : SignUpScreen(toggleView: toggleView);
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
