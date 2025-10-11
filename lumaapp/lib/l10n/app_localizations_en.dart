// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get enter => 'start';

  @override
  String get social => 'Join our social networks';

  @override
  String get taiid => 'ok';

  @override
  String get phonenumber => 'Please enter your mobile phone number.';

  @override
  String get etebar => 'The number you entered is invalid.';

  @override
  String get error1 => 'An unspecified error has occurred.';

  @override
  String get error => 'There is a problem with the server.';

  @override
  String error2(Object statusCode) {
    return 'An error occurred with code $statusCode.';
  }

  @override
  String get log => 'Login & Signup';

  @override
  String get phone => 'Mobile phone number';

  @override
  String get code => 'Please enter your one-time code.';

  @override
  String get code1 => 'Enter the one-time code.';

  @override
  String get ersal => 'Resend password';

  @override
  String get home => 'Home';

  @override
  String get username => 'username';

  @override
  String get edit => 'Edit information';

  @override
  String get logout => 'Logout';

  @override
  String get delacco => 'Delete account';

  @override
  String get module => 'Types of modules';

  @override
  String get module1 => 'TV control module';

  @override
  String get module2 => 'Lighting module';

  @override
  String get module3 => 'Cooler module';

  @override
  String get module4 => 'Wi-Fi module';

  @override
  String get loc => 'Module locations:';

  @override
  String count(Object count) {
    return '${count}module';
  }

  @override
  String get loc1 => 'Bathroom';

  @override
  String get loc2 => 'Bedroom';

  @override
  String get loc3 => 'Hall';

  @override
  String get loc4 => 'Kitchen';

  @override
  String get error3 => 'Failed to add location';

  @override
  String get add => 'Add...';

  @override
  String get add1 => 'What do you want to add?';

  @override
  String get add2 => 'Product location';

  @override
  String get add3 => 'Product location name:';

  @override
  String get add4 => 'Please enter the location of the product.';

  @override
  String get add5 => 'Product location type:';

  @override
  String get add6 => 'add';

  @override
  String get error4 => 'Failed to add lumakeyModulesss';

  @override
  String get error5 => 'Failed to add lumcyModule';

  @override
  String get lamp => 'Lighting module product (Lumsi)';

  @override
  String get lamp1 => 'Location of the Lumsey module:';

  @override
  String get lamp2 => 'Lumsey Module ID:';

  @override
  String get lamp3 => 'Please enter your Lumsey module ID.';

  @override
  String get lamp4 => 'Lumsey module activation code:';

  @override
  String get lamp5 => 'Please enter your Lumsey module activation code.';

  @override
  String get coler => 'Cooler module product (Lomaki)';

  @override
  String get coler1 => 'Location of the Lumaki module:';

  @override
  String get coler2 => 'Lumaki Module ID:';

  @override
  String get coler3 => 'Please enter your Lumaki module ID.';

  @override
  String get coler4 => 'Lumaki module activation code:';

  @override
  String get coler5 => 'Please enter your Lumaki module activation code.';

  @override
  String get scan => 'Scan the information!';

  @override
  String get error6 => 'Failed to load models';

  @override
  String get lang => 'language';

  @override
  String get prof => 'User profile';

  @override
  String get update => 'Profile updated successfully';

  @override
  String get requiredField => 'This field is required';

  @override
  String error10(Object statusCode) {
    return 'Error downloading modules:$statusCode';
  }

  @override
  String tempra(Object location) {
    return 'temperature $location';
  }

  @override
  String get dontexit => 'Cooler module is not available.';

  @override
  String currentTemp(Object temp) {
    return 'currentTemp$temp°c';
  }

  @override
  String minTemp(Object cold) {
    return 'minTemp$cold°c';
  }

  @override
  String maxTemp(Object hot) {
    return 'maxTemp$hot°c';
  }

  @override
  String coolerSetTemp(Object hot) {
    return 'coolerSetTemp$hot°c';
  }

  @override
  String get error11 => 'More than one cooler module cannot be added to a location.';

  @override
  String coler6(Object int) {
    return 'cooler$int';
  }

  @override
  String get onoff => 'Online & Offline';

  @override
  String get on => 'Online';

  @override
  String get off => 'Offline';

  @override
  String get oto => 'Automatic';

  @override
  String get set => 'Setting';

  @override
  String get ton => 'sharp round';

  @override
  String get kon => 'go away';

  @override
  String get pom => 'pump';

  @override
  String get mod => 'Management mode';

  @override
  String get rah => 'High-speed start-up';

  @override
  String get timecontorol => 'Time control';

  @override
  String get ontime => 'Time to stay on:';

  @override
  String get min1 => '15 minutes';

  @override
  String get min2 => '30 minutes';

  @override
  String get min3 => '45 minutes';

  @override
  String get h1 => '1 hour';

  @override
  String get h2 => '2 hour';

  @override
  String get h3 => '3 hour';

  @override
  String get h4 => '4 hour';

  @override
  String get h5 => '5 hour';

  @override
  String get h6 => '6 hour';

  @override
  String get oftime => 'Time to stay on:';

  @override
  String get temcon => 'Temperature control';

  @override
  String get hasas => 'Sensitive temperature:';

  @override
  String get temhash => 'Temperature margin:';

  @override
  String nor(Object int) {
    return 'lighting$int';
  }

  @override
  String get error20 => 'There is no module to display.';

  @override
  String get nemidanam => 'List of lighting modules';
}
