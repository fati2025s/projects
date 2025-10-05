import 'package:flutter/material.dart';

// ایمپورت ویجت‌هایی که قرار است در Bottom Sheet نمایش داده شوند
import 'package:lumaapp/pages/mainPages/add_location.dart';
import 'package:lumaapp/pages/modulePages/lumcy_module_list_bottom_sheet_page.dart';
import 'package:lumaapp/pages/modulePages/lumakey_module_list_bottom_sheet_page.dart';

// تعریف کلاس تنظیمات (فقط یک بار اینجا تعریف شود)
class TnBottomSheetSettings {
  final BoxConstraints? constraints;
  final bool isScrollControlled;
  final bool isDismisable;

  const TnBottomSheetSettings({
    this.constraints,
    this.isScrollControlled = false,
    this.isDismisable = true,
  });
}


// تعریف Extension (فقط یک بار اینجا تعریف شود)
extension BuildContextTnBottomSheetNav on BuildContext {
  Future<T?> showTnBottomSheetNav<T>(
      String route, {
        required TnBottomSheetSettings settings,
        required Map<String, dynamic> params,
      }) {
    Widget? child;
    // استخراج پارامترهای احتمالی:
    final String mobileNumber = params.containsKey('mobileNumber') ? params['mobileNumber'] as String : '';
    final int locationId = params.containsKey('id') ? params['id'] as int : 0;

    switch (route) {
      case 'AddLocationOrProduct':
        child = AddLocationOrProduct(mobileNumber : mobileNumber);
        break;
      case 'LumcyModuleList': // 👈 مسیر جدید ماژول روشنایی
        child = LumcyModuleList(id: locationId);
        break;
      case 'LumakeyModuleList': // 👈 مسیر جدید ماژول تهویه
        child = LumakeyModuleList(id: locationId);
        break;
      default:
        child = null;
    }

    if (child == null) {
      debugPrint('TnBottomSheet: route "$route" not found.');
      return Future.value(null);
    }

    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: settings.isScrollControlled,
      isDismissible: settings.isDismisable,
      enableDrag: settings.isDismisable,
      constraints: settings.constraints,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: child!,
        );
      },
    );
  }
}