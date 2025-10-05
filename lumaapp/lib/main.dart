import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lumaapp/pages/mainPages/home_page.dart';
import 'package:lumaapp/pages/startPages/Welcome_page.dart';
import 'package:lumaapp/widgets/tem.dart';
import 'package:lumaapp/widgets/username.dart';
import 'package:provider/provider.dart';
import 'package:tn_bottom_sheet_navigator/core/entities/tn_bottom_sheet_route.dart';
import 'package:tn_bottom_sheet_navigator/tn_bottom_sheet_navigator.dart';

import 'l10n/app_localizations.dart';
import 'language.dart';
//import 'pages/startPages/welcome_page.dart';
import 'pages/mainPages/add_location.dart';
import 'pages/modulePages/lumakey_module_list_bottom_sheet_page.dart';
import 'pages/modulePages/lumcy_module_list_bottom_sheet_page.dart';

void main() async { // ✅ اضافه کردن async
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ راه‌اندازی و بارگذاری اولیه UserManager
  final userManager = UserManager();
  await userManager.loadInitialData();

  final themeManager = ThemeManager();
  await themeManager.loadTheme();

  TnRouter().setRoutes([
    TnBottomSheetRoute(
      path: 'AddLocationOrProduct',
      // ✅ استفاده از پارامتر mobileNumber
      builder: (context, params) => AddLocationOrProduct(mobileNumber: params['mobileNumber'] as String),
    ),
    TnBottomSheetRoute(
      path: 'LumcyModuleList',
      builder: (context, params) => LumcyModuleList(id: params['id']),
    ),
    TnBottomSheetRoute(
      path: 'LumakeyModuleList',
      builder: (context, params) => LumakeyModuleList(id: params['id']),
    ),
  ]);

  runApp(
    MultiProvider( // ✅ استفاده از MultiProvider
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageManager()),
        ChangeNotifierProvider.value(value: userManager),
        ChangeNotifierProvider.value(value: themeManager),// ✅ تزریق UserManager
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ... (بخش MyApp بدون تغییر)
    final lang = Provider.of<LanguageManager>(context);
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeManager.currentThemeData,
      locale: lang.locale, // زبان فعلی
      supportedLocales: const [
        Locale('fa'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: lang.locale.languageCode == "fa"
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
      home: const WelcomeScreen(),
    );
  }
}