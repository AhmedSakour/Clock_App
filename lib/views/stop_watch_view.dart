// pages/stopwatch_page.dart

import 'package:alarm_clock/utils/widgets/stopwatch_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/stopwatch_provider.dart';
import '../utils/themes/app_colors.dart';

class StopwatchView extends ConsumerWidget {
  const StopwatchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopwatchState = ref.watch(stopwatchProvider);
    final notifier = ref.read(stopwatchProvider.notifier);

    final elapsed = stopwatchState.elapsed;
    final seconds = elapsed.inSeconds % 60;
    final milliseconds = elapsed.inMilliseconds % 1000;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(
              'Stopwatch',
              style: TextStyle(
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                  fontSize: 24),
            ),
          ),
          const SizedBox(height: 30),
          CustomPaint(
            painter: StopwatchPainter(elapsed),
            size: const Size(300, 300),
          ),
          const SizedBox(height: 20),
          Text(
            '${elapsed.inMinutes.toString().padLeft(2, '0')}:${(seconds).toString().padLeft(2, '0')}.${(milliseconds ~/ 10).toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.replay,
                  color: AppColors.primaryTextColor,
                ),
                iconSize: 40,
                onPressed: notifier.reset,
              ),
              const SizedBox(width: 30),
              IconButton(
                icon: Icon(
                  stopwatchState.isRunning ? Icons.pause : Icons.play_arrow,
                  color: AppColors.primaryTextColor,
                ),
                iconSize: 60,
                onPressed:
                    stopwatchState.isRunning ? notifier.pause : notifier.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
