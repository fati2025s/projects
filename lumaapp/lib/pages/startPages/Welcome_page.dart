import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'loginandsignup_1.dart';

//وارد شد سری های بعد مستقیم بره هوم از اینا تگدره

// شمارنده تایم بزارم و ارسال مجددو وصل کتم

// پروفایل رو بزارم آخرش

// زبان

//تم

// ویرایش اطلاعات

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final Size size = MediaQuery.of(context).size;
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        // گرادیانت پس‌زمینه
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
                Text(
                  s.welcome,
                  style: TextStyle(
                    color: isDarkMode
                        ?  Colors.white // رنگ‌های تم تیره
                        :  Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                  color: isDarkMode
                  ?  Colors.white // رنگ‌های تم تیره
                      :  Color(0xFF39B54A),
                        offset: Offset(4,4), // موقعیت سایه (x, y)
                        blurRadius: 50, // میزان تاریکی یا پخش شدن سایه
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
                      backgroundColor: const Color(0xFF39B54A),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      s.enter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Text(
                  s.social,
                  style: TextStyle(
                    color: isDarkMode
                        ?  Colors.white.withOpacity(0.8) // رنگ‌های تم تیره
                        :  Colors.black.withOpacity(0.8),
                    fontSize: 16,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 10),

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