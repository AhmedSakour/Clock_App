import 'package:alarm_clock/models/clock_menu_option.dart';

class MenuInfoModel {
  final ClockMenuOption clockMenuOption;
  final String? title;
  final String? imageSource;

  MenuInfoModel(this.clockMenuOption, {this.title, this.imageSource});

  MenuInfoModel copyWith({
    ClockMenuOption? clockMenuOption,
    String? title,
    String? imageSource,
  }) {
    return MenuInfoModel(
      clockMenuOption ?? this.clockMenuOption,
      title: title ?? this.title,
      imageSource: imageSource ?? this.imageSource,
    );
  }
}
