import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lumaapp/pages/modulePages/location_page.dart';
//import '../../widgets/QR_Scannercode.dart';
import '../../l10n/app_localizations.dart';
import '/utils.dart' as utils;
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
//import 'app_bar_page.dart';

class LocationModel {
  final int id;
  final String name;

  LocationModel({
    required this.id,
    required this.name,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

Future<List<LocationModel>> fetchLocationModels() async {
  final response = await http.get(
    Uri.parse('${utils.serverAddress}/products/location/generics'),
    headers: {
      'Authorization': 'Token ${utils.token}',
    },
  );
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((json) => LocationModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load models');
  }
}

class AddProduct extends StatefulWidget {
  final String mobileNumber;
  final Locationcard;
  const AddProduct({super.key, required this.Locationcard, required this.mobileNumber});

  @override
  State<AddProduct> createState() => _AddLocationOrProductState();
}

class _AddLocationOrProductState extends State<AddProduct> {
  String addDropdownButtonValue = 'محصول ماژول روشنایی (لومسی)';
  int? locationIdDropdownButtonValue;
  late Future<List<LocationModel>> futureLocationModels;
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  String locationcardname = "";

  Future<void> addLumakeyModule() async {
    final url = Uri.parse('${utils.serverAddress}/products/lumakey/active');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "slug": textEditingController1.text,
        "active_code": textEditingController2.text,
        "location_id": widget.Locationcard.location,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(0),
          content: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.033),
                  child: Text(
                    textDirection: TextDirection.rtl,
                    utf8.decode(response.bodyBytes).replaceAll('"', ''),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.043,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.060,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color(0xFF004508),
                          Color(0xFF47FF5C)
                        ]),
                        borderRadius:
                        BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
                        border: Border.all(
                            color: const Color(0xFF0008AB), width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF0008AB)
                                  .withOpacity(0.15),
                              offset: const Offset(4, 4),
                              blurRadius: 20,
                              spreadRadius: 10),
                        ]),
                    child: Center(
                      child: Text(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.taiid,
                        style: TextStyle(
                          color: const Color(0xFFE8BCB9),
                          fontSize: MediaQuery.of(context).size.width * 0.053,
                          fontFamily: "Sans",
                        ),
                      ),
                    ),
                  ),
                  /*onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppBarPage(),
                    ),
                        (route) => false,
                  ),*/
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      throw Exception(AppLocalizations.of(context)!.error4);
    }
  }

  Future<void> addLumcyModule() async {
    final url = Uri.parse('${utils.serverAddress}/products/lumcy/active');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "slug": textEditingController1.text,
        "active_code": textEditingController2.text,
        "location_id": widget.Locationcard.id,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(0),
          content: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.033),
                  child: Text(
                    textDirection: TextDirection.rtl,
                    utf8.decode(response.bodyBytes).replaceAll('"', ''),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.043,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.060,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color(0xFF004508),
                          Color(0xFF47FF5C)
                        ]),
                        borderRadius:
                        BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
                        border: Border.all(
                            color: const Color(0xFF0008AB), width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF0008AB)
                                  .withOpacity(0.15),
                              offset: const Offset(4, 4),
                              blurRadius: 20,
                              spreadRadius: 10),
                        ]),
                    child: Center(
                      child: Text(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.taiid,
                        style: TextStyle(
                          color: const Color(0xFFE8BCB9),
                          fontSize: MediaQuery.of(context).size.width * 0.053,
                          fontFamily: "Sans",
                        ),
                      ),
                    ),
                  ),
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationPage(locationcard: widget.Locationcard, mobileNumber: widget.mobileNumber),
                    ),
                        (route) => false,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      throw Exception(AppLocalizations.of(context)!.error5);
    }
  }

  Future<void> addLocation() async {
    final url = Uri.parse('${utils.serverAddress}/products/location/add');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token ${utils.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": textEditingController1.text,
        "location": widget.Locationcard.location,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(0),
          content: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.033),
                  child: Text(
                    textDirection: TextDirection.rtl,
                    utf8.decode(response.bodyBytes).replaceAll('"', ''),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.043,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.060,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color(0xFF004508),
                          Color(0xFF47FF5C)
                        ]),
                        borderRadius:
                        BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
                        border: Border.all(
                            color: const Color(0xFF0008AB), width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF0008AB)
                                  .withOpacity(0.15),
                              offset: const Offset(4, 4),
                              blurRadius: 20,
                              spreadRadius: 10),
                        ]),
                    child: Center(
                      child: Text(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.taiid,
                        style: TextStyle(
                          color: const Color(0xFFE8BCB9),
                          fontSize: MediaQuery.of(context).size.width * 0.053,
                          fontFamily: "Sans",
                        ),
                      ),
                    ),
                  ),
                  /*onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppBarPage(),
                    ),
                        (route) => false,
                  ),*/
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      throw Exception(AppLocalizations.of(context)!.error3);
    }
  }

  @override
  void initState() {
    super.initState();
    futureLocationModels = fetchLocationModels();
  }

  /*Future<void> scanQR() async {
    final scannedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrScannerPage()),
    );

    if (scannedData != null) {
      try {
        final data = jsonDecode(scannedData) as Map<String, dynamic>;
        if (data.containsKey('slug') && data.containsKey('active_code')) {
          setState(() {
            textEditingController1.text = data['slug'];
            textEditingController2.text = data['active_code'];
          });
        }
      } catch (e) {
        // اگر JSON معتبر نبود
        print('Failed to parse JSON.');
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: const Color(0xFFD9D9D9).withOpacity(0),
      backgroundColor: const Color(0xFFD9D9D9).withOpacity(0),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
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
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(width: size.width * 0.063),
                  Text(
                    AppLocalizations.of(context)!.add,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFF1D1A39),
                      fontFamily: "Sans",
                      fontSize: size.width * 0.053,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.015,
                  horizontal: size.width * 0.100,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.add1,
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
                    SizedBox(height: size.height * 0.006),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.5),
                            offset: const Offset(4, 4),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButton<String>(
                          style: TextStyle(
                            color: const Color(0xFF000000),
                            fontFamily: "Sans",
                            fontSize: size.width * 0.020,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          padding: EdgeInsets.only(right: size.width * 0.050),
                          iconSize: 30,
                          dropdownColor: const Color(0xFFD9D9D9),
                          iconDisabledColor: const Color(0xFF0008AB),
                          iconEnabledColor: const Color(0xFF0008AB),
                          isExpanded: true,
                          alignment: Alignment.centerRight,
                          value: addDropdownButtonValue,
                          items: [
                            DropdownMenuItem(
                              value: AppLocalizations.of(context)!.lamp,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  AppLocalizations.of(context)!.lamp,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppLocalizations.of(context)!.coler,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  AppLocalizations.of(context)!.coler,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                          underline: const SizedBox.shrink(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                addDropdownButtonValue = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            (addDropdownButtonValue == AppLocalizations.of(context)!.lamp)
                                ? AppLocalizations.of(context)!.lamp1
                                : AppLocalizations.of(context)!.coler1,
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
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "${widget.Locationcard.location}",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF1D1A39),
                        fontFamily: "Sans",
                        fontSize: size.width * 0.033,
                      ),
                    ),


                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      child: Container(
                        width: size.width * 0.313,
                        height: size.height * 0.030,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF004508), Color(0xFF47FF5C)]),
                          borderRadius: BorderRadius.circular(size.width * 0.083),
                          border: Border.all(color: const Color(0xFF0008AB), width: 1),
                        ),
                        child: Center(
                          child: Text(
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            AppLocalizations.of(context)!.scan,
                            style: TextStyle(
                              color: const Color(0xFFE8BCB9),
                              fontSize: size.width * 0.025,
                              fontFamily: "Sans",
                            ),
                          ),
                        ),
                      ),
                      //onTap: () => scanQR(),
                    ),
                    SizedBox(height: size.height * 0.036),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          (addDropdownButtonValue == AppLocalizations.of(context)!.lamp)
                          ? AppLocalizations.of(context)!.lamp2
                            : AppLocalizations.of(context)!.coler2,

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
                    TextFormField(
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      controller: textEditingController1,
                      decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          filled: false,
                          alignLabelWithHint: true,
                          hintText: (addDropdownButtonValue == AppLocalizations.of(context)!.lamp)
                              ? AppLocalizations.of(context)!.lamp3
                              : AppLocalizations.of(context)!.coler3,

                          hintTextDirection: TextDirection.rtl,
                          hintStyle: TextStyle(
                              fontSize: size.width * 0.025,
                              fontFamily: 'Sans',
                              color: const Color(0xFF1D1A39).withOpacity(0.5))),
                    ),
                    SizedBox(height: size.height * 0.036),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          (addDropdownButtonValue == AppLocalizations.of(context)!.lamp)
                              ? AppLocalizations.of(context)!.lamp4
                              : AppLocalizations.of(context)!.coler4,

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
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        controller: textEditingController2,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: false,
                            alignLabelWithHint: true,
                            hintText: (addDropdownButtonValue == AppLocalizations.of(context)!.lamp)
                                ? AppLocalizations.of(context)!.lamp5
                                : AppLocalizations.of(context)!.coler5,
                            hintTextDirection: TextDirection.rtl,
                            hintStyle: TextStyle(
                                fontSize: size.width * 0.025,
                                fontFamily: 'Sans',
                                color: const Color(0xFF1D1A39).withOpacity(0.5))),
                      ),
                    SizedBox(height: size.height * 0.036),
                    GestureDetector(
                      child: Container(
                        width: size.width * 0.750,
                        height: size.height * 0.079,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF004508), Color(0xFF47FF5C)]),
                            borderRadius: BorderRadius.circular(size.width * 0.083),
                            border: Border.all(color: const Color(0xFF0008AB), width: 2),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF0008AB).withOpacity(0.15),
                                  offset: const Offset(4, 4),
                                  blurRadius: 20,
                                  spreadRadius: 10),
                            ]),
                        child: Center(
                          child: Text(
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            AppLocalizations.of(context)!.add6,
                            style: TextStyle(
                              color: const Color(0xFFE8BCB9),
                              fontSize: size.width * 0.073,
                              fontFamily: "Sans",
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (addDropdownButtonValue == AppLocalizations.of(context)!.lamp) {
                          addLumcyModule();
                        } else {
                          addLumakeyModule();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
