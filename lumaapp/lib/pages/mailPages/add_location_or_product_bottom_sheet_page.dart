import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../../widgets/QR_Scannercode.dart';
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

class AddLocationOrProduct extends StatefulWidget {
  const AddLocationOrProduct({super.key});

  @override
  State<AddLocationOrProduct> createState() => _AddLocationOrProductState();
}

class _AddLocationOrProductState extends State<AddLocationOrProduct> {
  String addDropdownButtonValue = 'محل قرارگیری محصول';
  String addLocationDropdownButtonValue = 'BedRoom';
  int? locationIdDropdownButtonValue;
  late Future<List<LocationModel>> futureLocationModels;
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

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
        "location_id": locationIdDropdownButtonValue,
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
                          Color(0xFF1D1A39),
                          Color(0xFF451952)
                        ]),
                        borderRadius:
                        BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
                        border: Border.all(
                            color: const Color(0xFF0200C9), width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF0200C9)
                                  .withOpacity(0.15),
                              offset: const Offset(4, 4),
                              blurRadius: 20,
                              spreadRadius: 10),
                        ]),
                    child: Center(
                      child: Text(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        "تایید",
                        style: TextStyle(
                          color: const Color(0xFFE8BCB9),
                          fontSize: MediaQuery.of(context).size.width * 0.053,
                          fontFamily: "Sans",
                        ),
                      ),
                    ),
                  ),
                  /*onTap: () => Navigator.pushAndRemoveUntil(
                    //todo
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
      throw Exception('Failed to add lumakeyModule');
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
        "location_id": locationIdDropdownButtonValue,
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
                          Color(0xFF1D1A39),
                          Color(0xFF451952)
                        ]),
                        borderRadius:
                        BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
                        border: Border.all(
                            color: const Color(0xFF0200C9), width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF0200C9)
                                  .withOpacity(0.15),
                              offset: const Offset(4, 4),
                              blurRadius: 20,
                              spreadRadius: 10),
                        ]),
                    child: Center(
                      child: Text(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        "تایید",
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
      throw Exception('Failed to add lumcyModule');
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
        "location": addLocationDropdownButtonValue,
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
                          Color(0xFF1D1A39),
                          Color(0xFF451952)
                        ]),
                        borderRadius:
                        BorderRadius.circular(MediaQuery.of(context).size.width * 0.033),
                        border: Border.all(
                            color: const Color(0xFF0200C9), width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF0200C9)
                                  .withOpacity(0.15),
                              offset: const Offset(4, 4),
                              blurRadius: 20,
                              spreadRadius: 10),
                        ]),
                    child: Center(
                      child: Text(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        "تایید",
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
      throw Exception('Failed to add location');
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
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(width: size.width * 0.063),
                  Text(
                    "اضافه کنید...",
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
                          "چی میخوای اضافه کنی؟",
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
                          iconDisabledColor: const Color(0xFF0200C9),
                          iconEnabledColor: const Color(0xFF0200C9),
                          isExpanded: true,
                          alignment: Alignment.centerRight,
                          value: addDropdownButtonValue,
                          items: const [
                            DropdownMenuItem(
                              value: 'محل قرارگیری محصول',
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'محل قرارگیری محصول',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'محصول ماژول روشنایی (لومسی)',
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'محصول ماژول روشنایی (لومسی)',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'محصول ماژول کولر (لوماکی)',
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'محصول ماژول کولر (لوماکی)',
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
                    if (addDropdownButtonValue != 'محل قرارگیری محصول') SizedBox(height: size.height * 0.036),
                    if (addDropdownButtonValue != 'محل قرارگیری محصول')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            (addDropdownButtonValue == 'محصول ماژول روشنایی (لومسی)')
                                ? 'محل قرارگیری ماژول لومسی:'
                                : 'محل قرارگیری ماژول لوماکی:',
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
                    if (addDropdownButtonValue != 'محل قرارگیری محصول') SizedBox(height: size.height * 0.006),
                    if (addDropdownButtonValue != 'محل قرارگیری محصول')
                      FutureBuilder<List<LocationModel>>(
                        future: futureLocationModels,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            final locationModels = snapshot.data!;
                            if (locationIdDropdownButtonValue == null && locationModels.isNotEmpty) {
                              locationIdDropdownButtonValue = locationModels.first.id;
                            }
                            return Container(
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
                                child: DropdownButton<int>(
                                  style: TextStyle(
                                    color: const Color(0xFF000000),
                                    fontFamily: "Sans",
                                    fontSize: size.width * 0.020,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  padding: EdgeInsets.only(right: size.width * 0.050),
                                  iconSize: 30,
                                  dropdownColor: const Color(0xFFD9D9D9),
                                  iconDisabledColor: const Color(0xFF0200C9),
                                  iconEnabledColor: const Color(0xFF0200C9),
                                  isExpanded: true,
                                  alignment: Alignment.centerRight,
                                  value: locationIdDropdownButtonValue,
                                  items: locationModels.map((location) {
                                    return DropdownMenuItem<int>(
                                      value: location.id,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          location.name,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  underline: const SizedBox.shrink(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      locationIdDropdownButtonValue = newValue!;
                                    });
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    if (addDropdownButtonValue != 'محل قرارگیری محصول') SizedBox(height: size.height * 0.036),
                    if (addDropdownButtonValue != 'محل قرارگیری محصول') GestureDetector(
                      child: Container(
                        width: size.width * 0.313,
                        height: size.height * 0.030,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF1D1A39), Color(0xFF451952)]),
                          borderRadius: BorderRadius.circular(size.width * 0.083),
                          border: Border.all(color: const Color(0xFF0200C9), width: 1),
                        ),
                        child: Center(
                          child: Text(
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            "اطلاعات را اسکن کنید!",
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
                          (addDropdownButtonValue == 'محل قرارگیری محصول')
                              ? 'نام محل قرارگیری محصول:'
                              : (addDropdownButtonValue == 'محصول ماژول روشنایی (لومسی)')
                              ? 'شناسه ماژول لومسی:'
                              : 'شناسه ماژول لوماکی:',
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
                          hintText: (addDropdownButtonValue == 'محل قرارگیری محصول')
                              ? 'لطفا محل قرارگیری محصول را وارد کنید.'
                              : (addDropdownButtonValue == 'محصول ماژول روشنایی (لومسی)')
                              ? 'لطفا شناسه ماژول لومسی خود را وارد کنید.'
                              : 'لطفا شناسه ماژول لوماکی خود را وارد کنید.',
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
                          (addDropdownButtonValue == 'محل قرارگیری محصول')
                              ? 'نوع محل قرارگیری محصول:'
                              : (addDropdownButtonValue == 'محصول ماژول روشنایی (لومسی)')
                              ? 'کد فعالسازی ماژول لومسی:'
                              : 'کد فعالسازی ماژول لوماکی:',
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
                    if (addDropdownButtonValue == 'محل قرارگیری محصول') SizedBox(height: size.height * 0.006),
                    if (addDropdownButtonValue == 'محل قرارگیری محصول')
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
                            iconDisabledColor: const Color(0xFF0200C9),
                            iconEnabledColor: const Color(0xFF0200C9),
                            isExpanded: true,
                            alignment: Alignment.centerRight,
                            value: addLocationDropdownButtonValue,
                            items: const [
                              DropdownMenuItem(
                                value: 'BedRoom',
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'اتاق خواب',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'BathRoom',
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'سرویس بهداشتی',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Kitchen',
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'آشپزخانه',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Hall',
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'سالن پذیرایی',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ],
                            underline: const SizedBox.shrink(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  addLocationDropdownButtonValue = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      )
                    else
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        controller: textEditingController2,
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            filled: false,
                            alignLabelWithHint: true,
                            hintText: (addDropdownButtonValue == 'محصول ماژول روشنایی (لومسی)')
                                ? 'لطفا کد فعالسازی ماژول لومسی خود را وارد کنید.'
                                : 'لطفا کد فعالسازی ماژول لوماکی خود را وارد کنید.',
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
                            gradient: const LinearGradient(colors: [Color(0xFF18401B), Color(0xFF70FF83)]),
                            borderRadius: BorderRadius.circular(size.width * 0.083),
                            border: Border.all(color: const Color(0xFF0200C9), width: 2),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF0200C9).withOpacity(0.15),
                                  offset: const Offset(4, 4),
                                  blurRadius: 20,
                                  spreadRadius: 10),
                            ]),
                        child: Center(
                          child: Text(
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            "اضافه کن",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.073,
                              fontFamily: "Sans",
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (addDropdownButtonValue == 'محل قرارگیری محصول') {
                          addLocation();
                        } else if (addDropdownButtonValue == 'محصول ماژول روشنایی (لومسی)') {
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
