import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceUserImageKey = "USERIMAGE";

  // SETTER

  Future<void> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  Future<void> saveUserNameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  Future<void> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  Future<void> saveUserImageURLSharedPreference(String image) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(sharedPreferenceUserImageKey, image);
  }

  // GETTER

  Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return (preferences.getBool(sharedPreferenceUserLoggedInKey) != null)
        ? preferences.getBool(sharedPreferenceUserLoggedInKey)
        : false;
  }

  Future<String?> getUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  Future<String?> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }

  Future<String?> getUserImageURLSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserImageKey);
  }

  // CLEAR

  void clearSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
