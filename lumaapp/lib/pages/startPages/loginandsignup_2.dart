import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../utils.dart' as utils;
import '../mainPages/home_page.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  bool register;

  OTPVerificationScreen({super.key, required this.mobileNumber,required this.register});

  @override
  State<OTPVerificationScreen> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OTPVerificationScreen> {
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
  List.generate(6, (index) => FocusNode());
  bool isLoading = false;
  late Timer _timer;
  int _remainingTime = 120;

  String get _formattedTime {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // ✅ توقف تایمر هنگام خروج از صفحه
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 120; // بازنشانی زمان برای شروع مجدد
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void _showErrorDialog(String message) {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
        ),
        backgroundColor: isDarkMode
            ?  Colors.white // رنگ‌های تم تیره
            :  Colors.black,
        contentPadding: const EdgeInsets.all(0),
        content: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.033),
                child: Text(
                  message,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.043,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.060,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF055712), Color(0xFF80FF92)]),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.033),
                    border: Border.all(color: const Color(0xFF0200AB), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.taiid,
                      style: const TextStyle(
                        color: Color(0xFFE8BCB9),
                        fontSize: 18,
                        fontFamily: "Sans",
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateMobile(String phoneNumber) {
    RegExp regex = RegExp(r'^(?:\+98|98|0)?9\d{9}$');
    return regex.hasMatch(phoneNumber);
  }

  Future<void> _resendCode() async {
    if (_remainingTime > 0 || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        // API ارسال مجدد را فراخوانی کنید (فرض می‌شود این API همان لاگین/رجیستر قبلی است)
        Uri.parse('${utils.serverAddress}/auth/login-register/'),
        body: json.encode({
          'mobile': widget.mobileNumber,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.ersal)),
        );
      } else {
        _showErrorDialog(AppLocalizations.of(context)!.error1);
      }
    } catch (e) {
      _showErrorDialog(AppLocalizations.of(context)!.error);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _sendOtpCode() async {
    String otpCode = otpControllers.map((c) => c.text).join();
    //final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    if (otpCode.isEmpty || otpCode.length < 6) {
      _showErrorDialog(AppLocalizations.of(context)!.code);
      return;
    }

    if (!validateMobile(widget.mobileNumber)) {
      _showErrorDialog(AppLocalizations.of(context)!.etebar);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse((widget.register)
            ? '${utils.serverAddress}/auth/verify-register-otp/'
            : '${utils.serverAddress}/auth/verify-login-otp/'),
        body: json.encode({
          'mobile': widget.mobileNumber,
          "otp_code": otpCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('auth_token', token);
        utils.token = prefs.getString('auth_token');

        setState(() {
          isLoading = false;
        });

        _timer.cancel();

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      } else {
        _showErrorDialog(
            AppLocalizations.of(context)!.error2(response.statusCode.toString()));
      }
    } catch (e) {
      _showErrorDialog(AppLocalizations.of(context)!.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05),
               Text(
                s.log,
                style: TextStyle(
                    color: isDarkMode
                        ?  Colors.white // رنگ‌های تم تیره
                        :  Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Directionality( // ✅ تنظیم جهت به LTR برای ثابت ماندن ترتیب
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // نوار اول (سمت چپ)
                   Container(
                        width: 40,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4))),
                    const SizedBox(width: 8),
                    // نوار دوم (سمت راست - سبز رنگ)
                    Container(
                        width: 40,
                        height: 8,
                        decoration: BoxDecoration(
                            color: const Color(0xFF39B54A), // ✅ رنگ سبز
                            borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
              const SizedBox(height: 100),
               Text(
               s.code,
                style: TextStyle(
                    color: isDarkMode
                        ?  Colors.white // رنگ‌های تم تیره
                        :  Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 40),

              /// OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                textDirection: TextDirection.ltr,
                children: List.generate(
                  6,
                      (index) => SizedBox(
                    width: 48,
                    child: TextField(
                      controller: otpControllers[index],
                      focusNode: otpFocusNodes[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isDarkMode
                              ?  Colors.white // رنگ‌های تم تیره
                              :  Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Color(0xFF39B54A), width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context)
                              .requestFocus(otpFocusNodes[index + 1]);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _formattedTime,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _remainingTime > 10 ? Colors.white : Colors.red, // رنگ قرمز در ثانیه‌های آخر
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(height: size.height * 0.2),
              Center(
                child: SizedBox(
                  width: size.width * 0.75,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _sendOtpCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF39B54A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBackgroundColor: const Color(0xFF39B54A).withOpacity(0.5),
                    ),
                    child:  Text(
                      s.taiid,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: size.width * 0.75, // عرض دکمه را ۵۰٪ از عرض صفحه می‌کند
                  child: TextButton(
                    onPressed: (_remainingTime > 0 || isLoading) ? null : _resendCode,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF39B54A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBackgroundColor: const Color(0xFF39B54A).withOpacity(0.5),
                    ),
                    child:  Text(
                      s.ersal,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // decoration: TextDecoration.underline,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                // رنگ محو (مشکی با شفافیت پایین)
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  // دایره لودینگ سفید
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
              ],
      ),
    );
  }
}
