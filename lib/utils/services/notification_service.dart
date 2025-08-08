import 'package:alarm_clock/models/alarm_info_model.dart';
import 'package:alarm_clock/utils/services/alarm_database_service.dart';
import 'package:flutter/services.dart';

class NotificationService {
  static const platform = MethodChannel('com.example.alarm_clock/alarm');

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> scheduleNativeAlarm(DateTime dateTime) async {
    final timeMillis = dateTime.millisecondsSinceEpoch;

    try {
      await platform.invokeMethod('scheduleNativeAlarm', {'time': timeMillis});
      print('Native alarm scheduled');
    } catch (e) {
      print('Failed to schedule alarm: $e');
    }
  }

  Future<void> cancelNativeAlarm() async {
    try {
      await platform.invokeMethod('cancelNativeAlarm');
    } catch (e) {
      print('Failed to cancel native alarm: $e');
    }
  }

  Future<void> saveAndScheduleAlarm({
    required AlarmInfoModel alarmInfo,
    required bool isRepeating,
    required AlarmDatabaseService dbService,
  }) async {
    DateTime now = DateTime.now();
    DateTime scheduledDateTime = alarmInfo.alarmDateTime!;
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    dbService.insertAlarm(alarmInfo);
    NotificationService().scheduleNativeAlarm(scheduledDateTime);
  }
}
