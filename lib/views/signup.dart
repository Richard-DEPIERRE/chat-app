// import 'package:chat_app/widgets/buttons.dart';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();
  File? imageUser;

  // TODO: implement build
  pickImage() async {
  }

  // TODO: implement build
  takeImage() async {
  }

  Future<ImageSource?> chooseImage(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                takeImage();
                Navigator.pop(context, ImageSource.camera);
              },
              child: const Text('Take Photo'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                pickImage();
                Navigator.pop(context, ImageSource.gallery);
              },
              child: const Text('Choose From Gallery'),
            ),
          ],
        ),
      );
    }
    return showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Take Photo'),
            onTap: () async {
              await takeImage();
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Choose From Gallery'),
            onTap: () async {
              await pickImage();
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  // TODO: implement build
  signMeUp(BuildContext context) {
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
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
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image(
                          width: width * 0.4,
                          image:
                              const AssetImage("assets/transparent_icon.png"),
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
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 0.0, 20.0, 0.0),
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
                              padding: const EdgeInsets.fromLTRB(
                                20.0,
                                0.0,
                                20.0,
                                0.0,
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Please enter a password';
                                  } else if (value != null &&
                                      value.length < 6) {
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
                              padding: const EdgeInsets.fromLTRB(
                                20.0,
                                0.0,
                                20.0,
                                0.0,
                              ),
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
                            imageUser == null
                                ? ElevatedButton(
                                    onPressed: () async {
                                      await chooseImage(context);
                                    },
                                    child: const Text('Choose Image'),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      await chooseImage(context);
                                    },
                                    child: Container(
                                      width: width * 0.4,
                                      height: width * 0.4,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(imageUser!),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: width * 0.7,
                              child: ElevatedButton(
                                child: const Text('Sign uping'),
                                onPressed: () async {
                                  try {
                                    signMeUp(context);
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
                                  color: Color.fromRGBO(172, 172, 172, 1),
                                ),
                              ),
                              TextSpan(
                                text: "Log in",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(125, 125, 125, 1),
                                ),
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
