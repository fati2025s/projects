import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/utils.dart' as utils;

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

class LumcyModuleList extends StatefulWidget {
  final int id;

  const LumcyModuleList({
    required this.id,
    super.key,
  });

  @override
  State<LumcyModuleList> createState() => _LumcyModuleListState();
}

class _LumcyModuleListState extends State<LumcyModuleList> {
  late Future<List<LumcyModule>> futureLumcyModules;

  @override
  void initState() {
    super.initState();
    futureLumcyModules = fetchLumcyModules(widget.id);
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
                    "لیست ماژول های روشنایی: ",
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
                child: FutureBuilder<List<LumcyModule>>(
                  future: futureLumcyModules,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final lumcyModules = snapshot.data!;
                      return ListView.builder(
                        itemCount: lumcyModules.length,
                        itemBuilder: (context, index) {
                          final lumcyModule = lumcyModules[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.100
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
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Text(
                                              "روشنایی ${lumcyModule.slug.replaceAll('0', '').padRight(2, '#')}",
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
                                        Opacity(
                                          opacity: (lumcyModule.mode == 'NF') ? 1 : 0.75,
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
                                            onTap: () => (lumcyModule.mode != 'F')
                                                ? toggleModeLumcyModule(lumcyModule, 'F')
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    (lumcyModule.mode != 'F')
                                        ? SizedBox(
                                      height: (lumcyModule.is_turn_lamp_3 == null &&
                                          lumcyModule.is_turn_lamp_4 == null)
                                          ? size.width * 0.150
                                          : size.width * 0.300,
                                      width: size.width * 0.300,
                                      child: GridView.count(
                                        crossAxisCount: 2,
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
                                                        : 'images/Shutdown.png')),
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
                                                        : 'images/Shutdown.png')),
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
                                                        : 'images/Shutdown.png')),
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
                                                        : 'images/Shutdown.png')),
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
                                            child: Container(
                                              width: size.width * 0.300,
                                              height: size.height * 0.030,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    colors: [Color(0xFF1D1A39), Color(0xFF451952)]),
                                                borderRadius: BorderRadius.circular(size.width * 0.083),
                                                border: Border.all(
                                                    color: const Color(0xFFF39F5A), width: 1),
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
                                            onTap: () => toggleIsApModeLumcyModule(lumcyModule),
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
