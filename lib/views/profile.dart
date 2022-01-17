import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/settings/body.dart';
import 'package:chat_app/widgets/settings/switch.dart';
import 'package:chat_app/widgets/settings/title.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final HelperFunction _helperFunction = HelperFunction();
  final AuthMethods _authMethods = AuthMethods();

  bool isDark = false;
  bool isWifi = false;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await _helperFunction.getUserNameSharedPreference();
  }

  void _onSwitchedDark(bool value) {
    setState(() {
      isDark = value;
    });
  }

  void _onSwitchedWifi(bool value) {
    setState(() {
      isWifi = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder<Object>(
        future: null,
        builder: (context, snapshot) {
          // if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(Constants.myName.toString()),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout_outlined),
                  onPressed: () async {
                    _authMethods.signout();
                    await _helperFunction
                        .saveUserLoggedInSharedPreference(false);
                    Navigator.of(context).pushNamed('/');
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
              child: Center(
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/icon.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Text(
                        Constants.myName.toString(),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        "richard.habimana@epitech.eu",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ElevatedButton(
                        onPressed: () => {},
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF3383CD),
                          minimumSize: const Size(180, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    title("SECURITY", 20),
                    tile(Icons.lock, "Change Password", true),
                    tile(Icons.download, "Download Data", true),
                    tile(Icons.delete, "Delete Data", true),
                    title("PREFERENCES", 0),
                    tile(Icons.public, "Language", true),
                    switchTile("Dark Mode", Icons.dark_mode_outlined, isDark,
                        _onSwitchedDark),
                    switchTile("Only Download via Wi-Fi", Icons.wifi, isWifi,
                        _onSwitchedWifi),
                    title("LOGIN", 0),
                    tile(Icons.logout, "Log Out", false),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Text(
                        'Version 0.1.2',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          // } else {
          //   return const Scaffold(
          //     body: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   );
          // }
        });
  }
}
