/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// این کلاس به عنوان یک صفحه جدید برای اسکن QR کد عمل می‌کند.
class QrScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اسکنر QR کد'),
      ),
      body: MobileScanner(
        // در نسخه جدید، 'onDetect' یک شیء 'capture' را برمی‌گرداند
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;

          if (barcodes.isNotEmpty) {
            final String? scannedData = barcodes.first.rawValue;

            // سعی می‌کنیم داده اسکن شده را به JSON تبدیل کنیم
            try {
              if (scannedData != null) {
                final Map<String, dynamic> data = jsonDecode(scannedData);
                // اگر JSON معتبر بود، آن را به صفحه اصلی برمی‌گردانیم
                Navigator.pop(context, data);
              } else {
                // اگر داده‌ای وجود نداشت، یک پیام خطا برمی‌گردانیم.
                Navigator.pop(context, {'error': 'Failed to get QR data.'});
              }
            } catch (e) {
              // اگر JSON معتبر نبود، یک پیام خطا برمی‌گردانیم.
              Navigator.pop(context, {'error': 'Failed to parse JSON.'});
            }
          }
        },
      ),
    );
  }
}*/