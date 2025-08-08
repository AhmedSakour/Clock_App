import 'package:alarm_clock/models/clock_menu_option.dart';
import 'package:alarm_clock/models/menu_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuInfoNotifier extends StateNotifier<MenuInfoModel> {
  MenuInfoNotifier(super.state);

  void updateMenu(MenuInfoModel menuInfo) {
    state = menuInfo;
  }
}

final menuInfoProvider =
    StateNotifierProvider<MenuInfoNotifier, MenuInfoModel>((ref) {
  return MenuInfoNotifier(MenuInfoModel(ClockMenuOption.clock));
});
