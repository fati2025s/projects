import 'package:shared_preferences/shared_preferences.dart';

String serverAddress = 'https://server.lumacity.ir';

Future<String?> checkToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

String? token = checkToken() as String?;