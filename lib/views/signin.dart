// import 'package:chat_app/widgets/buttons.dart';

import 'dart:developer';

import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key, required this.toggleView}) : super(key: key);

  final Function toggleView;

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;

  final AuthMethods _authMethods = AuthMethods();
  final DatabaseMethods _databaseMethods = DatabaseMethods();
  final HelperFunction _helperFunction = HelperFunction();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // TODO: implement build
  signMeUp() {}

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 0, 10.0),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Rubik',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image(
                    width: width * 0.4,
                    image: const AssetImage("assets/transparent_icon.png"),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter an email';
                            } else if (value != null &&
                                !(RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value))) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter a password';
                            } else if (value != null && value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: width * 0.7,
                        child: ElevatedButton(
                          child: const Text('Sign in'),
                          onPressed: () async {
                            try {
                              signMeUp();
                            } catch (err) {
                              if (kDebugMode) print(err);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                              color: Color.fromRGBO(172, 172, 172, 1)),
                        ),
                        TextSpan(
                          text: "Sign up",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(125, 125, 125, 1)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              widget.toggleView();
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
