import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/views/home.dart';
import 'package:chat_app/views/signin.dart';
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
    // getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await _helperFunction.getUserLoggedInSharedPreference().then((value) => {
          if (value == true)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            )
        });
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
            return const Home();
          } else {
            return showSignIn
                ? SignInScreen(toggleView: toggleView)
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
