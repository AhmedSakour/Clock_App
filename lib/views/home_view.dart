import 'package:alarm_clock/models/menu_info_model.dart';
import 'package:alarm_clock/utils/widgets/custom_button.dart';
import 'package:alarm_clock/views/stop_watch_view.dart';
import 'package:alarm_clock/views/timer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/clock_menu_option.dart';
import '../providers/menu_info_provider.dart';
import '../utils/themes/app_colors.dart';
import 'alarm_view.dart';
import 'clock_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final menuInfo = ref.watch(menuInfoProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: menuItems
                  .map((currentMenuInfo) =>
                      CustomButton(currentMenuInfo: currentMenuInfo))
                  .toList(),
            ),
            VerticalDivider(
              color: AppColors.dividerColor,
              width: 1,
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (menuInfo.clockMenuOption == ClockMenuOption.clock) {
                    return const ClockView();
                  } else if (menuInfo.clockMenuOption ==
                      ClockMenuOption.alarm) {
                    return const AlarmView();
                  } else if (menuInfo.clockMenuOption ==
                      ClockMenuOption.timer) {
                    return const TimerView();
                  } else {
                    return const StopwatchView();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<MenuInfoModel> menuItems = [
  MenuInfoModel(ClockMenuOption.clock,
      title: 'Clock', imageSource: 'assets/images/clock_icon.png'),
  MenuInfoModel(ClockMenuOption.alarm,
      title: 'Alarm', imageSource: 'assets/images/alarm_icon.png'),
  MenuInfoModel(ClockMenuOption.timer,
      title: 'Timer', imageSource: 'assets/images/timer_icon.png'),
  MenuInfoModel(ClockMenuOption.stopwatch,
      title: 'Stopwatch', imageSource: 'assets/images/stopwatch_icon.png'),
];
