// views/timer_view.dart

import 'package:alarm_clock/utils/widgets/build_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/timer_provider.dart';
import '../utils/themes/app_colors.dart';

class TimerView extends ConsumerWidget {
  const TimerView({super.key});

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(duration.inHours);
    final m = twoDigits(duration.inMinutes.remainder(60));
    final s = twoDigits(duration.inSeconds.remainder(60));
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Timer',
            style: TextStyle(
              fontFamily: 'avenir',
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
              fontSize: 24,
            ),
          ),
          Center(
            child: Text(
              formatTime(timerState.remaining),
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor),
            ),
          ),
          const SizedBox(height: 30),

          // Time Pickers
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BuildPicker(
                max: 99,
                label: "Hours",
                initial: timerState.selectedHours,
                onChanged: (val) => timerNotifier.updateSelectedHours(val),
              ),
              BuildPicker(
                max: 59,
                label: "Minutes",
                initial: timerState.selectedMinutes,
                onChanged: (val) => timerNotifier.updateSelectedMinutes(val),
              ),
              BuildPicker(
                max: 59,
                label: "Seconds",
                initial: timerState.selectedSeconds,
                onChanged: (val) => timerNotifier.updateSelectedSeconds(val),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  timerState.isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
                onPressed: () {
                  if (timerState.isRunning) {
                    timerNotifier.pause();
                  } else {
                    timerNotifier.start();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh,
                    color: AppColors.primaryTextColor, size: 36),
                onPressed: timerNotifier.reset,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
