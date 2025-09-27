import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/utils.dart' as utils;
import 'package:group_button/group_button.dart';
import 'package:simple_shadow/simple_shadow.dart';

class LumakeyModule {
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

  LumakeyModule({
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

  factory LumakeyModule.fromJson(Map<String, dynamic> json) {
    return LumakeyModule(
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

Future<List<LumakeyModule>> fetchLumakeyModules(int locationId) async {
  final response = await http.get(
    Uri.parse('${utils.serverAddress}/products/lumakey/generics?location=$locationId'),
    headers: {
      'Authorization': 'Token ${utils.token}',
    },
  );
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((json) => LumakeyModule.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load lumakeyModules');
  }
}

class LumakeyModuleList extends StatefulWidget {
  final int id;

  const LumakeyModuleList({
    required this.id,
    super.key,
  });

  @override
  State<LumakeyModuleList> createState() => _LumakeyModuleListState();
}

class _LumakeyModuleListState extends State<LumakeyModuleList> {
  late Future<List<LumakeyModule>> futureLumakeyModules;

  @override
  void initState() {
    super.initState();
    futureLumakeyModules = fetchLumakeyModules(widget.id);
  }

  Future<void> turnOnPumpLumakeyModule(LumakeyModule lumakeyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
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
        lumakeyModule.is_turn_pump = true;
        lumakeyModule.is_turn_motor = false;
        lumakeyModule.speed_value = false;
        lumakeyModule.controller.selectIndex(2);
      });
    } else {
      throw Exception('Failed to turn on pump lumakeyModule');
    }
  }

  Future<void> turnOnMotorLumakeyModule(LumakeyModule lumakeyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
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
        lumakeyModule.is_turn_pump = true;
        lumakeyModule.is_turn_motor = true;
        lumakeyModule.speed_value = false;
        lumakeyModule.controller.selectIndex(1);
      });
    } else {
      throw Exception('Failed to turn on Motor lumakeyModule');
    }
  }

  Future<void> turnOnSpeedValueLumakeyModule(LumakeyModule lumakeyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
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
        lumakeyModule.is_turn_pump = true;
        lumakeyModule.is_turn_motor = true;
        lumakeyModule.speed_value = true;
        lumakeyModule.controller.selectIndex(0);
      });
    } else {
      throw Exception('Failed to turn on speed lumakeyModule');
    }
  }

  Future<void> turnOffLumakeyModule(LumakeyModule lumakeyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
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
        lumakeyModule.is_turn_pump = false;
        lumakeyModule.is_turn_motor = false;
        lumakeyModule.speed_value = false;
        lumakeyModule.controller.unselectAll();
      });
    } else {
      throw Exception('Failed to turn off lumakeyModule');
    }
  }

  Future<void> toggleEfficientSetupLumakeyModule(LumakeyModule lumakeyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'efficient_setup': !lumakeyModule.efficient_setup,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModule.efficient_setup = !lumakeyModule.efficient_setup;
      });
    } else {
      throw Exception('Failed to toggle efficient_setup lumakeyModule');
    }
  }

  Future<void> toggleIsOnTemperatureLumakeyModule(LumakeyModule lumakeyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'is_on_temperature': !lumakeyModule.is_on_temperature,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModule.is_on_temperature = !lumakeyModule.is_on_temperature;
      });
    } else {
      throw Exception('Failed to toggle is_on_temperature lumakeyModule');
    }
  }

  Future<void> toggleTemperatureMarginLumakeyModule(
      LumakeyModule lumakeyModule, double temperature_margin) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
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
        lumakeyModule.temperature_margin = temperature_margin;
      });
    } else {
      throw Exception('Failed to toggle temperature_margin lumakeyModule');
    }
  }

  Future<void> toggleSensitiveValueLumakeyModule(LumakeyModule lumakeyModule, double sensitive_value) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
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
        lumakeyModule.sensitive_value = sensitive_value;
      });
    } else {
      throw Exception('Failed to toggle sensitive_value lumakeyModule');
    }
  }

  Future<void> toggleIsOnTimerLumakeyModule(LumakeyModule lumakeyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'is_on_timer': !lumakeyModule.is_on_timer,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModule.is_on_timer = !lumakeyModule.is_on_timer;
      });
    } else {
      throw Exception('Failed to toggle is_on_timer lumakeyModule');
    }
  }

  Future<void> toggleOnTimeLumakeyModule(LumakeyModule lumakeyModule, int on_time) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
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
        lumakeyModule.on_time = on_time;
      });
    } else {
      throw Exception('Failed to toggle on_time lumakeyModule');
    }
  }

  Future<void> toggleOffTimeLumakeyModule(LumakeyModule lumakeyModule, int off_time) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
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
        lumakeyModule.off_time = off_time;
      });
    } else {
      throw Exception('Failed to toggle off_time lumakeyModule');
    }
  }

  Future<void> toggleModeLumakeyModule(LumakeyModule lumakeyModule, String mode) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
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
        lumakeyModule.mode = mode;
      });
    } else {
      throw Exception('Failed to toggle mode lumakeyModule');
    }
  }

  Future<void> toggleIsApModeLumakeyModule(LumakeyModule lumakeyModule) async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/generics/${lumakeyModule.slug}');
    final response = await http.put(url,
        headers: {
          'Authorization': 'Token ${utils.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'is_ap_mode': !lumakeyModule.is_ap_mode,
        }));
    if (response.statusCode == 200) {
      setState(() {
        lumakeyModule.is_ap_mode = !lumakeyModule.is_ap_mode;
      });
    } else {
      throw Exception('Failed to toggle is_ap_mode lumakeyModule');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: const Color(0xFFD9D9D9).withOpacity(0),
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
                child: FutureBuilder<List<LumakeyModule>>(
                  future: futureLumakeyModules,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final lumakeyModules = snapshot.data!;
                      return ListView.builder(
                        itemCount: lumakeyModules.length,
                        itemBuilder: (context, index) {
                          final lumakeyModule = lumakeyModules[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.015,
                              horizontal: size.width * 0.100,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF39F5A).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFF39F5A).withOpacity(0.5),
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
                                          "کولر ${lumakeyModule.slug.replaceAll('0', '').padRight(2, '#')}",
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
                                          opacity: (lumakeyModule.mode == 'NF') ? 1 : 0.75,
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
                                                  "حالت آنلاین و آفلاین",
                                                  style: TextStyle(
                                                    color: const Color(0xFFE8BCB9),
                                                    fontSize: size.width * 0.025,
                                                    fontFamily: "Sans",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () => (lumakeyModule.mode != 'NF')
                                                ? toggleModeLumakeyModule(lumakeyModule, 'NF')
                                                : null,
                                          ),
                                        ),
                                        Opacity(
                                          opacity: (lumakeyModule.mode == 'N') ? 1 : 0.75,
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
                                                  "حالت آنلاین",
                                                  style: TextStyle(
                                                    color: const Color(0xFFE8BCB9),
                                                    fontSize: size.width * 0.025,
                                                    fontFamily: "Sans",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () => (lumakeyModule.mode != 'N')
                                                ? toggleModeLumakeyModule(lumakeyModule, 'N')
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
                                          opacity: (lumakeyModule.mode == 'AUTO') ? 1 : 0.75,
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
                                                  "حالت اتوماتیک",
                                                  style: TextStyle(
                                                    color: const Color(0xFFE8BCB9),
                                                    fontSize: size.width * 0.025,
                                                    fontFamily: "Sans",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () => (lumakeyModule.mode != 'AUTO')
                                                ? toggleModeLumakeyModule(lumakeyModule, 'AUTO')
                                                : null,
                                          ),
                                        ),
                                        Opacity(
                                          opacity: (lumakeyModule.mode == 'F') ? 1 : 0.75,
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
                                                  "حالت آفلاین",
                                                  style: TextStyle(
                                                    color: const Color(0xFFE8BCB9),
                                                    fontSize: size.width * 0.025,
                                                    fontFamily: "Sans",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () => (lumakeyModule.mode != 'F')
                                                ? toggleModeLumakeyModule(lumakeyModule, 'F')
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
                                    (lumakeyModule.mode != 'F')
                                        ? GroupButton(
                                      isRadio: true,
                                      onSelected: (value, index, isSelected) {
                                        isSelected
                                            ? index == 2
                                            ? turnOnPumpLumakeyModule(lumakeyModule)
                                            : index == 1
                                            ? turnOnMotorLumakeyModule(lumakeyModule)
                                            : turnOnSpeedValueLumakeyModule(lumakeyModule)
                                            : turnOffLumakeyModule(lumakeyModule);
                                      },
                                      controller: lumakeyModule.controller,
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
                                        if (lumakeyModule.mode != 'AUTO') 'پمپ',
                                      ],
                                    )
                                        : Opacity(
                                      opacity: (lumakeyModule.is_ap_mode) ? 1 : 0.75,
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
                                        onTap: () => toggleIsApModeLumakeyModule(lumakeyModule),
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.015),
                                    if (lumakeyModule.mode != 'F')
                                      Opacity(
                                        opacity: (lumakeyModule.efficient_setup) ? 1 : 0.75,
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
                                          onTap: () => toggleEfficientSetupLumakeyModule(lumakeyModule),
                                        ),
                                      ),
                                    SizedBox(height: size.height * 0.015),
                                    if (lumakeyModule.mode == 'AUTO')
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
                                                        image: AssetImage((lumakeyModule.is_on_timer)
                                                            ? 'images/ToggleOn.png'
                                                            : 'images/ToggleOff.png'),
                                                        width: size.width * 0.063,
                                                        height: size.width * 0.063,
                                                      ),
                                                    ),
                                                    onTap: () => toggleIsOnTimerLumakeyModule(lumakeyModule),
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
                                                      value: lumakeyModule.on_time,
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
                                                      onChanged: (lumakeyModule.is_on_timer)
                                                          ? (newValue) {
                                                        if (newValue != null) {
                                                          toggleOnTimeLumakeyModule(
                                                              lumakeyModule, newValue);
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
                                                      value: lumakeyModule.off_time,
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
                                                      onChanged: (lumakeyModule.is_on_timer)
                                                          ? (newValue) {
                                                        if (newValue != null) {
                                                          toggleOffTimeLumakeyModule(
                                                              lumakeyModule, newValue);
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
                                                        image: AssetImage((lumakeyModule.is_on_temperature)
                                                            ? 'images/ToggleOn.png'
                                                            : 'images/ToggleOff.png'),
                                                        width: size.width * 0.063,
                                                        height: size.width * 0.063,
                                                      ),
                                                    ),
                                                    onTap: () =>
                                                        toggleIsOnTemperatureLumakeyModule(lumakeyModule),
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
                                                      value: lumakeyModule.sensitive_value,
                                                      items: List.generate(13, (index) {
                                                        return DropdownMenuItem<double>(
                                                          value: index + 16,
                                                          child: Text((index + 16).toString()),
                                                        );
                                                      }),
                                                      underline: const Text(''),
                                                      onChanged: (lumakeyModule.is_on_temperature)
                                                          ? (newValue) {
                                                        if (newValue != null) {
                                                          toggleSensitiveValueLumakeyModule(
                                                              lumakeyModule, newValue);
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
                                                      value: lumakeyModule.temperature_margin,
                                                      items: List.generate(5, (index) {
                                                        return DropdownMenuItem<double>(
                                                          value: index + 1,
                                                          child: Text((index + 1).toString()),
                                                        );
                                                      }),
                                                      underline: const Text(''),
                                                      onChanged: (lumakeyModule.is_on_temperature)
                                                          ? (newValue) {
                                                        if (newValue != null) {
                                                          toggleTemperatureMarginLumakeyModule(
                                                              lumakeyModule, newValue);
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
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
