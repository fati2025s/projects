import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils.dart' as utils;
import 'loginandsignup_2.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginandSignuP();
}

class _LoginandSignuP extends State<LoginSignupScreen> {
  TextEditingController mobileTextEditingController = TextEditingController();
  TextEditingController otpCodeTextEditingController = TextEditingController();
  bool register = false;
  bool otpState = false;
  bool isLoading = false;

  bool validateMobile(String phoneNumber) {
    RegExp regex = RegExp(r'^(?:\+98|98|0)?9\d{9}$');
    return regex.hasMatch(phoneNumber);
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

  Future<void> _sendMobileNumber() async {
    String mobile = mobileTextEditingController.text;

    setState(() {
      isLoading = true;
    });

    if (mobile.isEmpty) {
      _showErrorDialog("لطفا شماره تلفن همراه خود را وارد کنید.");
      return;
    }

    if (!validateMobile(mobile)) {
      _showErrorDialog("شماره ای که وارد کرده اید نامعتبر است.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${utils.serverAddress}/auth/login-register/'),
        body: json.encode({
          'mobile': mobile,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        register = data['register'];

        setState(() {
          isLoading = false;
          otpState = true;
        });

        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const OTPVerificationScreen(mobileNumber: mobileTextEditingController.text),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

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
        _showErrorDialog('خطای نامشخصی رخ داده است.');
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
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF39B54A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height* 0.2),

              const Text(
                'شماره تلفن همراه',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: mobileTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white, fontSize: 24),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF39B54A), width: 2),
                  ),
                ),
              ),
              SizedBox(height: size.height* 0.25),
              Center(
                child: SizedBox(
                  width: size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      _sendMobileNumber();
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
            ],
          ),
        ),
      ),
    );
  }
}