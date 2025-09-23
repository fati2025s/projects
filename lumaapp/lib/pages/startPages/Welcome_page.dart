import 'package:flutter/material.dart';

import 'loginandsignup_1.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        // گرادیانت پس‌زمینه
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000AAB), // آبی تیره
              Colors.black // آبی بسیار تیره
            ],
            stops: [0.4, 0.8],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.058),
                Image.asset(
                  'images/logo/Logo.png', // مسیر نسبی لوگو
                  width: 380,
                  height: 380,
                ),
                //const SizedBox(height: 8),
                SizedBox(height: size.height * 0.035),
                const Text(
                  'خوش آمدید',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                        color: const Color(0xFFFFFFFF),
                        offset: Offset(4,4), // موقعیت سایه (x, y)
                        blurRadius: 20, // میزان تاریکی یا پخش شدن سایه
                         // رنگ سایه (شفافیت 50% مشکی)
                      ),
                    ],
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 55),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          const LoginSignupScreen(),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF39B54A), // رنگ سبز دکمه
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5, // سایه برای برجسته‌سازی
                    ),
                    child: const Text(
                      'ورود',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // متن "به شبکه های اجتماعی ما بپیوندید"
                Text(
                  'به شبکه های اجتماعی ما بپیوندید',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 10),

                // آیکون‌های شبکه‌های اجتماعی
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/social/Instagram.png', width: 40, height: 40),
                    const SizedBox(width: 24),
                    Image.asset('images/social/Telegram.png', width: 40, height: 40),
                    const SizedBox(width: 24),
                    Image.asset('images/social/Gmail.png', width: 40, height: 40),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}