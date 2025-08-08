import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/alarm_info_model.dart';
import '../utils/services/alarm_database_service.dart';
import '../utils/services/notification_service.dart';

class AlarmState {
  final List<AlarmInfoModel> alarms;
  final bool isLoading;

  AlarmState({required this.alarms, this.isLoading = false});

  AlarmState copyWith({
    List<AlarmInfoModel>? alarms,
    bool? isLoading,
  }) {
    return AlarmState(
      alarms: alarms ?? this.alarms,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AlarmNotifier extends StateNotifier<AlarmState> {
  final AlarmDatabaseService _db = AlarmDatabaseService();

  AlarmNotifier() : super(AlarmState(alarms: [])) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _db.initializeDatabase();
    loadAlarms();
  }

  Future<void> loadAlarms() async {
    state = state.copyWith(isLoading: true);
    final alarms = await _db.getAlarms();
    state = AlarmState(alarms: alarms, isLoading: false);
  }

  Future<void> deleteAlarm(int id) async {
    await NotificationService().cancelNativeAlarm();
    await _db.deleteAlarm(id);
    await loadAlarms();
  }

  Future<void> saveAlarm({
    required DateTime dateTime,
    required bool isRepeating,
  }) async {
    final alarmInfo = AlarmInfoModel(
      alarmDateTime: dateTime,
      gradientColorIndex: state.alarms.length % 4,
      title: 'alarm',
    );

    await NotificationService().saveAndScheduleAlarm(
      alarmInfo: alarmInfo,
      isRepeating: isRepeating,
      dbService: _db,
    );

    await loadAlarms();
  }
}

final alarmProvider = StateNotifierProvider<AlarmNotifier, AlarmState>((ref) {
  return AlarmNotifier();
});
