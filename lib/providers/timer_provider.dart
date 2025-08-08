import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final Duration remaining;
  final bool isRunning;
  final int selectedHours;
  final int selectedMinutes;
  final int selectedSeconds;

  const TimerState({
    this.remaining = Duration.zero,
    this.isRunning = false,
    this.selectedHours = 0,
    this.selectedMinutes = 0,
    this.selectedSeconds = 0,
  });

  TimerState copyWith({
    Duration? remaining,
    bool? isRunning,
    int? selectedHours,
    int? selectedMinutes,
    int? selectedSeconds,
  }) {
    return TimerState(
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      selectedHours: selectedHours ?? this.selectedHours,
      selectedMinutes: selectedMinutes ?? this.selectedMinutes,
      selectedSeconds: selectedSeconds ?? this.selectedSeconds,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(const TimerState());

  Timer? _timer;

  void updateSelectedHours(int hours) {
    state = state.copyWith(selectedHours: hours);
  }

  void updateSelectedMinutes(int minutes) {
    state = state.copyWith(selectedMinutes: minutes);
  }

  void updateSelectedSeconds(int seconds) {
    state = state.copyWith(selectedSeconds: seconds);
  }

  void start() {
    if (state.isRunning) return;

    final hasRemaining = state.remaining.inSeconds > 0;
    final totalSeconds = state.selectedHours * 3600 +
        state.selectedMinutes * 60 +
        state.selectedSeconds;

    if (!hasRemaining && totalSeconds == 0) return;

    final initialRemaining =
        hasRemaining ? state.remaining : Duration(seconds: totalSeconds);

    state = state.copyWith(
      remaining: initialRemaining,
      isRunning: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remaining.inSeconds > 0) {
        state = state.copyWith(
          remaining: state.remaining - const Duration(seconds: 1),
        );
      } else {
        _timer?.cancel();
        state = state.copyWith(isRunning: false);
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = const TimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});
