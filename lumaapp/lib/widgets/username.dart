// user_manager.dart (یا هر نامی که انتخاب می‌کنید)
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager extends ChangeNotifier {
  String _username = '';

  String get username => _username;

  // متدی برای به‌روزرسانی نام کاربری در تمام برنامه
  void setUsername(String newUsername) {
    if (_username != newUsername) {
      _username = newUsername;
      notifyListeners(); // اطلاع‌رسانی به تمام ویجت‌هایی که گوش می‌دهند
    }
  }

  // بارگذاری اولیه از حافظه محلی
  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username') ?? 'مهمان';
    _username = savedUsername;
    notifyListeners();
  }
}