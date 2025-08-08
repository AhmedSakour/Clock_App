import 'package:alarm_clock/utils/themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildPicker extends StatelessWidget {
  const BuildPicker({
    super.key,
    required this.max,
    required this.label,
    required this.onChanged,
    this.initial = 0,
  });

  final int max;
  final String label;
  final Function(int) onChanged;
  final int initial;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 80,
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: initial),
            onSelectedItemChanged: onChanged,
            backgroundColor: Colors.transparent,
            children: List.generate(
              max + 1,
              (index) => Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: TextStyle(
                      fontSize: 20, color: AppColors.primaryTextColor),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          label,
          style: TextStyle(color: AppColors.primaryTextColor),
        ),
      ],
    );
  }
}
