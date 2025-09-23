import 'dart:ui';
import 'package:flutter/material.dart';
import '../../widgets/slider_widget.dart';
import 'package:tn_bottom_sheet_navigator/tn_bottom_sheet_navigator.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/utils.dart' as utils;

class LumakeyModule {
  final String slug;
  double temperature_value;

  LumakeyModule({
    required this.slug,
    required this.temperature_value,
  });

  factory LumakeyModule.fromJson(Map<String, dynamic> json) {
    return LumakeyModule(
      slug: json['slug'],
      temperature_value: json['temperature_value'],
    );
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

class LocationPage extends StatefulWidget {
  final int id;

  const LocationPage({
    required this.id,
    super.key,
  });

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late Future<List<LumakeyModule>> futureLumakeyModules;

  @override
  void initState() {
    super.initState();
    futureLumakeyModules = fetchLumakeyModules(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1D1A39),
              Color(0xFF451952),
            ],
          ),
        ),
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(height: size.height * 0.060),
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.063),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    "خوش آمدید!",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFFE8BCB9).withOpacity(0.5),
                      fontFamily: "Sans",
                      fontSize: size.width * 0.063,
                      shadows: [
                        BoxShadow(
                          color: const Color(0xFFF39F5A).withOpacity(0.3),
                          offset: const Offset(4, 4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.015),
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.063),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    "سیدعلی حسینی",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFFE8BCB9),
                      fontFamily: "Sans",
                      fontSize: size.width * 0.050,
                      shadows: [
                        BoxShadow(
                          color: const Color(0xFFF39F5A).withOpacity(0.3),
                          offset: const Offset(4, 4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.022),
            Expanded(
              child: Stack(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.15),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(size.width * 0.104),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.25),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.042),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.020),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              "آشپزخانه",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFFE8BCB9),
                                fontFamily: "Sans",
                                fontSize: size.width * 0.050,
                                shadows: [
                                  BoxShadow(
                                    color: const Color(0xFFF39F5A).withOpacity(0.3),
                                    offset: const Offset(4, 4),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.030),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Container(
                                height: size.width * 0.208,
                                width: size.width * 0.208,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF39F5A).withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFFF39F5A).withOpacity(0.5),
                                        offset: const Offset(0, 0),
                                        blurRadius: 20)
                                  ],
                                ),
                                child: Center(
                                  child: SimpleShadow(
                                    color: const Color(0xFF000000),
                                    opacity: 0.5,
                                    offset: const Offset(4, 4),
                                    sigma: 2,
                                    child: Image(
                                      image: const AssetImage('images/AirConditioner.png'),
                                      width: size.width * 0.104,
                                      height: size.width * 0.104,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () => context.showTnBottomSheetNav(
                                'LumakeyModuleList',
                                params: {'id': widget.id},
                                settings: TnBottomSheetSettings(
                                  constraints: BoxConstraints(
                                    maxHeight: size.height * 0.640,
                                  ),
                                  isScrollControlled: true,
                                  isDismisable: true,
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                height: size.width * 0.208,
                                width: size.width * 0.208,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF39F5A).withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFFF39F5A).withOpacity(0.5),
                                        offset: const Offset(0, 0),
                                        blurRadius: 20)
                                  ],
                                ),
                                child: Center(
                                  child: SimpleShadow(
                                    color: const Color(0xFF000000),
                                    opacity: 0.5,
                                    offset: const Offset(4, 4),
                                    sigma: 2,
                                    child: Image(
                                      image: const AssetImage('images/LightOn.png'),
                                      width: size.width * 0.104,
                                      height: size.width * 0.104,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () => context.showTnBottomSheetNav(
                                'LumcyModuleList',
                                params: {'id': widget.id},
                                settings: TnBottomSheetSettings(
                                  constraints: BoxConstraints(
                                    maxHeight: size.height * 0.640,
                                  ),
                                  isScrollControlled: true,
                                  isDismisable: true,
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                height: size.width * 0.208,
                                width: size.width * 0.208,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF39F5A).withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFFF39F5A).withOpacity(0.5),
                                        offset: const Offset(0, 0),
                                        blurRadius: 20)
                                  ],
                                ),
                                child: Center(
                                  child: SimpleShadow(
                                    color: const Color(0xFF000000),
                                    opacity: 0.5,
                                    offset: const Offset(4, 4),
                                    sigma: 2,
                                    child: Image(
                                      image: const AssetImage('images/TV.png'),
                                      width: size.width * 0.104,
                                      height: size.width * 0.104,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {},
                            ),
                            GestureDetector(
                              child: Container(
                                height: size.width * 0.208,
                                width: size.width * 0.208,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF39F5A).withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFFF39F5A).withOpacity(0.5),
                                        offset: const Offset(0, 0),
                                        blurRadius: 20)
                                  ],
                                ),
                                child: Center(
                                  child: SimpleShadow(
                                    color: const Color(0xFF000000),
                                    opacity: 0.5,
                                    offset: const Offset(4, 4),
                                    sigma: 2,
                                    child: Image(
                                      image: const AssetImage('images/Wi-FiRouter.png'),
                                      width: size.width * 0.104,
                                      height: size.width * 0.104,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.059),
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
                                if (lumakeyModules.isNotEmpty) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Text(
                                            "دمای آشپزخانه:",
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFFE8BCB9),
                                              fontFamily: "Sans",
                                              fontSize: size.width * 0.050,
                                              shadows: [
                                                BoxShadow(
                                                  color: const Color(0xFFF39F5A).withOpacity(0.3),
                                                  offset: const Offset(4, 4),
                                                  blurRadius: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.height * 0.030),
                                      Expanded(
                                        child: SliderWidget(
                                          initialVal: lumakeyModules.first.temperature_value,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }
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
