//import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lumaapp/pages/modulePages/location_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../../widgets/QR_Scannercode.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/QR_Scannercode.dart';
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
  final Locationcard;
  const AddProduct({super.key, required this.Locationcard,
  });

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
  int coler =0;
  String mobile ='';
  @override
  void initState() {
    super.initState();
    futureLocationModels = fetchLocationModels();
    _loadmobile();
  }

  Future<void> _loadmobile() async {
    final prefs = await SharedPreferences.getInstance();
    mobile = (prefs.getString('mobileNumber') ?? null)!;
  }

  Future<void> addlumakeyModulesss() async {
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
        "location_id": widget.Locationcard.id,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
      coler++;
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
                      builder: (context) => LocationPage(locationcard: widget.Locationcard),
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
      throw Exception(AppLocalizations.of(context)!.error4);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
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
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.033),
                child: Text(
                  message,
                  textDirection: TextDirection.rtl,
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
                    gradient: const LinearGradient(
                        colors: [Color(0xFF055712), Color(0xFF80FF92)]),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.033),
                    border: Border.all(color: const Color(0xFF0200AB), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.taiid,
                      style: const TextStyle(
                        color: Color(0xFFE8BCB9),
                        fontSize: 18,
                        fontFamily: "Sans",
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  /*setState(() {
                    isLoading = false;
                  });*/
                },
              ),
            ],
          ),
        ),
      ),
    );
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
                      builder: (context) => LocationPage(locationcard: widget.Locationcard),
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

  /*Future<void> scanQR() async {
    // استفاده از AiBarcodeScanner به عنوان یک ویجت در یک صفحه جدید (روش پایدار)
    // این روش وابسته به متدهای استاتیک ناپایدار پکیج نیست و با بیشتر نسخه‌ها کار می‌کند.
    final String? scannedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiBarcodeScanner(
          onDetect: (BarcodeCapture capture) {
            String? result;
            if (capture.barcodes.isNotEmpty) {
              result = capture.barcodes.first.rawValue;
            }
            if (result != null) {
              Navigator.pop(context, result);
            }
          },
        ),
      ),
    );

    if (scannedData != null && scannedData.isNotEmpty) {
      try {
        final data = jsonDecode(scannedData) as Map<String, dynamic>;

        if (data.containsKey('slug') && data.containsKey('active_code')) {
           setState(() {
            textEditingController1.text = data['slug'].toString();
            textEditingController2.text = data['active_code'].toString();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('کدهای Slug و Active با موفقیت پر شدند.'), duration: Duration(seconds: 2)),
          );
        } else {
          print('JSON valid but missing "slug" or "active_code".');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('کد QR نامعتبر است: فیلدهای مورد نیاز یافت نشدند.'), duration: Duration(seconds: 3), backgroundColor: Colors.orange),
          );
        }
      } catch (e) {
        print('Failed to parse JSON: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطا در خواندن کد QR: داده‌ی JSON معتبر نیست.'), duration: Duration(seconds: 3), backgroundColor: Colors.red),
        );
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
                          if(coler == 1)
                            {
                              _showErrorDialog(AppLocalizations.of(context)!.error11);
                            }
                          else {
                            addlumakeyModulesss();
                          }
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
