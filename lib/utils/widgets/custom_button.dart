import 'package:alarm_clock/models/menu_info_model.dart';
import 'package:alarm_clock/providers/menu_info_provider.dart';
import 'package:alarm_clock/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton({
    super.key,
    required this.currentMenuInfo,
  });

  final MenuInfoModel currentMenuInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenu = ref.watch(menuInfoProvider);

    return MaterialButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
      color: currentMenuInfo.clockMenuOption == selectedMenu.clockMenuOption
          ? AppColors.menuBackgroundColor
          : AppColors.pageBackgroundColor,
      onPressed: () {
        ref.read(menuInfoProvider.notifier).updateMenu(currentMenuInfo);
      },
      child: Column(
        children: <Widget>[
          Image.asset(
            currentMenuInfo.imageSource!,
            scale: 1.5,
          ),
          const SizedBox(height: 16),
          Text(
            currentMenuInfo.title ?? '',
            style: TextStyle(
              fontFamily: 'avenir',
              color: AppColors.primaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
