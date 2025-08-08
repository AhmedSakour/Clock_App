import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/alarm_provider.dart';
import '../utils/themes/app_colors.dart';

class AlarmView extends ConsumerStatefulWidget {
  const AlarmView({super.key});

  @override
  ConsumerState<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends ConsumerState<AlarmView> {
  DateTime? _alarmTime = DateTime.now();
  String _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
  bool _isRepeatSelected = false;

  @override
  Widget build(BuildContext context) {
    final alarmState = ref.watch(alarmProvider);
    final alarmNotifier = ref.read(alarmProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Alarm',
            style: TextStyle(
                fontFamily: 'avenir',
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
                fontSize: 24),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: alarmState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      ...alarmState.alarms.map((alarm) {
                        var alarmTime =
                            DateFormat('hh:mm aa').format(alarm.alarmDateTime!);
                        var gradientColor = GradientTemplate
                            .gradientTemplate[alarm.gradientColorIndex!].colors;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColor,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColor.last.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(4, 4),
                              ),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.label,
                                          color: AppColors.primaryTextColor,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          alarm.title!,
                                          style: TextStyle(
                                              color: AppColors.primaryTextColor,
                                              fontFamily: 'avenir'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  'Mon-Fri',
                                  style: TextStyle(
                                      color: AppColors.primaryTextColor,
                                      fontFamily: 'avenir'),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      alarmTime,
                                      style: TextStyle(
                                          color: AppColors.primaryTextColor,
                                          fontFamily: 'avenir',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: AppColors.primaryTextColor,
                                      onPressed: () {
                                        alarmNotifier.deleteAlarm(alarm.id!);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      if (alarmState.alarms.length < 5)
                        DottedBorder(
                          strokeWidth: 2,
                          color: AppColors.clockOutline,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(24),
                          dashPattern: const [5, 4],
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.clockBG,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24)),
                            ),
                            child: MaterialButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              onPressed: () {
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Container(
                                          height: 250,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16),
                                          child: Column(
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  var selectedTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                                  if (selectedTime != null) {
                                                    final now = DateTime.now();
                                                    var selectedDateTime =
                                                        DateTime(
                                                            now.year,
                                                            now.month,
                                                            now.day,
                                                            selectedTime.hour,
                                                            selectedTime
                                                                .minute);
                                                    _alarmTime =
                                                        selectedDateTime;
                                                    setModalState(() {
                                                      _alarmTimeString =
                                                          DateFormat('HH:mm')
                                                              .format(
                                                                  selectedDateTime);
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  _alarmTimeString,
                                                  style: const TextStyle(
                                                      fontSize: 32),
                                                ),
                                              ),
                                              ListTile(
                                                title: const Text('Repeat'),
                                                trailing: Switch(
                                                  onChanged: (value) {
                                                    setModalState(() {
                                                      _isRepeatSelected = value;
                                                    });
                                                  },
                                                  value: _isRepeatSelected,
                                                ),
                                              ),
                                              FloatingActionButton.extended(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  alarmNotifier.saveAlarm(
                                                    dateTime: _alarmTime!,
                                                    isRepeating:
                                                        _isRepeatSelected,
                                                  );
                                                },
                                                icon: const Icon(Icons.alarm),
                                                label: const Text('Save'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/add_alarm.png',
                                    scale: 1.5,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add Alarm',
                                    style: TextStyle(
                                        color: AppColors.primaryTextColor,
                                        fontFamily: 'avenir'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Center(
                          child: Text(
                            'Only 5 alarms allowed!',
                            style: TextStyle(color: AppColors.primaryTextColor),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
