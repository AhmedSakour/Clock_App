import 'dart:math';

import 'package:alarm_clock/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';

class StopwatchPainter extends CustomPainter {
  final Duration elapsed;
  StopwatchPainter(this.elapsed);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final paintCircle = Paint()
      ..color = AppColors.lightGreyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final paintTick = Paint()
      ..color = AppColors.primaryTextColor
      ..strokeWidth = 2;

    final paintSecondsHand = Paint()
      ..color = AppColors.greyColor
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, paintCircle);

    // Draw tick marks and numbers
    for (int i = 0; i < 60; i++) {
      double angle = (pi / 30) * i;
      final outer = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      final inner = Offset(
        center.dx + (radius - (i % 5 == 0 ? 15 : 5)) * cos(angle),
        center.dy + (radius - (i % 5 == 0 ? 15 : 5)) * sin(angle),
      );
      canvas.drawLine(inner, outer, paintTick);

      // Numbers
      if (i % 5 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i == 0 ? 60 : i}',
            style: TextStyle(fontSize: 12, color: AppColors.primaryTextColor),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final offset = Offset(
          center.dx + (radius - 30) * cos(angle) - textPainter.width / 2,
          center.dy + (radius - 30) * sin(angle) - textPainter.height / 2,
        );
        textPainter.paint(canvas, offset);
      }
    }

    // Draw seconds hand
    final secondsAngle = (pi * 2) * (elapsed.inMilliseconds % 60000) / 60000;
    final secondsHand = Offset(
      center.dx + (radius - 20) * cos(secondsAngle - pi / 2),
      center.dy + (radius - 20) * sin(secondsAngle - pi / 2),
    );
    canvas.drawLine(center, secondsHand, paintSecondsHand);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
