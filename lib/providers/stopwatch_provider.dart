import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class StopwatchState {
  final Duration elapsed;
  final bool isRunning;

  const StopwatchState({
    required this.elapsed,
    required this.isRunning,
  });

  StopwatchState copyWith({
    Duration? elapsed,
    bool? isRunning,
  }) {
    return StopwatchState(
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class StopwatchNotifier extends StateNotifier<StopwatchState> {
  StopwatchNotifier()
      : super(const StopwatchState(elapsed: Duration.zero, isRunning: false)) {
    _timer = Timer.periodic(const Duration(milliseconds: 30), _tick);
  }

  late final Timer _timer;
  final Stopwatch _stopwatch = Stopwatch();

  void _tick(Timer timer) {
    if (_stopwatch.isRunning) {
      state = state.copyWith(elapsed: _stopwatch.elapsed);
    }
  }

  void start() {
    _stopwatch.start();
    state = state.copyWith(isRunning: true);
  }

  void pause() {
    _stopwatch.stop();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _stopwatch.reset();
    state = const StopwatchState(elapsed: Duration.zero, isRunning: false);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

final stopwatchProvider =
    StateNotifierProvider<StopwatchNotifier, StopwatchState>(
        (ref) => StopwatchNotifier());
