import 'dart:async';

import 'package:alarm_clock/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock({super.key});

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late Timer _timer;
  String _formattedTime = DateFormat('HH:mm').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final previousMinute = now.subtract(const Duration(seconds: 1)).minute;
      if (previousMinute != now.minute) {
        setState(() {
          _formattedTime = DateFormat('HH:mm').format(now);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedTime,
      style: TextStyle(
        fontFamily: 'avenir',
        color: AppColors.primaryTextColor,
        fontSize: 64,
      ),
    );
  }
}
