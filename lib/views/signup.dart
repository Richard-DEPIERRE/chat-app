// import 'package:chat_app/widgets/buttons.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.toggleView}) : super(key: key);

  final Function toggleView;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;

  final AuthMethods _authMethods = AuthMethods();
  final DatabaseMethods _databaseMethods = DatabaseMethods();
  final HelperFunction _helperFunction = HelperFunction();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  signMeUp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _authMethods
          .signUpWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((value) {
        if (value != null) {
          Map<String,String> userDataMap = {
            "username" : _usernameController.text,
            "email" : _emailController.text
          };
          _helperFunction.saveUserEmailSharedPreference(_emailController.text);
          _helperFunction.saveUserNameSharedPreference(_usernameController.text);
          _databaseMethods.uploadUserInfo(userDataMap);
          Fluttertoast.showToast(msg: "Sign Up Successful");
          Navigator.pushReplacementNamed(context, "/chat");
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0, 0, 10.0),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image(
                        width: width * 0.4,
                        image: const NetworkImage(
                            "https://freepngimg.com/download/facebook/59992-blue-aqua-sky-messages-area-free-clipart-hd.png"),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 0.0),
                            child: TextFormField(
                              validator: (val) {
                                if (val != null && val.isEmpty) {
                                  return 'Please enter a username';
                                } else if (val != null && val.length < 4) {
                                  return 'Username must be at least 4 characters';
                                }
                                return null;
                              },
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
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
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value != null &&
                                    value != _passwordController.text) {
                                  return 'Please enter the same password';
                                }
                                return null;
                              },
                              controller: _passwordConfirmController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Confirm password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width * 0.7,
                            child: ElevatedButton(
                              child: const Text('Sign up'),
                              onPressed: () async {
                                try {
                                  signMeUp();
                                } catch (e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }
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
                              text: "Already have an account? ",
                              style: TextStyle(
                                  color: Color.fromRGBO(172, 172, 172, 1)),
                            ),
                            TextSpan(
                              text: "Log in",
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
                    // const Text(
                    //   "Or",
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color.fromRGBO(125, 125, 125, 1),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: width * 0.8,
                    //   child: CustomWidgets.socialButtonRect(
                    //     '|     Sign up with Google',
                    //     const Color(0xffDF4A32),
                    //     "assets/google.png",
                    //     onTap: () {
                    //       Fluttertoast.showToast(msg: 'I am Google');
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}