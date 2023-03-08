import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_datetime_picker/src/date_format.dart';

class GreeRouteDatePickerModel extends DateTimePickerModel {
  GreeRouteDatePickerModel({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    LocaleType? locale,
  }) : super(
          currentTime: currentTime,
          maxTime: maxTime,
          minTime: minTime,
          locale: locale,
        );

  @override
  String? middleStringAtIndex(int index) {
    String? hour = super.middleStringAtIndex(index);
    /// 修复时间为同一天的显示bug
    if (isAtSameDay(maxTime, minTime)) {
      // hour
      if (int.parse(hour ?? '0') <= (maxTime?.hour ?? 0) && int.parse(hour ?? '0') >= (minTime?.hour ?? 0)) {
        return hour == null ? null : '$hour 时';
      }
      return null;
    }
    return hour == null ? null : '$hour 时';
  }

  @override
  String? rightStringAtIndex(int index) {
    String? minute = super.rightStringAtIndex(index);
    int hour = finalTime().hour;

    /// 修复时间为同一天的显示bug
    if (isAtSameDay(maxTime, minTime)) {
      if (hour < (maxTime?.hour ?? 0)) {
        return minute == null ? null : '$minute 分';
      }
      if (int.parse(minute ?? '0') <= (maxTime?.minute ?? 0) && int.parse(minute ?? '0') >= (minTime?.minute ?? 0)) {
        return minute == null ? null : '$minute 分';
      }
      return null;
    }
    return minute == null ? null : '$minute 分';
  }

  @override
  String? leftStringAtIndex(int index) {
    DateTime time = currentTime.add(Duration(days: index));
    if (minTime != null && time.isBefore(minTime!) && !isAtSameDay(minTime!, time)) {
      return null;
    } else if (maxTime != null && time.isAfter(maxTime!) && !isAtSameDay(maxTime, time)) {
      return null;
    }
    return '${time.year}年${time.month}月${time.day}日';
  }

  @override
  List<int> layoutProportions() {
    return [2, 1, 1];
  }

  @override
  String leftDivider() {
    return '';
  }

  @override
  String rightDivider() {
    return '';
  }
}
