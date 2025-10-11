import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/utils.dart' as utils;
import 'package:group_button/group_button.dart';
import 'package:simple_shadow/simple_shadow.dart';

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

Future<lumakeyModulesss> fetchlumakeyModulessss(int locationId) async {
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
      throw Exception('No lumakey module found for this location');
    }
  } else {
    throw Exception('Failed to load lumakey module');
  }
}

class lumakeyModulesssList extends StatefulWidget {
  final int id;

  const lumakeyModulesssList({
    required this.id,
    super.key,
  });

  @override
  State<lumakeyModulesssList> createState() => _lumakeyModulesssListState();
}

class _lumakeyModulesssListState extends State<lumakeyModulesssList> {
  late Future<lumakeyModulesss> futurelumakeyModulessss;

  @override
  void initState() {
    super.initState();
    futurelumakeyModulessss = fetchlumakeyModulessss(widget.id);
  }

  Future<void> turnOnPumplumakeyModulesss(lumakeyModulesss lumakeyModulesss) async {
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

  Future<void> turnOnMotorlumakeyModulesss(lumakeyModulesss lumakeyModulesss) async {
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

  Future<void> turnOnSpeedValuelumakeyModulesss(lumakeyModulesss lumakeyModulesss) async {
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

  Future<void> turnOfflumakeyModulesss(lumakeyModulesss lumakeyModulesss) async {
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

  Future<void> toggleEfficientSetuplumakeyModulesss(lumakeyModulesss lumakeyModulesss) async {
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

  Future<void> toggleIsOnTemperaturelumakeyModulesss(lumakeyModulesss lumakeyModulesss) async {
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

  Future<void> toggleTemperatureMarginlumakeyModulesss(
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

  Future<void> toggleSensitiveValuelumakeyModulesss(lumakeyModulesss lumakeyModulesss, double sensitive_value) async {
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

  Future<void> toggleIsOnTimerlumakeyModulesss(lumakeyModulesss lumakeyModulesss) async {
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

  Future<void> toggleOnTimelumakeyModulesss(lumakeyModulesss lumakeyModulesss, int on_time) async {
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

  Future<void> toggleOffTimelumakeyModulesss(lumakeyModulesss lumakeyModulesss, int off_time) async {
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

  Future<void> toggleModelumakeyModulesss(lumakeyModulesss lumakeyModulesss, String mode) async {
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

  Future<void> toggleIsApModelumakeyModulesss(lumakeyModulesss lumakeyModulesss) async {
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: const Color(0xFF000000).withOpacity(0),
      backgroundColor: const Color(0xFFD9D9D9).withOpacity(0),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFFFFF).withOpacity(0.15),
                offset: const Offset(0, -4),
                blurRadius: 20,
                spreadRadius: 10,
              )
            ]),
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.030),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(width: size.width * 0.063),
                  Text(
                    "لیست ماژول های کولر: ",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF1D1A39),
                      fontFamily: "Sans",
                      fontSize: size.width * 0.033,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.015),
              Expanded(
                child: FutureBuilder<lumakeyModulesss>(
                  future: futurelumakeyModulessss,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final lumakeyModulesss = snapshot.data!;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.015,
                              horizontal: size.width * 0.100,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF000DFF).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
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
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      //textDirection: TextDirection.rtl,
                                      children: [
                                        Text(
                                          "کولر ${lumakeyModulesss.slug.replaceAll('0', '').padRight(2, '#')}",
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
                                    SizedBox(width: size.width * 0.015),
                                    Column(
                                      textDirection: TextDirection.rtl,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Opacity(
                                          opacity: (lumakeyModulesss.mode == 'F') ? 1 : 0.75,
                                          child: GestureDetector(
                                            child: Container(
                                              width: size.width * 0.2,
                                              height: size.height * 0.2,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    colors: [Color(0xFF0052A5), Color(0xFFA5D2FF)]),
                                                borderRadius: BorderRadius.circular(size.width * 0.083),
                                                border: Border.all(color: const Color(0xFF000DFF), width: 1),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  textDirection: TextDirection.rtl,
                                                  textAlign: TextAlign.center,
                                                  "آفلاین",
                                                  style: TextStyle(
                                                    color: const Color(0xFFFFFFFF),
                                                    fontSize: size.width * 0.025,
                                                    fontFamily: "Sans",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () => (lumakeyModulesss.mode != 'F')
                                                ? toggleModelumakeyModulesss(lumakeyModulesss, 'F')
                                                : null,
                                          ),
                                        ),

                                        Opacity(
                                          opacity: (lumakeyModulesss.mode == 'N') ? 1 : 0.75,
                                          child: GestureDetector(
                                            child: Container(
                                              width: size.width * 0.2,
                                              height: size.height * 0.2,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    colors: [Color(0xFF0052A5), Color(0xFFA5D2FF)]),
                                                borderRadius: BorderRadius.circular(size.width * 0.083),
                                                border: Border.all(color: const Color(0xFF000DFF), width: 1),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  textDirection: TextDirection.rtl,
                                                  textAlign: TextAlign.center,
                                                  "آنلاین",
                                                  style: TextStyle(
                                                    color: const Color(0xFFFFFFFF),
                                                    fontSize: size.width * 0.025,
                                                    fontFamily: "Sans",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () => (lumakeyModulesss.mode != 'N')
                                                ? toggleModelumakeyModulesss(lumakeyModulesss, 'N')
                                                : null,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.010),
                                    Column(
                                      textDirection: TextDirection.rtl,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Opacity(
                                          opacity: (lumakeyModulesss.mode == 'AUTO') ? 1 : 0.75,
                                          child: GestureDetector(
                                            child: Container(
                                              width: size.width * 0.2,
                                              height: size.height * 0.2,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    colors: [Color(0xFF0052A5), Color(0xFFA5D2FF)]),
                                                borderRadius: BorderRadius.circular(size.width * 0.083),
                                                border: Border.all(color: const Color(0xFF000DFF), width: 1),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  textDirection: TextDirection.rtl,
                                                  textAlign: TextAlign.center,
                                                  "اتوماتیک",
                                                  style: TextStyle(
                                                    color: const Color(0xFFFFFFFF),
                                                    fontSize: size.width * 0.025,
                                                    fontFamily: "Sans",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () => (lumakeyModulesss.mode != 'AUTO')
                                                ? toggleModelumakeyModulesss(lumakeyModulesss, 'AUTO')
                                                : null,
                                          ),
                                        ),
                                        Opacity(
                                          opacity: (lumakeyModulesss.mode == 'NF') ? 1 : 0.75,
                                          child: GestureDetector(
                                            child: Container(
                                              width: size.width * 0.2,
                                              height: size.height * 0.2,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    colors: [Color(0xFF0052A5), Color(0xFFA5D2FF)]),
                                                borderRadius: BorderRadius.circular(size.width * 0.083),
                                                border: Border.all(color: const Color(0xFF000DFF), width: 1),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  textDirection: TextDirection.rtl,
                                                  textAlign: TextAlign.center,
                                                  "آنلاین و آفلاین",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: size.width * 0.025,
                                                    fontFamily: "Sans",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () => (lumakeyModulesss.mode != 'NF')
                                                ? toggleModelumakeyModulesss(lumakeyModulesss, 'NF')
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.020),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text(
                                          "تنظیمات",
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
                                    (lumakeyModulesss.mode != 'F')
                                        ? GroupButton(
                                      isRadio: true,
                                      onSelected: (value, index, isSelected) {
                                        isSelected
                                            ? index == 2
                                            ? turnOnPumplumakeyModulesss(lumakeyModulesss)
                                            : index == 1
                                            ? turnOnMotorlumakeyModulesss(lumakeyModulesss)
                                            : turnOnSpeedValuelumakeyModulesss(lumakeyModulesss)
                                            : turnOfflumakeyModulesss(lumakeyModulesss);
                                      },
                                      controller: lumakeyModulesss.controller,
                                      enableDeselect: true,
                                      options: GroupButtonOptions(
                                        selectedTextStyle: TextStyle(
                                          color: const Color(0xFFE8BCB9),
                                          fontSize: size.width * 0.025,
                                          fontFamily: "Sans",
                                        ),
                                        selectedColor: const Color(0xFF1D1A39),
                                        unselectedShadow: const [],
                                        unselectedColor: const Color(0xFF1D1A39).withOpacity(0.75),
                                        unselectedTextStyle: TextStyle(
                                          color: const Color(0xFFE8BCB9).withOpacity(0.75),
                                          fontSize: size.width * 0.025,
                                          fontFamily: "Sans",
                                        ),
                                        selectedBorderColor: const Color(0xFFF39F5A),
                                        unselectedBorderColor:
                                        const Color(0xFFF39F5A).withOpacity(0.75),
                                        borderRadius: BorderRadius.circular(size.width * 0.083),
                                        spacing: size.width * 0.021,
                                        groupingType: GroupingType.wrap,
                                        direction: Axis.horizontal,
                                        buttonHeight: size.height * 0.030,
                                        buttonWidth: size.width * 0.208,
                                        mainGroupAlignment: MainGroupAlignment.start,
                                        crossGroupAlignment: CrossGroupAlignment.start,
                                        groupRunAlignment: GroupRunAlignment.start,
                                        textAlign: TextAlign.center,
                                        textPadding: EdgeInsets.zero,
                                        alignment: Alignment.center,
                                        elevation: 0,
                                      ),
                                      buttons: [
                                        'دور تند',
                                        'دور کند',
                                        if (lumakeyModulesss.mode != 'AUTO') 'پمپ',
                                      ],
                                    )
                                        : Opacity(
                                      opacity: (lumakeyModulesss.is_ap_mode) ? 1 : 0.75,
                                      child: GestureDetector(
                                        child: Container(
                                          width: size.width * 0.313,
                                          height: size.height * 0.030,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                                colors: [Color(0xFF1D1A39), Color(0xFF451952)]),
                                            borderRadius: BorderRadius.circular(size.width * 0.083),
                                            border:
                                            Border.all(color: const Color(0xFFF39F5A), width: 1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              "حالت مدیریت",
                                              style: TextStyle(
                                                color: const Color(0xFFE8BCB9),
                                                fontSize: size.width * 0.025,
                                                fontFamily: "Sans",
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () => toggleIsApModelumakeyModulesss(lumakeyModulesss),
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.015),
                                    if (lumakeyModulesss.mode != 'F')
                                      Opacity(
                                        opacity: (lumakeyModulesss.efficient_setup) ? 1 : 0.75,
                                        child: GestureDetector(
                                          child: Container(
                                            width: size.width * 0.313,
                                            height: size.height * 0.030,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                  colors: [Color(0xFF1D1A39), Color(0xFF451952)]),
                                              borderRadius: BorderRadius.circular(size.width * 0.083),
                                              border: Border.all(color: const Color(0xFFF39F5A), width: 1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                textDirection: TextDirection.rtl,
                                                textAlign: TextAlign.center,
                                                "راه اندازی با دور تند",
                                                style: TextStyle(
                                                  color: const Color(0xFFE8BCB9),
                                                  fontSize: size.width * 0.025,
                                                  fontFamily: "Sans",
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () => toggleEfficientSetuplumakeyModulesss(lumakeyModulesss),
                                        ),
                                      ),
                                    SizedBox(height: size.height * 0.015),
                                    if (lumakeyModulesss.mode == 'AUTO')
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
                                                    "کنترل زمانی",
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
                                                        image: AssetImage((lumakeyModulesss.is_on_timer)
                                                            ? 'images/ToggleOn.png'
                                                            : 'images/ToggleOff.png'),
                                                        width: size.width * 0.063,
                                                        height: size.width * 0.063,
                                                      ),
                                                    ),
                                                    onTap: () => toggleIsOnTimerlumakeyModulesss(lumakeyModulesss),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: size.height * 0.010),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                textDirection: TextDirection.rtl,
                                                children: [
                                                  Text(
                                                    "زمان روشن ماندن:",
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
                                                    width: size.width * 0.135,
                                                    height: size.height * 0.020,
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
                                                      iconDisabledColor: const Color(0xFFF39F5A),
                                                      iconEnabledColor: const Color(0xFFF39F5A),
                                                      isExpanded: true,
                                                      value: lumakeyModulesss.on_time,
                                                      items: const [
                                                        DropdownMenuItem(
                                                          value: 15,
                                                          child: Text(
                                                            '15 دقیقه',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 30,
                                                          child: Text(
                                                            '30 دقیقه',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 45,
                                                          child: Text(
                                                            '45 دقیقه',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 1 * 60,
                                                          child: Text(
                                                            '1 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 2 * 60,
                                                          child: Text(
                                                            '2 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 3 * 60,
                                                          child: Text(
                                                            '3 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 4 * 60,
                                                          child: Text(
                                                            '4 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 5 * 60,
                                                          child: Text(
                                                            '5 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 6 * 60,
                                                          child: Text(
                                                            '6 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                      underline: const Text(''),
                                                      onChanged: (lumakeyModulesss.is_on_timer)
                                                          ? (newValue) {
                                                        if (newValue != null) {
                                                          toggleOnTimelumakeyModulesss(
                                                              lumakeyModulesss, newValue);
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
                                                    "زمان خاموش ماندن:",
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
                                                    width: size.width * 0.135,
                                                    height: size.height * 0.020,
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
                                                      iconDisabledColor: const Color(0xFFF39F5A),
                                                      iconEnabledColor: const Color(0xFFF39F5A),
                                                      isExpanded: true,
                                                      value: lumakeyModulesss.off_time,
                                                      items: const [
                                                        DropdownMenuItem(
                                                          value: 15,
                                                          child: Text(
                                                            '15 دقیقه',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 30,
                                                          child: Text(
                                                            '30 دقیقه',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 45,
                                                          child: Text(
                                                            '45 دقیقه',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 1 * 60,
                                                          child: Text(
                                                            '1 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 2 * 60,
                                                          child: Text(
                                                            '2 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 3 * 60,
                                                          child: Text(
                                                            '3 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 4 * 60,
                                                          child: Text(
                                                            '4 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 5 * 60,
                                                          child: Text(
                                                            '5 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 6 * 60,
                                                          child: Text(
                                                            '6 ساعت',
                                                            textDirection: TextDirection.rtl,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                      underline: const Text(''),
                                                      onChanged: (lumakeyModulesss.is_on_timer)
                                                          ? (newValue) {
                                                        if (newValue != null) {
                                                          toggleOffTimelumakeyModulesss(
                                                              lumakeyModulesss, newValue);
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
                                                    "کنترل دمایی",
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
                                                        image: AssetImage((lumakeyModulesss.is_on_temperature)
                                                            ? 'images/ToggleOn.png'
                                                            : 'images/ToggleOff.png'),
                                                        width: size.width * 0.063,
                                                        height: size.width * 0.063,
                                                      ),
                                                    ),
                                                    onTap: () =>
                                                        toggleIsOnTemperaturelumakeyModulesss(lumakeyModulesss),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: size.height * 0.010),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                textDirection: TextDirection.rtl,
                                                children: [
                                                  Text(
                                                    "دمای حساس:",
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
                                                    width: size.width * 0.080,
                                                    height: size.height * 0.020,
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
                                                      iconDisabledColor: const Color(0xFFF39F5A),
                                                      iconEnabledColor: const Color(0xFFF39F5A),
                                                      isExpanded: true,
                                                      value: lumakeyModulesss.sensitive_value,
                                                      items: List.generate(13, (index) {
                                                        return DropdownMenuItem<double>(
                                                          value: index + 16,
                                                          child: Text((index + 16).toString()),
                                                        );
                                                      }),
                                                      underline: const Text(''),
                                                      onChanged: (lumakeyModulesss.is_on_temperature)
                                                          ? (newValue) {
                                                        if (newValue != null) {
                                                          toggleSensitiveValuelumakeyModulesss(
                                                              lumakeyModulesss, newValue);
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
                                                    "حاشیه دما:",
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
                                                    width: size.width * 0.060,
                                                    height: size.height * 0.020,
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
                                                      iconDisabledColor: const Color(0xFFF39F5A),
                                                      iconEnabledColor: const Color(0xFFF39F5A),
                                                      isExpanded: true,
                                                      value: lumakeyModulesss.temperature_margin,
                                                      items: List.generate(5, (index) {
                                                        return DropdownMenuItem<double>(
                                                          value: index + 1,
                                                          child: Text((index + 1).toString()),
                                                        );
                                                      }),
                                                      underline: const Text(''),
                                                      onChanged: (lumakeyModulesss.is_on_temperature)
                                                          ? (newValue) {
                                                        if (newValue != null) {
                                                          toggleTemperatureMarginlumakeyModulesss(
                                                              lumakeyModulesss, newValue);
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
                          );
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
