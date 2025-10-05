import 'dart:ui';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:lumaapp/pages/mainPages/home_page.dart';
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
  late Future<List<LumakeyModule>> futureLumakeyModules;
  int _tabIndex = 0;
  late PageController _pageController;
  late List<bool> isSelected = [false, false, false, false];
  bool on_off = true;

  @override
  void initState() {
    super.initState();
    futureLumakeyModules = fetchLumakeyModules(widget.locationcard.id);
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final currentTheme = Theme.of(context);
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
                          //isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddProduct(Locationcard: widget.locationcard),
                        );
                      },
                    ),
                  ),
                  //const SizedBox(width: 18),

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
                      margin: EdgeInsets.only(top: size.height * 0.01),
                      height: size.height * 0.45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF).withOpacity(0.15),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(size.width * 0.104),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFFFFF).withOpacity(0.25),
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

                        SizedBox(height: size.height * 0.029),
                        Expanded(
                          child: FutureBuilder<List<LumakeyModule>>(
                            future: futureLumakeyModules,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        AppLocalizations.of(context)!.error10(snapshot.error.toString()),
                                    style: TextStyle(color: Colors.red)
                                    )
                                );
                              }

                              final lumakeyModules = snapshot.data!;
                              bool isNeutralState = !isSelected.contains(true);

                              if (isNeutralState) {

                                if (lumakeyModules.isNotEmpty) {
                                  return Column(
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
                                          initialVal: lumakeyModules.first.temperature_value,
                                        ),


                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.dontexit,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }
                              }
                              else {
                                if (isSelected[0]) {
                                  return LumakeyModuleList(id: widget.locationcard.id);

                                } else if (isSelected[1]) {
                                  return Center(

                                  );
                                }
                                else {
                                  return Container();
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
