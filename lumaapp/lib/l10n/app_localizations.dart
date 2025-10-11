import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get enter;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'Join our social networks'**
  String get social;

  /// No description provided for @taiid.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get taiid;

  /// No description provided for @phonenumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile phone number.'**
  String get phonenumber;

  /// No description provided for @etebar.
  ///
  /// In en, this message translates to:
  /// **'The number you entered is invalid.'**
  String get etebar;

  /// No description provided for @error1.
  ///
  /// In en, this message translates to:
  /// **'An unspecified error has occurred.'**
  String get error1;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'There is a problem with the server.'**
  String get error;

  /// No description provided for @error2.
  ///
  /// In en, this message translates to:
  /// **'An error occurred with code {statusCode}.'**
  String error2(Object statusCode);

  /// No description provided for @log.
  ///
  /// In en, this message translates to:
  /// **'Login & Signup'**
  String get log;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Mobile phone number'**
  String get phone;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Please enter your one-time code.'**
  String get code;

  /// No description provided for @code1.
  ///
  /// In en, this message translates to:
  /// **'Enter the one-time code.'**
  String get code1;

  /// No description provided for @ersal.
  ///
  /// In en, this message translates to:
  /// **'Resend password'**
  String get ersal;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get username;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit information'**
  String get edit;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @delacco.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delacco;

  /// No description provided for @module.
  ///
  /// In en, this message translates to:
  /// **'Types of modules'**
  String get module;

  /// No description provided for @module1.
  ///
  /// In en, this message translates to:
  /// **'TV control module'**
  String get module1;

  /// No description provided for @module2.
  ///
  /// In en, this message translates to:
  /// **'Lighting module'**
  String get module2;

  /// No description provided for @module3.
  ///
  /// In en, this message translates to:
  /// **'Cooler module'**
  String get module3;

  /// No description provided for @module4.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi module'**
  String get module4;

  /// No description provided for @loc.
  ///
  /// In en, this message translates to:
  /// **'Module locations:'**
  String get loc;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'{count}module'**
  String count(Object count);

  /// No description provided for @loc1.
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get loc1;

  /// No description provided for @loc2.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get loc2;

  /// No description provided for @loc3.
  ///
  /// In en, this message translates to:
  /// **'Hall'**
  String get loc3;

  /// No description provided for @loc4.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get loc4;

  /// No description provided for @error3.
  ///
  /// In en, this message translates to:
  /// **'Failed to add location'**
  String get error3;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add...'**
  String get add;

  /// No description provided for @add1.
  ///
  /// In en, this message translates to:
  /// **'What do you want to add?'**
  String get add1;

  /// No description provided for @add2.
  ///
  /// In en, this message translates to:
  /// **'Product location'**
  String get add2;

  /// No description provided for @add3.
  ///
  /// In en, this message translates to:
  /// **'Product location name:'**
  String get add3;

  /// No description provided for @add4.
  ///
  /// In en, this message translates to:
  /// **'Please enter the location of the product.'**
  String get add4;

  /// No description provided for @add5.
  ///
  /// In en, this message translates to:
  /// **'Product location type:'**
  String get add5;

  /// No description provided for @add6.
  ///
  /// In en, this message translates to:
  /// **'add'**
  String get add6;

  /// No description provided for @error4.
  ///
  /// In en, this message translates to:
  /// **'Failed to add lumakeyModulesss'**
  String get error4;

  /// No description provided for @error5.
  ///
  /// In en, this message translates to:
  /// **'Failed to add lumcyModule'**
  String get error5;

  /// No description provided for @lamp.
  ///
  /// In en, this message translates to:
  /// **'Lighting module product (Lumsi)'**
  String get lamp;

  /// No description provided for @lamp1.
  ///
  /// In en, this message translates to:
  /// **'Location of the Lumsey module:'**
  String get lamp1;

  /// No description provided for @lamp2.
  ///
  /// In en, this message translates to:
  /// **'Lumsey Module ID:'**
  String get lamp2;

  /// No description provided for @lamp3.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Lumsey module ID.'**
  String get lamp3;

  /// No description provided for @lamp4.
  ///
  /// In en, this message translates to:
  /// **'Lumsey module activation code:'**
  String get lamp4;

  /// No description provided for @lamp5.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Lumsey module activation code.'**
  String get lamp5;

  /// No description provided for @coler.
  ///
  /// In en, this message translates to:
  /// **'Cooler module product (Lomaki)'**
  String get coler;

  /// No description provided for @coler1.
  ///
  /// In en, this message translates to:
  /// **'Location of the Lumaki module:'**
  String get coler1;

  /// No description provided for @coler2.
  ///
  /// In en, this message translates to:
  /// **'Lumaki Module ID:'**
  String get coler2;

  /// No description provided for @coler3.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Lumaki module ID.'**
  String get coler3;

  /// No description provided for @coler4.
  ///
  /// In en, this message translates to:
  /// **'Lumaki module activation code:'**
  String get coler4;

  /// No description provided for @coler5.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Lumaki module activation code.'**
  String get coler5;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan the information!'**
  String get scan;

  /// No description provided for @error6.
  ///
  /// In en, this message translates to:
  /// **'Failed to load models'**
  String get error6;

  /// No description provided for @lang.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get lang;

  /// No description provided for @prof.
  ///
  /// In en, this message translates to:
  /// **'User profile'**
  String get prof;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get update;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @error10.
  ///
  /// In en, this message translates to:
  /// **'Error downloading modules:{statusCode}'**
  String error10(Object statusCode);

  /// No description provided for @tempra.
  ///
  /// In en, this message translates to:
  /// **'temperature {location}'**
  String tempra(Object location);

  /// No description provided for @dontexit.
  ///
  /// In en, this message translates to:
  /// **'Cooler module is not available.'**
  String get dontexit;

  /// No description provided for @currentTemp.
  ///
  /// In en, this message translates to:
  /// **'currentTemp{temp}°c'**
  String currentTemp(Object temp);

  /// No description provided for @minTemp.
  ///
  /// In en, this message translates to:
  /// **'minTemp{cold}°c'**
  String minTemp(Object cold);

  /// No description provided for @maxTemp.
  ///
  /// In en, this message translates to:
  /// **'maxTemp{hot}°c'**
  String maxTemp(Object hot);

  /// No description provided for @coolerSetTemp.
  ///
  /// In en, this message translates to:
  /// **'coolerSetTemp{hot}°c'**
  String coolerSetTemp(Object hot);

  /// No description provided for @error11.
  ///
  /// In en, this message translates to:
  /// **'More than one cooler module cannot be added to a location.'**
  String get error11;

  /// No description provided for @coler6.
  ///
  /// In en, this message translates to:
  /// **'cooler{int}'**
  String coler6(Object int);

  /// No description provided for @onoff.
  ///
  /// In en, this message translates to:
  /// **'Online & Offline'**
  String get onoff;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get off;

  /// No description provided for @oto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get oto;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get set;

  /// No description provided for @ton.
  ///
  /// In en, this message translates to:
  /// **'sharp round'**
  String get ton;

  /// No description provided for @kon.
  ///
  /// In en, this message translates to:
  /// **'go away'**
  String get kon;

  /// No description provided for @pom.
  ///
  /// In en, this message translates to:
  /// **'pump'**
  String get pom;

  /// No description provided for @mod.
  ///
  /// In en, this message translates to:
  /// **'Management mode'**
  String get mod;

  /// No description provided for @rah.
  ///
  /// In en, this message translates to:
  /// **'High-speed start-up'**
  String get rah;

  /// No description provided for @timecontorol.
  ///
  /// In en, this message translates to:
  /// **'Time control'**
  String get timecontorol;

  /// No description provided for @ontime.
  ///
  /// In en, this message translates to:
  /// **'Time to stay on:'**
  String get ontime;

  /// No description provided for @min1.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get min1;

  /// No description provided for @min2.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get min2;

  /// No description provided for @min3.
  ///
  /// In en, this message translates to:
  /// **'45 minutes'**
  String get min3;

  /// No description provided for @h1.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get h1;

  /// No description provided for @h2.
  ///
  /// In en, this message translates to:
  /// **'2 hour'**
  String get h2;

  /// No description provided for @h3.
  ///
  /// In en, this message translates to:
  /// **'3 hour'**
  String get h3;

  /// No description provided for @h4.
  ///
  /// In en, this message translates to:
  /// **'4 hour'**
  String get h4;

  /// No description provided for @h5.
  ///
  /// In en, this message translates to:
  /// **'5 hour'**
  String get h5;

  /// No description provided for @h6.
  ///
  /// In en, this message translates to:
  /// **'6 hour'**
  String get h6;

  /// No description provided for @oftime.
  ///
  /// In en, this message translates to:
  /// **'Time to stay on:'**
  String get oftime;

  /// No description provided for @temcon.
  ///
  /// In en, this message translates to:
  /// **'Temperature control'**
  String get temcon;

  /// No description provided for @hasas.
  ///
  /// In en, this message translates to:
  /// **'Sensitive temperature:'**
  String get hasas;

  /// No description provided for @temhash.
  ///
  /// In en, this message translates to:
  /// **'Temperature margin:'**
  String get temhash;

  /// No description provided for @nor.
  ///
  /// In en, this message translates to:
  /// **'lighting{int}'**
  String nor(Object int);

  /// No description provided for @error20.
  ///
  /// In en, this message translates to:
  /// **'There is no module to display.'**
  String get error20;

  /// No description provided for @nemidanam.
  ///
  /// In en, this message translates to:
  /// **'List of lighting modules'**
  String get nemidanam;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fa': return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
