import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils.dart' as utils;
import '../mailPages/home_page.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String mobileNumber;

  const OTPVerificationScreen({super.key, required this.mobileNumber});

  @override
  State<OTPVerificationScreen> createState() => _otpverification();
}

class _otpverification extends State<OTPVerificationScreen>{
  //TextEditingController mobileTextEditingController = TextEditingController();
  TextEditingController otpCodeTextEditingController = TextEditingController();
  bool register = false;
  bool otpState = false;
  bool isLoading = false;

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
                      "تایید",
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

  Future<void> _sendOtpCode() async {
    //String mobile = mobileNumber;
    String otpCode = otpCodeTextEditingController.text;

    setState(() {
      isLoading = true;
    });

    if (otpCode.isEmpty) {
      _showErrorDialog("لطفا کد یکبار مصرف خود را وارد کنید.");
      return;
    }

    if (!validateMobile(widget.mobileNumber)) {
      _showErrorDialog("شماره ای که وارد کرده اید نامعتبر است.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse((register)
            ? '${utils.serverAddress}/auth/verify-register-otp/'
            : '${utils.serverAddress}/auth/verify-login-otp/'),
        body: json.encode({
          'mobile': widget.mobileNumber,
          "otp_code": otpCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("ok");
        final Map<String, dynamic> data = json.decode(response.body);

        String token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        utils.token = prefs.getString('auth_token');

        setState(() {
          isLoading = false;
        });

        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0); // شروع انیمیشن از پایین
              const end = Offset.zero; // پایان انیمیشن در جایگاه نهایی
              const curve = Curves.ease; // نوع انیمیشن (نرم)

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      } else {
        print("ok");
        _showErrorDialog('خطای نامشخصی رخ داده است. ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('مشکلی در ارتباط با سرور وجود دارد.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000AAB),
              Colors.black,
            ],
            stops: [0.4, 0.8],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size.height * 0.05),
              const Text(
                'ورود و ثبت نام',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF39B54A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              const Text(
                'کد یکبار مصرف را وارد کنید',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                      (index) => SizedBox(
                    width: 48,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                            color: Color(0xFF39B54A),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height* 0.02),
              const Text(
                ' حداکثر 2 دقیقه بعد ارسال کد می توانید آن را وارد کنید',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: size.height * 0.2),
              Center(
                child: SizedBox(
                  width: size.width * 0.75,
                  child: ElevatedButton(
                    onPressed: () {
                      _sendOtpCode();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF39B54A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'تایید',
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
              // دکمه "ارسال مجدد رمز"
              //در مراحل پیشرفته یه تایمر میزارم در صفحه که بشماره رسید 0 دکمه تایید غیر فعال شه
              Center(
                child: SizedBox(
                  width: size.width * 0.75, // عرض دکمه را ۵۰٪ از عرض صفحه می‌کند
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          OTPVerificationScreen(mobileNumber: widget.mobileNumber),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0); // شروع انیمیشن از پایین
                            const end = Offset.zero; // پایان انیمیشن در جایگاه نهایی
                            const curve = Curves.ease; // نوع انیمیشن (نرم)

                            var tween = Tween(begin: begin, end: end).chain(
                              CurveTween(curve: curve),
                            );

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF39B54A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'ارسال مجدد رمز',
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
    );
  }
}