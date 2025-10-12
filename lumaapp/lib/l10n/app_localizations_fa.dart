// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get enter => 'ورود';

  @override
  String get social => 'به شبکه های اجتماعی ما بپیوندید';

  @override
  String get taiid => 'تایید';

  @override
  String get phonenumber => 'لطفا شماره تلفن همراه خود را وارد کنید.';

  @override
  String get etebar => 'شماره ای که وارد کرده اید نامعتبر است.';

  @override
  String get error1 => 'خطای نامشخصی رخ داده است.';

  @override
  String get error => 'مشکلی در ارتباط با سرور وجود دارد.';

  @override
  String error2(Object statusCode) {
    return 'خطا با کد $statusCode رخ داد.';
  }

  @override
  String get log => 'ورود و ثبت نام';

  @override
  String get phone => 'شماره تلفن همراه';

  @override
  String get code => 'لطفا کد یکبار مصرف خود را وارد کنید.';

  @override
  String get code1 => 'کد یکبار مصرف را وارد کنید';

  @override
  String get ersal => 'ارسال مجدد رمز';

  @override
  String get home => 'خانه';

  @override
  String get username => 'نام کاربری';

  @override
  String get edit => 'ویرایش اطلاعات';

  @override
  String get logout => 'خروج از حساب کاربری';

  @override
  String get delacco => 'حذف حساب کاربری';

  @override
  String get module => 'انواع ماژول ها';

  @override
  String get module1 => 'ماژول کنترل تلویزیون';

  @override
  String get module2 => 'ماژول روشنایی';

  @override
  String get module3 => 'ماژول کولر';

  @override
  String get module4 => 'ماژول وای فای';

  @override
  String get loc => 'محل های قرارگیری ماژول:';

  @override
  String count(Object count) {
    return '$countماژول';
  }

  @override
  String get loc1 => 'سرویس بهداشتی';

  @override
  String get loc2 => 'اتاق خواب';

  @override
  String get loc3 => 'پذیرایی';

  @override
  String get loc4 => 'آشپزخانه';

  @override
  String get error3 => 'اضافه نشد';

  @override
  String get add => 'اضافه کنید...';

  @override
  String get add1 => 'چی میخوای اضافه کنی؟';

  @override
  String get add2 => 'محل قرارگیری محصول';

  @override
  String get add3 => 'نام محل قرارگیری محصول:';

  @override
  String get add4 => 'لطفا محل قرارگیری محصول را وارد کنید.';

  @override
  String get add5 => 'نوع محل قرارگیری محصول:';

  @override
  String get add6 => 'اضافه کن';

  @override
  String get error4 => 'مازول کولر اضافه نشد';

  @override
  String get error5 => 'ماژول روشنایی اضافه نشد';

  @override
  String get lamp => 'محصول ماژول روشنایی (لومسی)';

  @override
  String get lamp1 => 'محل قرارگیری ماژول لومسی:';

  @override
  String get lamp2 => 'شناسه ماژول لومسی:';

  @override
  String get lamp3 => 'لطفا شناسه ماژول لومسی خود را وارد کنید.';

  @override
  String get lamp4 => 'کد فعالسازی ماژول لومسی:';

  @override
  String get lamp5 => 'لطفا کد فعالسازی ماژول لومسی خود را وارد کنید.';

  @override
  String get coler => 'محصول ماژول کولر (لوماکی)';

  @override
  String get coler1 => 'محل قرارگیری ماژول لوماکی:';

  @override
  String get coler2 => 'شناسه ماژول لوماکی:';

  @override
  String get coler3 => 'لطفا شناسه ماژول لوماکی خود را وارد کنید.';

  @override
  String get coler4 => 'کد فعالسازی ماژول لوماکی:';

  @override
  String get coler5 => 'لطفا کد فعالسازی ماژول لوماکی خود را وارد کنید.';

  @override
  String get scan => 'اطلاعات را اسکن کنید!';

  @override
  String get error6 => 'ماژول ها لود نشدند';

  @override
  String get lang => 'زبان برنامه';

  @override
  String get prof => 'پروفایل کاربر';

  @override
  String get update => 'پروفایل آپدیت شد';

  @override
  String get requiredField => 'این فیلد الزامی می باشد';

  @override
  String error10(Object statusCode) {
    return 'خطا در دریافت ماژول‌ها:$statusCode';
  }

  @override
  String tempra(Object location) {
    return 'دمای $location';
  }

  @override
  String get dontexit => 'ماژول کولر موجود نیست.';

  @override
  String currentTemp(Object temp) {
    return ' دمای حال $temp°c';
  }

  @override
  String minTemp(Object cold) {
    return 'سرد ترین دما$cold°c';
  }

  @override
  String maxTemp(Object hot) {
    return 'گرم ترین دما$hot°c';
  }

  @override
  String coolerSetTemp(Object hot) {
    return 'دمای عمل کولر$hot°c';
  }

  @override
  String get error11 => 'بیش از یک ماژول کولر نمی توان به یک محل افزود';

  @override
  String coler6(Object int) {
    return 'کولر$int';
  }

  @override
  String get onoff => 'آنلاین و آفلاین';

  @override
  String get on => 'آنلاین';

  @override
  String get off => 'آفلاین';

  @override
  String get oto => 'اتوماتیک';

  @override
  String get set => 'تنظیمات';

  @override
  String get ton => 'دور تند';

  @override
  String get kon => 'دور کند';

  @override
  String get pom => 'پمپ';

  @override
  String get mod => 'حالت مدیریت';

  @override
  String get rah => 'راه اندازی با دور تند';

  @override
  String get timecontorol => 'کنترل زمانی';

  @override
  String get ontime => 'زمان روشن ماندن:';

  @override
  String get min1 => '15 دقیقه';

  @override
  String get min2 => '30 دقیقه';

  @override
  String get min3 => '45 دقیقه';

  @override
  String get h1 => '1 ساعت';

  @override
  String get h2 => '2 ساعت';

  @override
  String get h3 => '3 ساعت';

  @override
  String get h4 => '4 ساعت';

  @override
  String get h5 => '5 ساعت';

  @override
  String get h6 => '6 ساعت';

  @override
  String get oftime => 'زمان خاموش ماندن:';

  @override
  String get temcon => 'کنترل دمایی';

  @override
  String get hasas => 'دمای حساس:';

  @override
  String get temhash => 'حاشیه دما:';

  @override
  String nor(Object int) {
    return 'روشنایی$int';
  }

  @override
  String get error20 => 'ماژولی برای نمایش وجود ندارد.';

  @override
  String get nemidanam => 'لیست ماژول های روشنایی';

  @override
  String get doncoler => 'ماژول کولر موجود نمی باشد';
}
