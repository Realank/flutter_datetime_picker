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
    return hour == null ? null : '$hour 时';
  }

  @override
  String? rightStringAtIndex(int index) {
    String? min = super.rightStringAtIndex(index);
    return min == null ? null : '$min 分';
  }

  @override
  String? leftStringAtIndex(int index) {
    DateTime time = currentTime.add(Duration(days: index));
    if (minTime != null &&
        time.isBefore(minTime!) &&
        !isAtSameDay(minTime!, time)) {
      return null;
    } else if (maxTime != null &&
        time.isAfter(maxTime!) &&
        !isAtSameDay(maxTime, time)) {
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
