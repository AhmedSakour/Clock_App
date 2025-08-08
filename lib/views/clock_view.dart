import 'package:alarm_clock/providers/clock_provider.dart';
import 'package:alarm_clock/utils/widgets/analog_clock.dart';
import 'package:alarm_clock/utils/widgets/digital_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../utils/themes/app_colors.dart';

class ClockView extends ConsumerWidget {
  const ClockView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTimeAsync = ref.watch(currentTimeProvider);

    return currentTimeAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (now) {
        final formattedDate = DateFormat('EEE, d MMM').format(now);
        final timezoneString = now.timeZoneOffset.toString().split('.').first;
        final offsetSign = timezoneString.startsWith('-') ? '' : '+';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  'Clock',
                  style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                    fontSize: 24,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const DigitalClock(),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w300,
                        color: AppColors.primaryTextColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Align(
                  alignment: Alignment.center,
                  child: AnalogClock(
                    size: MediaQuery.of(context).size.height / 4,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Timezone',
                      style: TextStyle(
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryTextColor,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Icon(Icons.language, color: AppColors.primaryTextColor),
                        const SizedBox(width: 16),
                        Text(
                          'UTC$offsetSign$timezoneString',
                          style: TextStyle(
                            fontFamily: 'avenir',
                            color: AppColors.primaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
