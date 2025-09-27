import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lumaapp/pages/mainPages/home_page.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/slider_widget.dart';
import 'package:tn_bottom_sheet_navigator/tn_bottom_sheet_navigator.dart' hide TnBottomSheetSettings;
import 'package:simple_shadow/simple_shadow.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mainPages/add_module.dart';
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
  final String mobileNumber;
  final locationcard;


  const LocationPage({
    required this.locationcard,
    required this.mobileNumber,
    super.key,
  });

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late Future<List<LumakeyModule>> futureLumakeyModules;
  int _tabIndex = 0;
  late PageController _pageController;
  late List<bool> isSelected = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    futureLumakeyModules = fetchLumakeyModules(widget.locationcard.id);
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000AAB),
              Colors.black,
            ],
            stops: [0.4, 0.8],
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
                      icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => HomePage(mobileNumber: widget.mobileNumber),
                        );
                      },
                    ),
                  ),
                  if(widget.locationcard.name == "آشپزخانه")
                  Text(
                    AppLocalizations.of(context)!.loc4,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if(widget.locationcard.name == "اتاق خواب")
                    Text(
                      AppLocalizations.of(context)!.loc2,
                      style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  if(widget.locationcard.name == "سرویس بهداشتی")
                    Text(
                      AppLocalizations.of(context)!.loc1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if(widget.locationcard.name == "سالن پذیرایی")
                    Text(
                      AppLocalizations.of(context)!.loc3,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  //const SizedBox(width: 18),
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          //isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddProduct(Locationcard: widget.locationcard,mobileNumber:widget.mobileNumber),
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
                        //SizedBox(height: size.height * 0.020),
                        SizedBox(height: size.height * 0.030),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = false;
                                  }
                                  isSelected[0] = true;
                                });

                                BuildContextTnBottomSheetNav(context).showTnBottomSheetNav(
                                  'LumakeyModuleList',
                                  params: {'id': widget.locationcard.id},
                                  settings: TnBottomSheetSettings(
                                    constraints: BoxConstraints(
                                      maxHeight: size.height * 0.640,
                                    ),
                                    isScrollControlled: true,
                                    isDismisable: true,
                                  ),
                                );
                              },
                              child: Container(
                                height: size.width * 0.208,
                                width: size.width * 0.208,
                                decoration: BoxDecoration(
                                  color: isSelected[0]
                                      ? const Color(0xFFC7F8FF).withOpacity(0.8) // رنگ وقتی انتخاب شده
                                      : const Color(0xFF0000AB).withOpacity(0.8), // رنگ پیش‌فرض
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(1), // border همیشه
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF000000).withOpacity(0.5),
                                      offset: const Offset(0, 0),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SimpleShadow(
                                    color: const Color(0xFF000000),
                                    opacity: 0.5,
                                    offset: const Offset(4, 4),
                                    sigma: 2,
                                    child: Image.asset(
                                      'images/modules/AirConditioner.png',
                                      width: size.width * 0.104,
                                      height: size.width * 0.104,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            GestureDetector(
                              child: Container(
                                height: size.width * 0.208,
                                width: size.width * 0.208,
                                decoration: BoxDecoration(
                                  color: isSelected[1]
                                      ? const Color(0xFFC7F8FF).withOpacity(0.8) // رنگ وقتی انتخاب شده
                                      : const Color(0xFF0000AB).withOpacity(0.8), // رنگ پیش‌فرض
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(1), // border همیشه
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFF000000).withOpacity(0.5),
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
                                      image: const AssetImage('images/modules/LightOn.png'),
                                      width: size.width * 0.104,
                                      height: size.width * 0.104,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = false;   // همه خاموش
                                  }
                                  isSelected[1] = true;
                                });
                                BuildContextTnBottomSheetNav(context).showTnBottomSheetNav(
                                  'LumcyModuleList',
                                  params: {'id': widget.locationcard.id},
                                  settings: TnBottomSheetSettings(
                                    constraints: BoxConstraints(
                                      maxHeight: size.height * 0.640,
                                    ),
                                    isScrollControlled: true,
                                    isDismisable: true,
                                  ),
                                );
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                height: size.width * 0.208,
                                width: size.width * 0.208,
                                decoration: BoxDecoration(
                                  color: isSelected[2]
                                      ? const Color(0xFFC7F8FF).withOpacity(0.8) // رنگ وقتی انتخاب شده
                                      : const Color(0xFF0000AB).withOpacity(0.8), // رنگ پیش‌فرض
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(1), // border همیشه
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFF000000).withOpacity(0.5),
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
                                      image: const AssetImage('images/modules/TV.png'),
                                      width: size.width * 0.104,
                                      height: size.width * 0.104,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = false;   // همه خاموش
                                  }
                                  isSelected[2] = true;
                                });
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                height: size.width * 0.208,
                                width: size.width * 0.208,
                                decoration: BoxDecoration(
                                  color: isSelected[3]
                                      ? const Color(0xFFC7F8FF).withOpacity(0.8) // رنگ وقتی انتخاب شده
                                      : const Color(0xFF0000AB).withOpacity(0.8), // رنگ پیش‌فرض
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(1), // border همیشه
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFF000000).withOpacity(0.5),
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
                                      image: const AssetImage('images/modules/Wi-FiRouter.png'),
                                      width: size.width * 0.104,
                                      height: size.width * 0.104,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = false;   // همه خاموش
                                  }
                                  isSelected[3] = true;
                                });
                              },
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

                                if(lumakeyModules.isEmpty){
                                  return const Center(
                                    child: Text(
                                      'ماژولی نداری',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }
                                else {
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
                                      Flexible(
                                        child: SliderWidget(
                                          initialVal: lumakeyModules.first.temperature_value,
                                        ),
                                      ),
                                    ],
                                  );
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
