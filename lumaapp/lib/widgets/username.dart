import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager extends ChangeNotifier {
  String _username = '';

  String get username => _username;

  void setUsername(String newUsername) {
    if (_username != newUsername) {
      _username = newUsername;
      notifyListeners();
    }
  }

  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username') ?? 'مهمان';
    _username = savedUsername;
    notifyListeners();
  }
}