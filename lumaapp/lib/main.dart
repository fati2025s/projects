import 'package:flutter/material.dart';
import 'package:lumaapp/pages/mailPages/add_location_or_product_bottom_sheet_page.dart';
import 'package:tn_bottom_sheet_navigator/core/entities/tn_bottom_sheet_route.dart';
import 'package:tn_bottom_sheet_navigator/core/tn_router.dart';
import 'package:tn_bottom_sheet_navigator/tn_bottom_sheet_navigator.dart';
import 'pages/startPages/welcome_page.dart';
//import 'package:tn_bottom_sheet_navigator/tn_bottom_sheet_navigator.dart';
//import 'pages/modulePages/lumcy_module_list_bottom_sheet_page.dart';
//import 'pages/modulePages/lumakey_module_list_bottom_sheet_page.dart';
//import 'pages/mainPages/add_location_or_product_bottom_sheet_page.dart';

void main() {
  TnRouter().setRoutes([
  TnBottomSheetRoute(
    path: 'AddLocationOrProduct',
    builder: (context, params) => const AddLocationOrProduct(),
  ),
  ]);
  /*8
    TnBottomSheetRoute(
      path: 'LumcyModuleList',
      builder: (context, params) => LumcyModuleList(id: params['id'],),
    ),
    TnBottomSheetRoute(
      path: 'LumakeyModuleList',
      builder: (context, params) => LumakeyModuleList(id: params['id'],),
    ),

  ]);*/
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}