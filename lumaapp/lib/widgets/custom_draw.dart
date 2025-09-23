import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class CustomArc extends StatelessWidget {
  const CustomArc({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomPaint(
      painter: CustomArcPainter(),
      size: Size(size.width * 0.625, size.width * 0.625),
    );
  }
}

class CustomArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = size.width * 0.083
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    var path = Path()
      ..moveTo(0, size.height / 2)
      ..addArc(
          Rect.fromCenter(
              center: Offset(size.height / 2, size.width / 2),
              width: size.width + size.width * 0.083,
              height: size.height + size.width * 0.083),
          3 * pi / 4,
          3 * pi / 2);

    Path dashPath = Path();
    double dashWidth = size.width * 0.067;
    double dashSpace = size.width * 0.347;
    double distance = size.width * 0.003;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(pathMetric.extractPath(distance, distance + dashWidth),
            Offset.zero);
        distance += dashWidth;
        distance += dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
