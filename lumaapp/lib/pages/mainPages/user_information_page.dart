import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // پکیج http
import '../../l10n/app_localizations.dart';
import '../../language.dart';
import '../../utils.dart' as utils; // برای آدرس سرور و توکن
import '../../widgets/tem.dart';
import '../../widgets/username.dart';
import 'home_page.dart';

class UserInformationPage extends StatefulWidget {
  //final String mobileNumber;
  final Function(Locale)? onLocaleChange;
  const UserInformationPage({super.key, this.onLocaleChange});

  @override
  State<UserInformationPage> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserInformationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  //bool isLoading = false;

  final TextEditingController _controllerUsername = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;
  String mobile = '';// ✅ متغیر مدیریت لودینگ

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userManager = Provider.of<UserManager>(context, listen: false);
      _controllerUsername.text = userManager.username;
    });
    _loadmobile();
  }

  Future<void> _loadmobile() async{
    final prefs = await SharedPreferences.getInstance();
    mobile = (prefs.getString('mobileNumber') ?? null)!;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
        ),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(0),
        content: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.033),
                child: Text(
                  message,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.043,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.060,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF055712), Color(0xFF80FF92)]),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
                      border: Border.all(color: const Color(0xFF0200AB), width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF0200AB).withOpacity(0.15),
                            offset: const Offset(4, 4),
                            blurRadius: 20,
                            spreadRadius: 10),
                      ]),
                  child: Center(
                    child: Text(
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.taiid,
                      style: TextStyle(
                        color: const Color(0xFFE8BCB9),
                        fontSize: MediaQuery.of(context).size.width * 0.053,
                        fontFamily: "Sans",
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveUserData() async {
    final s = AppLocalizations.of(context)!;
    final userManager = Provider.of<UserManager>(context, listen: false);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_isEditing && _controllerUsername.text != userManager.username) {
      _controllerUsername.text = userManager.username;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${utils.serverAddress}/user/update_profile/'), // 👈 آدرس API به‌روزرسانی
        body: json.encode({
          'username': _controllerUsername.text,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${utils.token}', // 👈 احراز هویت با توکن
        },
      );

      if (response.statusCode == 200) {

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _controllerUsername.text);

        userManager.setUsername(_controllerUsername.text);

        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.update),
            backgroundColor: Colors.green, // سبز برای موفقیت
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      } else {
        _showErrorDialog(s.error2(response.statusCode.toString()));
      }
    } catch (e) {
      // 4. مدیریت خطای اتصال
      _showErrorDialog(s.error);
    }
  }


  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final userManager = Provider.of<UserManager>(context);
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // پس‌زمینه گرادیانت
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? const [const Color(0xFF000AAB), Colors.black] // رنگ‌های تم تیره
                    : const [Color(0xFF3F5FFF), Colors.white],
                stops: const [0.4, 1],
              ),
            ),
          ),

          SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  children: [
                    _buildAppBar(context, s),
                    const SizedBox(height: 40),
                    _buildReadOnlyField(
                      context,
                      s.phone,
                      mobile,
                      Icons.phone_in_talk,
                    ),

                    const SizedBox(height: 30),

                    _buildEditableField(
                      context,
                      _controllerUsername,
                      s.username,
                      Icons.person_outline,
                      _isEditing,
                    ),

                    const SizedBox(height: 10),
                    _buildLanguageChanger(context, s),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations s) {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    final themeManager = Provider.of<ThemeManager>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode
              ?  Colors.white // رنگ‌های تم تیره
              :  Colors.black, size: 28),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        Text(
          s.prof,
          style: TextStyle(
            color: isDarkMode
                ?  Colors.white // رنگ‌های تم تیره
                :  Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            // IconButton(
            //   icon: const Icon(Icons.dark_mode_outlined, color: Colors.white),
            //   onPressed: () {}, // مدیریت تم
            // ),
            IconButton(
              icon: Icon(
                // نمایش آیکون مناسب بر اساس تم فعلی
                themeManager.currentTheme == AppTheme.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: isDarkMode
                    ?  Colors.white
                    :  Colors.black,
              ),
              onPressed: () {
                themeManager.toggleTheme();
              },
            ),
            IconButton(
              icon: Icon(
                _isEditing ? Icons.check : Icons.edit,
                color: isDarkMode
                    ?  Colors.white // رنگ‌های تم تیره
                    :  Colors.black,
              ),
              onPressed: () {
                if (_isEditing) {
                  // اگر در حالت ویرایش هستیم، ذخیره کن
                  _saveUserData();
                } else {
                  // اگر در حالت نمایش هستیم، به حالت ویرایش برو
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditableField(
      BuildContext context,
      TextEditingController controller,
      String labelText,
      IconData icon,
      bool isEnabled,
      ) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.requiredField;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
        ),
        disabledBorder: OutlineInputBorder( // حالت غیرفعال
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
      BuildContext context,
      String labelText,
      String value,
      IconData icon,
      ) {
    return TextFormField(
      initialValue: value,
      enabled: false, // همیشه غیرفعال
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        disabledBorder: OutlineInputBorder( // حالت غیرفعال
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildLanguageChanger(BuildContext context, AppLocalizations s) {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          s.lang,
          style: TextStyle(color: isDarkMode
              ?  Colors.white // رنگ‌های تم تیره
              :  Colors.black, fontSize: 16),
        ),
        IconButton(
          icon: Icon(Icons.lan, color: isDarkMode
              ?  Colors.white // رنگ‌های تم تیره
              :  Colors.black),
          onPressed: () {
            final lang = Provider.of<LanguageManager>(context, listen: false);
            if (lang.locale.languageCode == "fa") {
              lang.setLocale(const Locale("en"));
            } else {
              lang.setLocale(const Locale("fa"));
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }
}