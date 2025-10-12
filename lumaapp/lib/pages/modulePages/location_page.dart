import 'dart:ui';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:lumaapp/pages/mainPages/home_page.dart';
import 'package:shimmer/shimmer.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/bottom_sheet_navigator_extension.dart';
import '../../widgets/slider_widget.dart';
import 'package:tn_bottom_sheet_navigator/tn_bottom_sheet_navigator.dart' hide TnBottomSheetSettings;
import 'package:simple_shadow/simple_shadow.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mainPages/add_module.dart';
import '/utils.dart' as utils;
import 'lumakey_module_list_bottom_sheet_page.dart';
class lumakeyModulesss {
  final String slug;
  bool is_turn_pump;
  bool is_turn_motor;
  bool speed_value;
  bool efficient_setup;
  bool is_on_temperature;
  double temperature_value;
  double temperature_margin;
  double sensitive_value;
  bool is_on_timer;
  int on_time;
  int off_time;
  bool is_ap_mode;
  String mode;
  GroupButtonController controller;

  lumakeyModulesss({
    required this.slug,
    required this.is_turn_pump,
    required this.is_turn_motor,
    required this.speed_value,
    required this.efficient_setup,
    required this.is_on_temperature,
    required this.temperature_value,
    required this.temperature_margin,
    required this.sensitive_value,
    required this.is_on_timer,
    required this.on_time,
    required this.off_time,
    required this.is_ap_mode,
    required this.mode,
  }) : controller = GroupButtonController() {
    int? index = _calculateIndex();
    (index != null) ? controller.selectIndex(index) : controller.unselectAll();
  }

  int? _calculateIndex() {
    if (is_turn_pump && is_turn_motor && speed_value) {
      return 0;
    } else if (is_turn_pump && is_turn_motor && !speed_value) {
      return 1;
    } else if (is_turn_pump && !is_turn_motor && !speed_value) {
      return 2;
    } else {
      return null;
    }
  }

  factory lumakeyModulesss.fromJson(Map<String, dynamic> json) {
    return lumakeyModulesss(
        slug: json['slug'],
        is_turn_pump: json['is_turn_pump'],
        is_turn_motor: json['is_turn_motor'],
        speed_value: json['speed_value'],
        efficient_setup: json['efficient_setup'],
        is_on_temperature: json['is_on_temperature'],
        temperature_value: json['temperature_value'],
        temperature_margin: json['temperature_margin'],
        sensitive_value: json['sensitive_value'],
        is_on_timer: json['is_on_timer'],
        on_time: json['on_time'],
        off_time: json['off_time'],
        is_ap_mode: json['is_ap_mode'],
        mode: json['mode']);
  }
}

class LumcyModule {
  final String slug;
  bool? is_turn_lamp_1;
  bool? is_turn_lamp_2;
  bool? is_turn_lamp_3;
  bool? is_turn_lamp_4;
  bool is_ap_mode;
  String mode;

  LumcyModule({
    required this.slug,
    required this.is_turn_lamp_1,
    required this.is_turn_lamp_2,
    required this.is_turn_lamp_3,
    required this.is_turn_lamp_4,
    required this.is_ap_mode,
    required this.mode,
  });

  factory LumcyModule.fromJson(Map<String, dynamic> json) {
    return LumcyModule(
        slug: json['slug'],
        is_turn_lamp_1: json['is_turn_lamp_1'],
        is_turn_lamp_2: json['is_turn_lamp_2'],
        is_turn_lamp_3: json['is_turn_lamp_3'],
        is_turn_lamp_4: json['is_turn_lamp_4'],
        is_ap_mode: json['is_ap_mode'],
        mode: json['mode']);
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // رنگ Placeholder در حالت Shimmer
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

Future<lumakeyModulesss?> fetchlumakeyModulessss(int locationId) async {
  final response = await http.get(
    Uri.parse('${utils.serverAddress}/products/lumakey/generics?location=$locationId'),
    headers: {
      'Authorization': 'Token ${utils.token}',
    },
  );
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data.isNotEmpty) {
      return lumakeyModulesss.fromJson(data.first); // فقط ماژول اول را برمی‌گردانیم
    } else {
      return null;
    }
  } else {
    throw Exception('Failed to load lumakey module');
  }
}

Future<List<LumcyModule>> fetchLumcyModules(int locationId) async {
  final response = await http.get(
    Uri.parse('${utils.serverAddress}/products/lumcy/generics?location=$locationId'),
    headers: {
      'Authorization': 'Token ${utils.token}',
    },
  );
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((json) => LumcyModule.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load lumcyModules');
  }
}

class LocationPage extends StatefulWidget {
  //final String mobileNumber;
  final locationcard;


  const LocationPage({
    required this.locationcard,
    //required this.mobileNumber,
    super.key,
  });

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  //late Future<List<lumakeyModulesss>> futurelumakeyModulessss;
  int _tabIndex = 0;
  late PageController _pageController;
  late List<bool> isSelected = [false, false, false, false];
  bool on_off = true;
  late Future<lumakeyModulesss?> futurelumakeyModulessss;
  late Future<List<LumcyModule>> futureLumcyModules;

  @override
  void initState() {
    super.initState();
    futurelumakeyModulessss = fetchlumakeyModulessss(widget.locationcard.id);
    futureLumcyModules = fetchLumcyModules(widget.locationcard.id);
    _pageController = PageController();
  }

  Future<void> turnOnPumplumakeyModuless(lumakeyModulesss lumakeyModulesss) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'is_turn_pump': true,
        'is_turn_motor': false,
        'speed_value': false,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.is_turn_pump = true;
        lumakeyModulesss.is_turn_motor = false;
        lumakeyModulesss.speed_value = false;
        lumakeyModulesss.controller.selectIndex(2);
      });
    } else {
      throw Exception('Failed to turn on pump lumakeyModulesss');
    }
  }

  Future<void> turnOnMotorlumakeyModuless(lumakeyModulesss lumakeyModulesss) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'is_turn_pump': true,
        'is_turn_motor': true,
        'speed_value': false,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.is_turn_pump = true;
        lumakeyModulesss.is_turn_motor = true;
        lumakeyModulesss.speed_value = false;
        lumakeyModulesss.controller.selectIndex(1);
      });
    } else {
      throw Exception('Failed to turn on Motor lumakeyModulesss');
    }
  }

  Future<void> turnOnSpeedValuelumakeyModuless(lumakeyModulesss lumakeyModulesss) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'is_turn_pump': true,
        'is_turn_motor': true,
        'speed_value': true,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.is_turn_pump = true;
        lumakeyModulesss.is_turn_motor = true;
        lumakeyModulesss.speed_value = true;
        lumakeyModulesss.controller.selectIndex(0);
      });
    } else {
      throw Exception('Failed to turn on speed lumakeyModulesss');
    }
  }

  Future<void> turnOfflumakeyModuless(lumakeyModulesss lumakeyModulesss) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'is_turn_pump': false,
        'is_turn_motor': false,
        'speed_value': false,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.is_turn_pump = false;
        lumakeyModulesss.is_turn_motor = false;
        lumakeyModulesss.speed_value = false;
        lumakeyModulesss.controller.unselectAll();
      });
    } else {
      throw Exception('Failed to turn off lumakeyModulesss');
    }
  }

  Future<void> toggleEfficientSetuplumakeyModuless(lumakeyModulesss lumakeyModulesss) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'efficient_setup': !lumakeyModulesss.efficient_setup,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.efficient_setup = !lumakeyModulesss.efficient_setup;
      });
    } else {
      throw Exception('Failed to toggle efficient_setup lumakeyModulesss');
    }
  }

  Future<void> toggleIsOnTemperaturelumakeyModuless(lumakeyModulesss lumakeyModulesss) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'is_on_temperature': !lumakeyModulesss.is_on_temperature,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.is_on_temperature = !lumakeyModulesss.is_on_temperature;
      });
    } else {
      throw Exception('Failed to toggle is_on_temperature lumakeyModulesss');
    }
  }

  Future<void> toggleTemperatureMarginlumakeyModuless(
      lumakeyModulesss lumakeyModulesss, double temperature_margin) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'temperature_margin': temperature_margin,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.temperature_margin = temperature_margin;
      });
    } else {
      throw Exception('Failed to toggle temperature_margin lumakeyModulesss');
    }
  }

  Future<void> toggleSensitiveValuelumakeyModuless(lumakeyModulesss lumakeyModulesss, double sensitive_value) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'sensitive_value': sensitive_value,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.sensitive_value = sensitive_value;
      });
    } else {
      throw Exception('Failed to toggle sensitive_value lumakeyModulesss');
    }
  }

  Future<void> toggleIsOnTimerlumakeyModuless(lumakeyModulesss lumakeyModulesss) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'is_on_timer': !lumakeyModulesss.is_on_timer,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.is_on_timer = !lumakeyModulesss.is_on_timer;
      });
    } else {
      throw Exception('Failed to toggle is_on_timer lumakeyModulesss');
    }
  }

  Future<void> toggleOnTimelumakeyModuless(lumakeyModulesss lumakeyModulesss, int on_time) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'on_time': on_time,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.on_time = on_time;
      });
    } else {
      throw Exception('Failed to toggle on_time lumakeyModulesss');
    }
  }

  Future<void> toggleOffTimelumakeyModuless(lumakeyModulesss lumakeyModulesss, int off_time) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'off_time': off_time,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.off_time = off_time;
      });
    } else {
      throw Exception('Failed to toggle off_time lumakeyModulesss');
    }
  }

  Future<void> toggleModelumakeyModuless(lumakeyModulesss lumakeyModulesss, String mode) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mode': mode,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.mode = mode;
      });
    } else {
      throw Exception('Failed to toggle mode lumakeyModulesss');
    }
  }

  Future<void> toggleIsApModelumakeyModuless(lumakeyModulesss lumakeyModulesss) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModulesss.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'is_ap_mode': !lumakeyModulesss.is_ap_mode,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModulesss.is_ap_mode = !lumakeyModulesss.is_ap_mode;
      });
    } else {
      throw Exception('Failed to toggle is_ap_mode lumakeyModulesss');
    }
  }

  Future<void> toggleIsTurnLamp1LumcyModule(LumcyModule lumcyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumcy/generics/${lumcyModule.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'is_turn_lamp_1': (lumcyModule.is_turn_lamp_1 != null) ? !lumcyModule.is_turn_lamp_1! : null,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumcyModule.is_turn_lamp_1 =
        (lumcyModule.is_turn_lamp_1 != null) ? !lumcyModule.is_turn_lamp_1! : null;
      });
    } else {
      throw Exception('Failed to toggle is_turn_lamp_1 lumcyModule');
    }
  }

  Future<void> toggleIsTurnLamp2LumcyModule(LumcyModule lumcyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumcy/generics/${lumcyModule.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'is_turn_lamp_2': (lumcyModule.is_turn_lamp_2 != null) ? !lumcyModule.is_turn_lamp_2! : null,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumcyModule.is_turn_lamp_2 =
        (lumcyModule.is_turn_lamp_2 != null) ? !lumcyModule.is_turn_lamp_2! : null;
      });
    } else {
      throw Exception('Failed to toggle is_turn_lamp_2 lumcyModule');
    }
  }

  Future<void> toggleIsTurnLamp3LumcyModule(LumcyModule lumcyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumcy/generics/${lumcyModule.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'is_turn_lamp_3': (lumcyModule.is_turn_lamp_3 != null) ? !lumcyModule.is_turn_lamp_3! : null,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumcyModule.is_turn_lamp_3 =
        (lumcyModule.is_turn_lamp_3 != null) ? !lumcyModule.is_turn_lamp_3! : null;
      });
    } else {
      throw Exception('Failed to toggle is_turn_lamp_3 lumcyModule');
    }
  }

  Future<void> toggleIsTurnLamp4LumcyModule(LumcyModule lumcyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumcy/generics/${lumcyModule.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'is_turn_lamp_4': (lumcyModule.is_turn_lamp_4 != null) ? !lumcyModule.is_turn_lamp_4! : null,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumcyModule.is_turn_lamp_4 =
        (lumcyModule.is_turn_lamp_4 != null) ? !lumcyModule.is_turn_lamp_4! : null;
      });
    } else {
      throw Exception('Failed to toggle is_turn_lamp_4 lumcyModule');
    }
  }

  Future<void> toggleModeLumcyModule(LumcyModule lumcyModule, String mode) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumcy/generics/${lumcyModule.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mode': mode,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumcyModule.mode = mode;
      });
    } else {
      throw Exception('Failed to toggle mode lumcyModule');
    }
  }

  Future<void> toggleIsApModeLumcyModule(LumcyModule lumcyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumcy/generics/${lumcyModule.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'is_ap_mode': !lumcyModule.is_ap_mode,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumcyModule.is_ap_mode = !lumcyModule.is_ap_mode;
      });
    } else {
      throw Exception('Failed to toggle is_ap_mode lumcyModule');
    }
  }

  Widget _buildShimmerLine(Size size, bool isDarkMode, double widthFactor, double height) {
    return Container(
      width: size.width * widthFactor,
      height: height,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white24 : Colors.grey[300],
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  Widget _buildModuleDetailsShimmer(Size size, bool isDarkMode) {
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[600]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.042),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder برای هدر (دما یا لوکیشن)
              Padding(
                padding: EdgeInsets.only(right: size.width * 0.03),
                child: _buildShimmerLine(size, isDarkMode, 0.50, 20.0),
              ),
              SizedBox(height: size.height * 0.05),

              // Placeholder برای ناحیه اسلایدر
              Center(
                child: Container(
                  height: 80, // ارتفاع تقریبی اسلایدر
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white12 : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),

              // Placeholder برای باکس کنترل‌های اصلی
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.05,
                  horizontal: size.width * 0.010,
                ),
                child: Container(
                  height: size.height * 0.4, // ارتفاع تقریبی کانتینر کنترلی
                  width: size.width * 0.95,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white12 : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.width * 0.063,
                      horizontal: size.width * 0.063,
                    ),
                    child: Column(
                      children: [
                        // Placeholder برای متن Slug
                        _buildShimmerLine(size, isDarkMode, 0.40, 14.0),
                        SizedBox(height: size.height * 0.015),

                        // Placeholder برای ردیف اول دکمه‌ها (NF/N)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildShimmerLine(size, isDarkMode, 0.35, size.height * 0.050),
                            _buildShimmerLine(size, isDarkMode, 0.35, size.height * 0.050),
                          ],
                        ),
                        SizedBox(height: size.height * 0.010),

                        // Placeholder برای ردیف دوم دکمه‌ها (AUTO/F)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildShimmerLine(size, isDarkMode, 0.35, size.height * 0.050),
                            _buildShimmerLine(size, isDarkMode, 0.35, size.height * 0.050),
                          ],
                        ),
                      ],
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


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final currentTheme = Theme.of(context);
    final s = AppLocalizations.of(context)!;
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: size.width,
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
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(height: size.height * 0.060),
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.063),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDarkMode
                            ?  Colors.white // رنگ‌های تم تیره
                            :  Colors.black,
                        size: 28,

                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => HomePage(),
                        );
                      },
                    ),
                  ),
                  Text(
                    widget.locationcard.name,
                    style:  TextStyle(
                      color: isDarkMode
                          ?  Colors.white // رنگ‌های تم تیره
                          :  Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                          Icons.add,
                          color: isDarkMode
                              ?  Colors.white
                              :  Colors.black,
                          size: 28
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddProduct(Locationcard: widget.locationcard),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.022),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.042),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.029),
                        Expanded(
                          child: FutureBuilder<lumakeyModulesss?>(
                            future: futurelumakeyModulessss,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return _buildModuleDetailsShimmer(size, isDarkMode);
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        AppLocalizations.of(context)!.error10(snapshot.error.toString()),
                                    style: TextStyle(color: Colors.red)
                                    )
                                );
                              }
                              if (snapshot.data == null) {
                                return SingleChildScrollView(
                                  //padding: EdgeInsets.only(top: size.height * 0), // اضافه کردن فاصله از بالا
                                  child: Column(
                                    children: [// برای مرکز قرارگیری افقی
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 120),
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ?const Color(0xFFBDFFBD).withOpacity(0.8)
                                            :const Color(0xFF21DB2A).withOpacity(0.80),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(0.5),
                                            offset: const Offset(0, 0),
                                            blurRadius: 20,
                                          )
                                        ],
                                      ),
                                      child: Text(
                                        s.doncoler,
                                        style: TextStyle(color: Color(0xFF1D1A39), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                      SizedBox(height: 30),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: isDarkMode
                                                ?const Color(0xFFBDFFBD).withOpacity(0.8)
                                                :const Color(0xFF21DB2A).withOpacity(0.80),
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green.withOpacity(0.15),
                                                offset: const Offset(0, -4),
                                                blurRadius: 20,
                                                spreadRadius: 10,
                                              )
                                            ]
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(top: size.height * 0.030),
                                          child: Column(
                                            children: [
                                              // List Title (Fixed height, non-scrollable part)
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.063),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  textDirection: TextDirection.rtl,
                                                  children: [
                                                    Text(
                                                      s.nemidanam,
                                                      textDirection: TextDirection.rtl,
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(
                                                        color: Color(0xFF1D1A39),
                                                        fontFamily: "Sans",
                                                        fontSize: 18, // Fixed size for better readability
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: size.height * 0.005),

                                              // Expanded FutureBuilder + ListView (The scrollable part)
                                              FutureBuilder<List<LumcyModule>>(
                                                  future: futureLumcyModules,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return const Center(child: CircularProgressIndicator(color: Color(0xFF030585)));
                                                    } else if (snapshot.hasError) {
                                                      return Center(child: Text('Error: ${snapshot.error}'));
                                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                      return Center(child: Text(s.error20));
                                                    }
                                                    final lumcyModules = snapshot.data!;
                                                    // The ListView.builder is now correctly constrained by Expanded
                                                    return ListView.builder(
                                                      shrinkWrap: true, // فقط به اندازه محتوای خود فضا اشغال کند
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: lumcyModules.length,
                                                      itemBuilder: (context, index) {
                                                        final lumcyModule = lumcyModules[index];
                                                        return Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            vertical: size.height * 0.015,
                                                            horizontal: size.width * 0.05,
                                                          ),
                                                          child: Container(
                                                            width: size.width * 0.1,
                                                            decoration: BoxDecoration(
                                                              color: isDarkMode
                                                                  ?const Color(0xFFBDFFBD).withOpacity(0.8)
                                                                  :const Color(0xFF21DB2A).withOpacity(0.80),
                                                              borderRadius: BorderRadius.circular(20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: const Color(0xFF030585).withOpacity(0.8),
                                                                  offset: const Offset(0, 0),
                                                                  blurRadius: 20,
                                                                )
                                                              ],
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                vertical: size.width * 0.063,
                                                                horizontal: size.width * 0.063,
                                                              ),
                                                              child: Row(
                                                                textDirection: TextDirection.ltr,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    textDirection: TextDirection.ltr,
                                                                    children: [
                                                                      Text(
                                                                        s.nor(lumcyModule.slug.replaceAll('0', '').padRight(2, '#')),
                                                                        textDirection: TextDirection.rtl,
                                                                        textAlign: TextAlign.right,
                                                                        style: TextStyle(
                                                                          color: const Color(0xFF1D1A39),
                                                                          fontFamily: "Sans",
                                                                          fontSize: size.width * 0.029,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(width: size.width * 0.03),
                                                                  // --- Module Controls (Left Side) ---
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Opacity(
                                                                        opacity: (lumcyModule.mode == 'NF') ? 1 : 0.75,
                                                                        child: GestureDetector(
                                                                          child: Container(
                                                                            width: size.width * 0.27,
                                                                            height: size.height * 0.05,
                                                                            decoration: BoxDecoration(
                                                                              gradient: const LinearGradient(
                                                                                  colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                              borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                              border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.center,
                                                                                s.onoff,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: size.width * 0.025,
                                                                                  fontFamily: "Sans",
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap: () => (lumcyModule.mode != 'NF')
                                                                              ? toggleModeLumcyModule(lumcyModule, 'NF')
                                                                              : null,
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: size.height * 0.010),
                                                                      Opacity(
                                                                        opacity: (lumcyModule.mode == 'N') ? 1 : 0.75,
                                                                        child: GestureDetector(
                                                                          child: Container(
                                                                            width: size.width * 0.27,
                                                                            height: size.height * 0.05,
                                                                            decoration: BoxDecoration(
                                                                              gradient: const LinearGradient(
                                                                                  colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                              borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                              border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.center,
                                                                                s.on,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: size.width * 0.025,
                                                                                  fontFamily: "Sans",
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap: () => (lumcyModule.mode != 'N')
                                                                              ? toggleModeLumcyModule(lumcyModule, 'N')
                                                                              : null,
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: size.height * 0.010),
                                                                      Opacity(
                                                                        opacity: (lumcyModule.mode == 'F') ? 1 : 0.75,
                                                                        child: GestureDetector(
                                                                          child: Container(
                                                                            width: size.width * 0.27,
                                                                            height: size.height * 0.05,
                                                                            decoration: BoxDecoration(
                                                                              gradient: const LinearGradient(
                                                                                  colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                              borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                              border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.center,
                                                                                s.off,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: size.width * 0.025,
                                                                                  fontFamily: "Sans",
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap: () => (lumcyModule.mode != 'F')
                                                                              ? toggleModeLumcyModule(lumcyModule, 'F')
                                                                              : null,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  // --- Lamp Grid or AP Mode Button (Right Side) ---
                                                                  (lumcyModule.mode != 'F')
                                                                      ? SizedBox(
                                                                    // Dynamically adjust height based on number of lamps
                                                                    height: (lumcyModule.is_turn_lamp_3 == null && lumcyModule.is_turn_lamp_4 == null)
                                                                        ? size.width * 0.180 // Smaller height for 2 lamps
                                                                        : size.width * 0.300, // Full height for 3/4 lamps
                                                                    width: size.width * 0.250,
                                                                    child: GridView.count(
                                                                      crossAxisCount: 2,
                                                                      mainAxisSpacing: 10,
                                                                      crossAxisSpacing: 10,
                                                                      physics: const NeverScrollableScrollPhysics(), // Important to prevent inner scrolling
                                                                      children: [
                                                                        if (lumcyModule.is_turn_lamp_1 != null)
                                                                          GestureDetector(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color((lumcyModule.is_turn_lamp_1!)
                                                                                      ? 0xFF48A23D
                                                                                      : 0xFFE72535)
                                                                                      .withOpacity(0.4),
                                                                                  offset: const Offset(0, 0),
                                                                                  blurRadius: 20,
                                                                                  spreadRadius: 2,
                                                                                ),
                                                                              ]),
                                                                              child: Image(
                                                                                  image: AssetImage((lumcyModule.is_turn_lamp_1!)
                                                                                      ? 'images/modules/TurnOn.png'
                                                                                      : 'images/modules/Shutdown.png')),
                                                                            ),
                                                                            onTap: () => toggleIsTurnLamp1LumcyModule(lumcyModule),
                                                                          ),
                                                                        if (lumcyModule.is_turn_lamp_2 != null)
                                                                          GestureDetector(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color((lumcyModule.is_turn_lamp_2!)
                                                                                      ? 0xFF48A23D
                                                                                      : 0xFFE72535)
                                                                                      .withOpacity(0.4),
                                                                                  offset: const Offset(0, 0),
                                                                                  blurRadius: 20,
                                                                                  spreadRadius: 2,
                                                                                ),
                                                                              ]),
                                                                              child: Image(
                                                                                  image: AssetImage((lumcyModule.is_turn_lamp_2!)
                                                                                      ? 'images/modules/TurnOn.png'
                                                                                      : 'images/modules/Shutdown.png')),
                                                                            ),
                                                                            onTap: () => toggleIsTurnLamp2LumcyModule(lumcyModule),
                                                                          ),
                                                                        if (lumcyModule.is_turn_lamp_3 != null)
                                                                          GestureDetector(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color((lumcyModule.is_turn_lamp_3!)
                                                                                      ? 0xFF48A23D
                                                                                      : 0xFFE72535)
                                                                                      .withOpacity(0.4),
                                                                                  offset: const Offset(0, 0),
                                                                                  blurRadius: 20,
                                                                                  spreadRadius: 2,
                                                                                ),
                                                                              ]),
                                                                              child: Image(
                                                                                  image: AssetImage((lumcyModule.is_turn_lamp_3!)
                                                                                      ? 'images/modules/TurnOn.png'
                                                                                      : 'images/modules/Shutdown.png')),
                                                                            ),
                                                                            onTap: () => toggleIsTurnLamp3LumcyModule(lumcyModule),
                                                                          ),
                                                                        if (lumcyModule.is_turn_lamp_4 != null)
                                                                          GestureDetector(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color((lumcyModule.is_turn_lamp_4!)
                                                                                      ? 0xFF48A23D
                                                                                      : 0xFFE72535)
                                                                                      .withOpacity(0.4),
                                                                                  offset: const Offset(0, 0),
                                                                                  blurRadius: 20,
                                                                                  spreadRadius: 2,
                                                                                ),
                                                                              ]),
                                                                              child: Image(
                                                                                  image: AssetImage((lumcyModule.is_turn_lamp_4!)
                                                                                      ? 'images/modules/TurnOn.png'
                                                                                      : 'images/modules/Shutdown.png')),
                                                                            ),
                                                                            onTap: () => toggleIsTurnLamp4LumcyModule(lumcyModule),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                      : SizedBox(
                                                                    height: size.width * 0.300,
                                                                    width: size.width * 0.300,
                                                                    child: Center(
                                                                      child: Opacity(
                                                                        opacity: (lumcyModule.is_ap_mode) ? 1 : 0.75,
                                                                        child: GestureDetector(
                                                                          onTap: () => toggleIsApModeLumcyModule(lumcyModule),
                                                                          child: Container(
                                                                            width: size.width * 0.250,
                                                                            height: size.height * 0.040,
                                                                            decoration: BoxDecoration(
                                                                              gradient: const LinearGradient(
                                                                                  colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                              borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                              border: Border.all(
                                                                                  color: const Color(0xFF215426), width: 1),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                s.mod,
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: size.width * 0.025,
                                                                                  fontFamily: "Sans",
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                );
                              }
                                  final lumakeyModuless = snapshot.data!;
                                  return SingleChildScrollView(
                                   child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          if(widget.locationcard.location == "Kitchen")
                                          Text(
                                            AppLocalizations.of(context)!.tempra(AppLocalizations.of(context)!.loc4),
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Sans",
                                              fontSize: size.width * 0.050,
                                              shadows: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  offset: const Offset(4, 4),
                                                  blurRadius: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if(widget.locationcard.location == "Hall")
                                            Text(
                                              AppLocalizations.of(context)!.tempra(AppLocalizations.of(context)!.loc3),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Sans",
                                                fontSize: size.width * 0.050,
                                                shadows: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3),
                                                    offset: const Offset(4, 4),
                                                    blurRadius: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if(widget.locationcard.location == "BedRoon")
                                            Text(
                                              AppLocalizations.of(context)!.tempra(AppLocalizations.of(context)!.loc2),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Sans",
                                                fontSize: size.width * 0.050,
                                                shadows: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3),
                                                    offset: const Offset(4, 4),
                                                    blurRadius: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if(widget.locationcard.location == "BathRoom")
                                            Text(
                                              AppLocalizations.of(context)!.tempra(AppLocalizations.of(context)!.loc1),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Sans",
                                                fontSize: size.width * 0.050,
                                                shadows: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3),
                                                    offset: const Offset(4, 4),
                                                    blurRadius: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: size.height* 0.05),
                                        SliderWidget(
                                          initialVal: lumakeyModuless.temperature_value,
                                        ),
                                      SizedBox(height: size.height* 0.01),
                                      Container(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: size.height * 0),
                                          child: Column(
                                            children: [
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          vertical: size.height * 0.05,
                                                          horizontal: size.width * 0.010,
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                          color: isDarkMode
                                                              ?const Color(0xFFBDFFBD).withOpacity(0.8)
                                                              :const Color(0xFF21DB2A).withOpacity(0.80),
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                          BoxShadow(
                                                          color: Colors.green.withOpacity(0.5),
                                                          offset: const Offset(0, 0),
                                                          blurRadius: 20,
                                                          )
                                                          ],
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              vertical: size.width * 0.063,
                                                              horizontal: size.width * 0.063,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  textDirection: TextDirection.rtl,
                                                                  children: [
                                                                    Text(
                                                                      s.coler6(lumakeyModuless.slug.replaceAll('0', '').padRight(2, '#')),
                                                                      textDirection: TextDirection.rtl,
                                                                      textAlign: TextAlign.right,
                                                                      style: TextStyle(
                                                                        color: const Color(0xFF1D1A39),
                                                                        fontFamily: "Sans",
                                                                        fontSize: size.width * 0.029,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: size.height * 0.015),
                                                                Row(
                                                                  textDirection: TextDirection.rtl,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Opacity(
                                                                      opacity: (lumakeyModuless.mode == 'NF') ? 1 : 0.75,
                                                                      child: GestureDetector(
                                                                        child: Container(
                                                                          width: size.width * 0.35,
                                                                          height: size.height * 0.050,
                                                                          decoration: BoxDecoration(
                                                                            gradient: const LinearGradient(
                                                                                colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                            borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                            border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              textDirection: TextDirection.rtl,
                                                                              textAlign: TextAlign.center,
                                                                              s.onoff,
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: size.width * 0.025,
                                                                                fontFamily: "Sans",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onTap: () => (lumakeyModuless.mode != 'NF')
                                                                            ? toggleModelumakeyModuless(lumakeyModuless, 'NF')
                                                                            : null,
                                                                      ),
                                                                    ),
                                                                    Opacity(
                                                                      opacity: (lumakeyModuless.mode == 'N') ? 1 : 0.75,
                                                                      child: GestureDetector(
                                                                        child: Container(
                                                                          width: size.width * 0.35,
                                                                          height: size.height * 0.050,
                                                                          decoration: BoxDecoration(
                                                                            gradient: const LinearGradient(
                                                                                colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                            borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                            border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              textDirection: TextDirection.rtl,
                                                                              textAlign: TextAlign.center,
                                                                              s.on,
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: size.width * 0.025,
                                                                                fontFamily: "Sans",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onTap: () => (lumakeyModuless.mode != 'N')
                                                                            ? toggleModelumakeyModuless(lumakeyModuless, 'N')
                                                                            : null,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(height: size.height * 0.010),
                                                                Row(
                                                                  textDirection: TextDirection.rtl,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Opacity(
                                                                      opacity: (lumakeyModuless.mode == 'AUTO') ? 1 : 0.75,
                                                                      child: GestureDetector(
                                                                        child: Container(
                                                                          width: size.width * 0.35,
                                                                          height: size.height * 0.050,
                                                                          decoration: BoxDecoration(
                                                                            gradient: const LinearGradient(
                                                                                colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                            borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                            border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              textDirection: TextDirection.rtl,
                                                                              textAlign: TextAlign.center,
                                                                              s.oto,
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: size.width * 0.025,
                                                                                fontFamily: "Sans",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onTap: () => (lumakeyModuless.mode != 'AUTO')
                                                                            ? toggleModelumakeyModuless(lumakeyModuless, 'AUTO')
                                                                            : null,
                                                                      ),
                                                                    ),
                                                                    Opacity(
                                                                      opacity: (lumakeyModuless.mode == 'F') ? 1 : 0.75,
                                                                      child: GestureDetector(
                                                                        child: Container(
                                                                          width: size.width * 0.35,
                                                                          height: size.height * 0.050,
                                                                          decoration: BoxDecoration(
                                                                            gradient: const LinearGradient(
                                                                                colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                            borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                            border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              textDirection: TextDirection.rtl,
                                                                              textAlign: TextAlign.center,
                                                                              s.off,
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: size.width * 0.025,
                                                                                fontFamily: "Sans",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onTap: () => (lumakeyModuless.mode != 'F')
                                                                            ? toggleModelumakeyModuless(lumakeyModuless, 'F')
                                                                            : null,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: size.height * 0.020),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  textDirection: TextDirection.rtl,
                                                                  children: [
                                                                    Text(
                                                                      s.set,
                                                                      textDirection: TextDirection.rtl,
                                                                      textAlign: TextAlign.right,
                                                                      style: TextStyle(
                                                                        color: const Color(0xFF1D1A39),
                                                                        fontFamily: "Sans",
                                                                        fontSize: size.width * 0.029,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: size.height * 0.015),
                                                                (lumakeyModuless.mode != 'F')
                                                                    ? GroupButton(
                                                                  isRadio: true,
                                                                  onSelected: (value, index, isSelected) {
                                                                    isSelected
                                                                        ? index == 2
                                                                        ? turnOnPumplumakeyModuless(lumakeyModuless)
                                                                        : index == 1
                                                                        ? turnOnMotorlumakeyModuless(lumakeyModuless)
                                                                        : turnOnSpeedValuelumakeyModuless(lumakeyModuless)
                                                                        : turnOfflumakeyModuless(lumakeyModuless);
                                                                  },
                                                                  controller: lumakeyModuless.controller,
                                                                  enableDeselect: true,
                                                                  options: GroupButtonOptions(
                                                                    selectedTextStyle: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: size.width * 0.025,
                                                                      fontFamily: "Sans",
                                                                    ),
                                                                    selectedColor: const Color(0xFF1D1A39),
                                                                    unselectedShadow: const [],
                                                                    unselectedColor: const Color(0xFF1D1A39).withOpacity(0.75),
                                                                    unselectedTextStyle: TextStyle(
                                                                      color: Colors.white.withOpacity(0.75),
                                                                      fontSize: size.width * 0.025,
                                                                      fontFamily: "Sans",
                                                                    ),
                                                                    selectedBorderColor: const Color(0xFF215426),
                                                                    unselectedBorderColor:
                                                                    const Color(0xFF215426).withOpacity(0.75),
                                                                    borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                    spacing: size.width * 0.021,
                                                                    groupingType: GroupingType.wrap,
                                                                    direction: Axis.horizontal,
                                                                    buttonHeight: size.height * 0.040,
                                                                    buttonWidth: size.width * 0.21,
                                                                    mainGroupAlignment: MainGroupAlignment.start,
                                                                    crossGroupAlignment: CrossGroupAlignment.start,
                                                                    groupRunAlignment: GroupRunAlignment.start,
                                                                    textAlign: TextAlign.center,
                                                                    textPadding: EdgeInsets.zero,
                                                                    alignment: Alignment.center,
                                                                    elevation: 0,
                                                                  ),
                                                                  buttons: [
                                                                    s.ton,
                                                                    s.kon,
                                                                    if (lumakeyModuless.mode != 'AUTO') s.pom,
                                                                  ],
                                                                )
                                                                    : Opacity(
                                                                  opacity: (lumakeyModuless.is_ap_mode) ? 1 : 0.75,
                                                                  child: GestureDetector(
                                                                    child: Container(
                                                                      width: size.width * 0.35,
                                                                      height: size.height * 0.050,
                                                                      decoration: BoxDecoration(
                                                                        gradient: const LinearGradient(
                                                                            colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                        borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                        border:
                                                                        Border.all(color: const Color(0xFF215426), width: 1),
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          textDirection: TextDirection.rtl,
                                                                          textAlign: TextAlign.center,
                                                                          s.mod,
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: size.width * 0.025,
                                                                            fontFamily: "Sans",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: () => toggleIsApModelumakeyModuless(lumakeyModuless),
                                                                  ),
                                                                ),
                                                                SizedBox(height: size.height * 0.015),
                                                                if (lumakeyModuless.mode != 'F')
                                                                  Opacity(
                                                                    opacity: (lumakeyModuless.efficient_setup) ? 1 : 0.75,
                                                                    child: GestureDetector(
                                                                      child: Container(
                                                                        width: size.width * 0.35,
                                                                        height: size.height * 0.040,
                                                                        decoration: BoxDecoration(
                                                                          gradient: const LinearGradient(
                                                                              colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                          borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                          border:
                                                                          Border.all(color: const Color(0xFF215426), width: 1),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            textDirection: TextDirection.rtl,
                                                                            textAlign: TextAlign.center,
                                                                            s.rah,
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: size.width * 0.025,
                                                                              fontFamily: "Sans",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap: () => toggleEfficientSetuplumakeyModuless(lumakeyModuless),
                                                                    ),
                                                                  ),
                                                                SizedBox(height: size.height * 0.015),
                                                                if (lumakeyModuless.mode == 'AUTO')
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    textDirection: TextDirection.rtl,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            textDirection: TextDirection.rtl,
                                                                            children: [
                                                                              Text(
                                                                                s.timecontorol,
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(
                                                                                  color: const Color(0xFF1D1A39),
                                                                                  fontFamily: "Sans",
                                                                                  fontSize: size.width * 0.029,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: size.width * 0.021),
                                                                              GestureDetector(
                                                                                child: SimpleShadow(
                                                                                  color: isDarkMode
                                                                                      ?const Color(0xFF030585)
                                                                                      :const Color(0xFF272AF5),
                                                                                  opacity: 0.5,
                                                                                  offset: const Offset(4, 4),
                                                                                  sigma: 2,
                                                                                  child: Image(
                                                                                    image: AssetImage((lumakeyModuless.is_on_timer)
                                                                                        ? 'images/modules/ToggleOn.png'
                                                                                        : 'images/modules/ToggleOff.png'),
                                                                                    width: size.width * 0.083,
                                                                                    height: size.width * 0.083,
                                                                                  ),
                                                                                ),
                                                                                onTap: () => toggleIsOnTimerlumakeyModuless(lumakeyModuless),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: size.height * 0.010),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            textDirection: TextDirection.rtl,
                                                                            children: [
                                                                              Text(
                                                                                s.ontime,
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(
                                                                                  color: const Color(0xFF1D1A39),
                                                                                  fontFamily: "Sans",
                                                                                  fontSize: size.width * 0.025,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: size.width * 0.021),
                                                                              Container(
                                                                                width: size.width * 0.15,
                                                                                height: size.height * 0.030,
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(0xFFD9D9D9),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                        color: const Color(0xFF000000).withOpacity(0.5),
                                                                                        offset: const Offset(4, 4),
                                                                                        blurRadius: 4,
                                                                                        spreadRadius: 0),
                                                                                  ],
                                                                                ),
                                                                                child: DropdownButton<int>(
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF000000),
                                                                                    fontFamily: "Sans",
                                                                                    fontSize: size.width * 0.020,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  padding: EdgeInsets.only(left: size.width * 0.010),
                                                                                  iconSize: 20,
                                                                                  menuMaxHeight: size.height * 0.246,
                                                                                  menuWidth: size.width * 0.167,
                                                                                  dropdownColor: const Color(0xFFD9D9D9),
                                                                                  iconDisabledColor: const Color(0xFF3F5FFF),
                                                                                  iconEnabledColor: const Color(0xFF3F5FFF),
                                                                                  isExpanded: true,
                                                                                  value: lumakeyModuless.on_time,
                                                                                  items: [
                                                                                    DropdownMenuItem(
                                                                                      value: 15,
                                                                                      child: Text(
                                                                                        s.min1,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 30,
                                                                                      child: Text(
                                                                                        s.min2,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 45,
                                                                                      child: Text(
                                                                                        s.min3,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 1 * 60,
                                                                                      child: Text(
                                                                                        s.h1,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 2 * 60,
                                                                                      child: Text(
                                                                                        s.h2,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 3 * 60,
                                                                                      child: Text(
                                                                                        s.h3,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 4 * 60,
                                                                                      child: Text(
                                                                                        s.h4,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 5 * 60,
                                                                                      child: Text(
                                                                                        s.h5,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 6 * 60,
                                                                                      child: Text(
                                                                                        s.h6,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                  underline: const Text(''),
                                                                                  onChanged: (lumakeyModuless.is_on_timer)
                                                                                      ? (newValue) {
                                                                                    if (newValue != null) {
                                                                                      toggleOnTimelumakeyModuless(
                                                                                          lumakeyModuless, newValue);
                                                                                    }
                                                                                  }
                                                                                      : null,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: size.height * 0.010),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            textDirection: TextDirection.rtl,
                                                                            children: [
                                                                              Text(
                                                                                s.oftime,
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(
                                                                                  color: const Color(0xFF1D1A39),
                                                                                  fontFamily: "Sans",
                                                                                  fontSize: size.width * 0.025,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: size.width * 0.021),
                                                                              Container(
                                                                                width: size.width * 0.15,
                                                                                height: size.height * 0.030,
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(0xFFD9D9D9),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                        color: const Color(0xFF000000).withOpacity(0.5),
                                                                                        offset: const Offset(4, 4),
                                                                                        blurRadius: 4,
                                                                                        spreadRadius: 0),
                                                                                  ],
                                                                                ),
                                                                                child: DropdownButton<int>(
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF000000),
                                                                                    fontFamily: "Sans",
                                                                                    fontSize: size.width * 0.020,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  padding: EdgeInsets.only(left: size.width * 0.010),
                                                                                  iconSize: 20,
                                                                                  menuMaxHeight: size.height * 0.246,
                                                                                  menuWidth: size.width * 0.167,
                                                                                  dropdownColor: const Color(0xFFD9D9D9),
                                                                                  iconDisabledColor: const Color(0xFF3F5FFF),
                                                                                  iconEnabledColor: const Color(0xFF3F5FFF),
                                                                                  isExpanded: true,
                                                                                  value: lumakeyModuless.off_time,
                                                                                  items: [
                                                                                    DropdownMenuItem(
                                                                                      value: 15,
                                                                                      child: Text(
                                                                                        s.min1,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 30,
                                                                                      child: Text(
                                                                                        s.min2,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 45,
                                                                                      child: Text(
                                                                                        s.min3,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 1 * 60,
                                                                                      child: Text(
                                                                                        s.h1,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 2 * 60,
                                                                                      child: Text(
                                                                                        s.h2,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 3 * 60,
                                                                                      child: Text(
                                                                                        s.h3,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 4 * 60,
                                                                                      child: Text(
                                                                                        s.h4,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 5 * 60,
                                                                                      child: Text(
                                                                                        s.h5,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    DropdownMenuItem(
                                                                                      value: 6 * 60,
                                                                                      child: Text(
                                                                                        s.h6,
                                                                                        textDirection: TextDirection.rtl,
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                  underline: const Text(''),
                                                                                  onChanged: (lumakeyModuless.is_on_timer)
                                                                                      ? (newValue) {
                                                                                    if (newValue != null) {
                                                                                      toggleOffTimelumakeyModuless(
                                                                                          lumakeyModuless, newValue);
                                                                                    }
                                                                                  }
                                                                                      : null,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            textDirection: TextDirection.rtl,
                                                                            children: [
                                                                              Text(
                                                                                s.timecontorol,
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(
                                                                                  color: const Color(0xFF1D1A39),
                                                                                  fontFamily: "Sans",
                                                                                  fontSize: size.width * 0.029,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: size.width * 0.021),
                                                                              GestureDetector(
                                                                                child: SimpleShadow(
                                                                                  color: const Color(0xFF000000),
                                                                                  opacity: 0.5,
                                                                                  offset: const Offset(4, 4),
                                                                                  sigma: 2,
                                                                                  child: Image(
                                                                                    image: AssetImage((lumakeyModuless.is_on_temperature)
                                                                                        ? 'images/modules/ToggleOn.png'
                                                                                        : 'images/modules/ToggleOff.png'),
                                                                                    width: size.width * 0.083,
                                                                                    height: size.width * 0.083,
                                                                                  ),
                                                                                ),
                                                                                onTap: () =>
                                                                                    toggleIsOnTemperaturelumakeyModuless(lumakeyModuless),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: size.height * 0.010),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            textDirection: TextDirection.rtl,
                                                                            children: [
                                                                              Text(
                                                                                s.hasas,
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(
                                                                                  color: const Color(0xFF1D1A39),
                                                                                  fontFamily: "Sans",
                                                                                  fontSize: size.width * 0.025,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: size.width * 0.021),
                                                                              Container(
                                                                                width: size.width * 0.10,
                                                                                height: size.height * 0.030,
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(0xFFD9D9D9),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                        color: const Color(0xFF000000).withOpacity(0.5),
                                                                                        offset: const Offset(4, 4),
                                                                                        blurRadius: 4,
                                                                                        spreadRadius: 0),
                                                                                  ],
                                                                                ),
                                                                                child: DropdownButton<double>(
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF000000),
                                                                                    fontFamily: "Sans",
                                                                                    fontSize: size.width * 0.020,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  padding: EdgeInsets.only(left: size.width * 0.010),
                                                                                  iconSize: 20,
                                                                                  menuMaxHeight: size.height * 0.246,
                                                                                  menuWidth: size.width * 0.167,
                                                                                  dropdownColor: const Color(0xFFD9D9D9),
                                                                                  iconDisabledColor: const Color(0xFF3F5FFF),
                                                                                  iconEnabledColor: const Color(0xFF3F5FFF),
                                                                                  isExpanded: true,
                                                                                  value: lumakeyModuless.sensitive_value,
                                                                                  items: List.generate(13, (index) {
                                                                                    return DropdownMenuItem<double>(
                                                                                      value: index + 16,
                                                                                      child: Text((index + 16).toString()),
                                                                                    );
                                                                                  }),
                                                                                  underline: const Text(''),
                                                                                  onChanged: (lumakeyModuless.is_on_temperature)
                                                                                      ? (newValue) {
                                                                                    if (newValue != null) {
                                                                                      toggleSensitiveValuelumakeyModuless(
                                                                                          lumakeyModuless, newValue);
                                                                                    }
                                                                                  }
                                                                                      : null,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: size.height * 0.010),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            textDirection: TextDirection.rtl,
                                                                            children: [
                                                                              Text(
                                                                                s.temhash,
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(
                                                                                  color: const Color(0xFF1D1A39),
                                                                                  fontFamily: "Sans",
                                                                                  fontSize: size.width * 0.025,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: size.width * 0.021),
                                                                              Container(
                                                                                width: size.width * 0.10,
                                                                                height: size.height * 0.030,
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(0xFFD9D9D9),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                        color: const Color(0xFF000000).withOpacity(0.5),
                                                                                        offset: const Offset(4, 4),
                                                                                        blurRadius: 4,
                                                                                        spreadRadius: 0),
                                                                                  ],
                                                                                ),
                                                                                child: DropdownButton<double>(
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF000000),
                                                                                    fontFamily: "Sans",
                                                                                    fontSize: size.width * 0.020,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  padding: EdgeInsets.only(left: size.width * 0.010),
                                                                                  iconSize: 20,
                                                                                  menuMaxHeight: size.height * 0.246,
                                                                                  menuWidth: size.width * 0.167,
                                                                                  dropdownColor: const Color(0xFFD9D9D9),
                                                                                  iconDisabledColor: const Color(0xFF3F5FFF),
                                                                                  iconEnabledColor: const Color(0xFF3F5FFF),
                                                                                  isExpanded: true,
                                                                                  value: lumakeyModuless.temperature_margin,
                                                                                  items: List.generate(5, (index) {
                                                                                    return DropdownMenuItem<double>(
                                                                                      value: index + 1,
                                                                                      child: Text((index + 1).toString()),
                                                                                    );
                                                                                  }),
                                                                                  underline: const Text(''),
                                                                                  onChanged: (lumakeyModuless.is_on_temperature)
                                                                                      ? (newValue) {
                                                                                    if (newValue != null) {
                                                                                      toggleTemperatureMarginlumakeyModuless(
                                                                                          lumakeyModuless, newValue);
                                                                                    }
                                                                                  }
                                                                                      : null,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),


                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: isDarkMode
                                              ?const Color(0xFFBDFFBD).withOpacity(0.8)
                                              :const Color(0xFF21DB2A).withOpacity(0.80),
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.green.withOpacity(0.15),
                                              offset: const Offset(0, -4),
                                              blurRadius: 20,
                                              spreadRadius: 10,
                                            )
                                          ]
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: size.height * 0.030),
                                        child: Column(
                                          children: [
                                            // List Title (Fixed height, non-scrollable part)
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.063),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                textDirection: TextDirection.rtl,
                                                children: [
                                                   Text(
                                                    s.nemidanam,
                                                    textDirection: TextDirection.rtl,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Color(0xFF1D1A39),
                                                      fontFamily: "Sans",
                                                      fontSize: 18, // Fixed size for better readability
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: size.height * 0.005),

                                            // Expanded FutureBuilder + ListView (The scrollable part)
                                            FutureBuilder<List<LumcyModule>>(
                                                  future: futureLumcyModules,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return const Center(child: CircularProgressIndicator(color: Color(0xFF030585)));
                                                    } else if (snapshot.hasError) {
                                                      return Center(child: Text('Error: ${snapshot.error}'));
                                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                      return Center(child: Text(s.error20));
                                                    }
                                                    final lumcyModules = snapshot.data!;
                                                    // The ListView.builder is now correctly constrained by Expanded
                                                    return ListView.builder(
                                                      shrinkWrap: true, // فقط به اندازه محتوای خود فضا اشغال کند
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: lumcyModules.length,
                                                      itemBuilder: (context, index) {
                                                        final lumcyModule = lumcyModules[index];
                                                        return Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: size.height * 0.015,
                                                              horizontal: size.width * 0.05,
                                                          ),
                                                          child: Container(
                                                            width: size.width * 0.1,
                                                            decoration: BoxDecoration(
                                                              color: isDarkMode
                                                                  ?const Color(0xFFBDFFBD).withOpacity(0.8)
                                                                  :const Color(0xFF21DB2A).withOpacity(0.80),
                                                              borderRadius: BorderRadius.circular(20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: const Color(0xFF030585).withOpacity(0.8),
                                                                  offset: const Offset(0, 0),
                                                                  blurRadius: 20,
                                                                )
                                                              ],
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                vertical: size.width * 0.063,
                                                                horizontal: size.width * 0.063,
                                                              ),
                                                              child: Row(
                                                                textDirection: TextDirection.ltr,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    textDirection: TextDirection.ltr,
                                                                    children: [
                                                                      Text(
                                                                        s.nor(lumcyModule.slug.replaceAll('0', '').padRight(2, '#')),
                                                                        textDirection: TextDirection.rtl,
                                                                        textAlign: TextAlign.right,
                                                                        style: TextStyle(
                                                                          color: const Color(0xFF1D1A39),
                                                                          fontFamily: "Sans",
                                                                          fontSize: size.width * 0.029,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(width: size.width * 0.03),
                                                                  // --- Module Controls (Left Side) ---
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Opacity(
                                                                          opacity: (lumcyModule.mode == 'NF') ? 1 : 0.75,
                                                                          child: GestureDetector(
                                                                            child: Container(
                                                                              width: size.width * 0.27,
                                                                              height: size.height * 0.05,
                                                                              decoration: BoxDecoration(
                                                                                gradient: const LinearGradient(
                                                                                    colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                                borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                                border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  textDirection: TextDirection.rtl,
                                                                                  textAlign: TextAlign.center,
                                                                                  s.onoff,
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: size.width * 0.025,
                                                                                    fontFamily: "Sans",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            onTap: () => (lumcyModule.mode != 'NF')
                                                                                ? toggleModeLumcyModule(lumcyModule, 'NF')
                                                                                : null,
                                                                          ),
                                                                      ),
                                                                      SizedBox(height: size.height * 0.010),
                                                                      Opacity(
                                                                        opacity: (lumcyModule.mode == 'N') ? 1 : 0.75,
                                                                        child: GestureDetector(
                                                                          child: Container(
                                                                            width: size.width * 0.27,
                                                                            height: size.height * 0.05,
                                                                            decoration: BoxDecoration(
                                                                              gradient: const LinearGradient(
                                                                                  colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                              borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                              border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.center,
                                                                                s.on,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: size.width * 0.025,
                                                                                  fontFamily: "Sans",
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap: () => (lumcyModule.mode != 'N')
                                                                              ? toggleModeLumcyModule(lumcyModule, 'N')
                                                                              : null,
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: size.height * 0.010),
                                                                      Opacity(
                                                                        opacity: (lumcyModule.mode == 'F') ? 1 : 0.75,
                                                                        child: GestureDetector(
                                                                          child: Container(
                                                                            width: size.width * 0.27,
                                                                            height: size.height * 0.05,
                                                                            decoration: BoxDecoration(
                                                                              gradient: const LinearGradient(
                                                                                  colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                              borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                              border: Border.all(color: const Color(0xFF215426), width: 1),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.center,
                                                                                s.off,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: size.width * 0.025,
                                                                                  fontFamily: "Sans",
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap: () => (lumcyModule.mode != 'F')
                                                                              ? toggleModeLumcyModule(lumcyModule, 'F')
                                                                              : null,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  // --- Lamp Grid or AP Mode Button (Right Side) ---
                                                                  (lumcyModule.mode != 'F')
                                                                      ? SizedBox(
                                                                    // Dynamically adjust height based on number of lamps
                                                                    height: (lumcyModule.is_turn_lamp_3 == null && lumcyModule.is_turn_lamp_4 == null)
                                                                        ? size.width * 0.180 // Smaller height for 2 lamps
                                                                        : size.width * 0.300, // Full height for 3/4 lamps
                                                                    width: size.width * 0.250,
                                                                    child: GridView.count(
                                                                      crossAxisCount: 2,
                                                                      mainAxisSpacing: 10,
                                                                      crossAxisSpacing: 10,
                                                                      physics: const NeverScrollableScrollPhysics(), // Important to prevent inner scrolling
                                                                      children: [
                                                                        if (lumcyModule.is_turn_lamp_1 != null)
                                                                          GestureDetector(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color((lumcyModule.is_turn_lamp_1!)
                                                                                      ? 0xFF48A23D
                                                                                      : 0xFFE72535)
                                                                                      .withOpacity(0.4),
                                                                                  offset: const Offset(0, 0),
                                                                                  blurRadius: 20,
                                                                                  spreadRadius: 2,
                                                                                ),
                                                                              ]),
                                                                              child: Image(
                                                                                  image: AssetImage((lumcyModule.is_turn_lamp_1!)
                                                                                      ? 'images/modules/TurnOn.png'
                                                                                      : 'images/modules/Shutdown.png')),
                                                                            ),
                                                                            onTap: () => toggleIsTurnLamp1LumcyModule(lumcyModule),
                                                                          ),
                                                                        if (lumcyModule.is_turn_lamp_2 != null)
                                                                          GestureDetector(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color((lumcyModule.is_turn_lamp_2!)
                                                                                      ? 0xFF48A23D
                                                                                      : 0xFFE72535)
                                                                                      .withOpacity(0.4),
                                                                                  offset: const Offset(0, 0),
                                                                                  blurRadius: 20,
                                                                                  spreadRadius: 2,
                                                                                ),
                                                                              ]),
                                                                              child: Image(
                                                                                  image: AssetImage((lumcyModule.is_turn_lamp_2!)
                                                                                      ? 'images/modules/TurnOn.png'
                                                                                      : 'images/modules/Shutdown.png')),
                                                                            ),
                                                                            onTap: () => toggleIsTurnLamp2LumcyModule(lumcyModule),
                                                                          ),
                                                                        if (lumcyModule.is_turn_lamp_3 != null)
                                                                          GestureDetector(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color((lumcyModule.is_turn_lamp_3!)
                                                                                      ? 0xFF48A23D
                                                                                      : 0xFFE72535)
                                                                                      .withOpacity(0.4),
                                                                                  offset: const Offset(0, 0),
                                                                                  blurRadius: 20,
                                                                                  spreadRadius: 2,
                                                                                ),
                                                                              ]),
                                                                              child: Image(
                                                                                  image: AssetImage((lumcyModule.is_turn_lamp_3!)
                                                                                      ? 'images/modules/TurnOn.png'
                                                                                      : 'images/modules/Shutdown.png')),
                                                                            ),
                                                                            onTap: () => toggleIsTurnLamp3LumcyModule(lumcyModule),
                                                                          ),
                                                                        if (lumcyModule.is_turn_lamp_4 != null)
                                                                          GestureDetector(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color((lumcyModule.is_turn_lamp_4!)
                                                                                      ? 0xFF48A23D
                                                                                      : 0xFFE72535)
                                                                                      .withOpacity(0.4),
                                                                                  offset: const Offset(0, 0),
                                                                                  blurRadius: 20,
                                                                                  spreadRadius: 2,
                                                                                ),
                                                                              ]),
                                                                              child: Image(
                                                                                  image: AssetImage((lumcyModule.is_turn_lamp_4!)
                                                                                      ? 'images/modules/TurnOn.png'
                                                                                      : 'images/modules/Shutdown.png')),
                                                                            ),
                                                                            onTap: () => toggleIsTurnLamp4LumcyModule(lumcyModule),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                      : SizedBox(
                                                                    height: size.width * 0.300,
                                                                    width: size.width * 0.300,
                                                                    child: Center(
                                                                      child: Opacity(
                                                                        opacity: (lumcyModule.is_ap_mode) ? 1 : 0.75,
                                                                        child: GestureDetector(
                                                                          onTap: () => toggleIsApModeLumcyModule(lumcyModule),
                                                                          child: Container(
                                                                            width: size.width * 0.250,
                                                                            height: size.height * 0.040,
                                                                            decoration: BoxDecoration(
                                                                              gradient: const LinearGradient(
                                                                                  colors: [Color(0xFF030585), Color(0xFF272AF5)]),
                                                                              borderRadius: BorderRadius.circular(size.width * 0.083),
                                                                              border: Border.all(
                                                                                  color: const Color(0xFF215426), width: 1),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                s.mod,
                                                                                textDirection: TextDirection.rtl,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: size.width * 0.025,
                                                                                  fontFamily: "Sans",
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ],
                                    ),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
