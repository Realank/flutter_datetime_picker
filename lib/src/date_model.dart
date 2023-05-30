
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/src/date_format.dart';
import 'package:flutter_datetime_picker/src/i18n_model.dart';

import 'datetime_util.dart';

//interface for picker data model
abstract class BasePickerModel {
  //a getter method for left column data, return null to end list
  //ADD: runa
  String? veryLeftStringAtIndex(int index);

  String? leftStringAtIndex(int index);

  //a getter method for middle column data, return null to end list
  String? middleStringAtIndex(int index);

  //a getter method for right column data, return null to end list
  String? rightStringAtIndex(int index);

  //ADD:Runa
  void setveryLeftIndex(int index);

  //set selected left index
  void setLeftIndex(int index);

  //set selected middle index
  void setMiddleIndex(int index);

  //set selected right index
  void setRightIndex(int index);

  //ADD: Runa
  int currentveryLeftIndex();

  //return current left index
  int currentLeftIndex();

  //return current middle index
  int currentMiddleIndex();

  //return current right index
  int currentRightIndex();

  //return final time
  DateTime? finalTime();

  //return left divider string
  String leftDivider();

  //return right divider string
  String rightDivider();

  //layout proportions for 3 columns
  List<int> layoutProportions();
}

//a base class for picker data model
class CommonPickerModel extends BasePickerModel {


  //ADD:Runa
  late List<String> veryLeftList;
  late List<String> leftList;
  late List<String> middleList;
  late List<String> rightList;
  late DateTime currentTime;

  //ADD:Runa
  late int _currentveryLeftIndex;
  late int _currentLeftIndex;
  late int _currentMiddleIndex;
  late int _currentRightIndex;

  late LocaleType locale;

  CommonPickerModel({LocaleType? locale})
      : this.locale = locale ?? LocaleType.en;

  //ADD:Runa
  @override
  String? veryLeftStringAtIndex(int index) {
    return null;
  }

  @override
  String? leftStringAtIndex(int index) {
    return null;
  }

  @override
  String? middleStringAtIndex(int index) {
    return null;
  }

  @override
  String? rightStringAtIndex(int index) {
    return null;
  }

  //ADD:Runa
  @override
  int currentveryLeftIndex() {
    return _currentveryLeftIndex;
  }

  @override
  int currentLeftIndex() {
    return _currentLeftIndex;
  }

  @override
  int currentMiddleIndex() {
    return _currentMiddleIndex;
  }

  @override
  int currentRightIndex() {
    return _currentRightIndex;
  }

  //ADD:Runa
  @override
  void setveryLeftIndex(int index) {
    _currentveryLeftIndex = index;
  }

  @override
  void setLeftIndex(int index) {
    _currentLeftIndex = index;
  }

  @override
  void setMiddleIndex(int index) {
    _currentMiddleIndex = index;
  }

  @override
  void setRightIndex(int index) {
    _currentRightIndex = index;
  }

  //ADD:Runa
  @override
  String veryleftDivider() {
    return "";
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return "";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1, 1];
  }

  @override
  DateTime? finalTime() {
    return null;
  }
}

//a date picker model
class DatePickerModel extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;

  DatePickerModel({DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    LocaleType? locale})
      : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    currentTime = currentTime ?? DateTime.now();

    if (currentTime.compareTo(this.maxTime) > 0) {
      currentTime = this.maxTime;
    } else if (currentTime.compareTo(this.minTime) < 0) {
      currentTime = this.minTime;
    }

    this.currentTime = currentTime;

    //ADD:Runa
    _fillveryLeftLists();
    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();
    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    //ADD:Runa
    _currentveryLeftIndex = this.currentTime.year - this.minTime.year; //todo:runa
    _currentLeftIndex = this.currentTime.year - this.minTime.year;
    _currentMiddleIndex = this.currentTime.month - minMonth;
    _currentRightIndex = this.currentTime.day - minDay;
  }

  //ADD:Runa
  void _fillveryLeftLists() {
    this.leftList = List.generate(maxTime.day - minTime.day + 1, (int index) {
      // print('LEFT LIST... ${minTime.year + index}${_localeYear()}');
      return '${minTime.day + index}${_localeYear()}';
    });
  } //TODO:runa _localeYear()?した3ブロック

  void _fillLeftLists() {
    this.leftList = List.generate(maxTime.year - minTime.year + 1, (int index) {
      // print('LEFT LIST... ${minTime.year + index}${_localeYear()}');
      return '${minTime.year + index}${_localeYear()}';
    });
  }

  int _maxMonthOfCurrentYear() {
    return currentTime.year == maxTime.year ? maxTime.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime.year == minTime.year ? minTime.month : 1;
  }

  int _maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime.year, currentTime.month);
    return currentTime.year == maxTime.year &&
        currentTime.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime.year == minTime.year &&
        currentTime.month == minTime.month
        ? minTime.day
        : 1;
  }

  void _fillMiddleLists() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    this.middleList = List.generate(maxMonth - minMonth + 1, (int index) {
      return '${_localeMonth(minMonth + index)}';
    });
  }

  void _fillRightLists() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();
    this.rightList = List.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}${_localeDay()}';
    });
  }

  //ADD:Runa //TODO:Runa
  @override
  void setveryLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newTime = currentTime.isUtc
          ? DateTime.utc(
        destYear,
        currentTime.month,
        calcDateCount(destYear, 2),
      )
          : DateTime(
        destYear,
        currentTime.month,
        calcDateCount(destYear, 2),
      );
    } else {
      newTime = currentTime.isUtc
          ? DateTime.utc(
        destYear,
        currentTime.month,
        currentTime.day,
      )
          : DateTime(
        destYear,
        currentTime.month,
        currentTime.day,
      );
    }
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    _fillRightLists();
    minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentMiddleIndex = currentTime.month - minMonth;
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newTime = currentTime.isUtc
          ? DateTime.utc(
        destYear,
        currentTime.month,
        calcDateCount(destYear, 2),
      )
          : DateTime(
        destYear,
        currentTime.month,
        calcDateCount(destYear, 2),
      );
    } else {
      newTime = currentTime.isUtc
          ? DateTime.utc(
        destYear,
        currentTime.month,
        currentTime.day,
      )
          : DateTime(
        destYear,
        currentTime.month,
        currentTime.day,
      );
    }
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    _fillRightLists();
    minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentMiddleIndex = currentTime.month - minMonth;
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    //adjust right
    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
      currentTime.year,
      destMonth,
      currentTime.day <= dayCount ? currentTime.day : dayCount,
    )
        : DateTime(
      currentTime.year,
      destMonth,
      currentTime.day <= dayCount ? currentTime.day : dayCount,
    );
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillRightLists();
    int minDay = _minDayOfCurrentMonth();
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    int minDay = _minDayOfCurrentMonth();
    currentTime = currentTime.isUtc
        ? DateTime.utc(
      currentTime.year,
      currentTime.month,
      minDay + index,
    )
        : DateTime(
      currentTime.year,
      currentTime.month,
      minDay + index,
    );
  }

  //ADD:Runa
  @override
  String? veryLeftStringAtIndex(int index) {
    if (index >= 0 && index < veryLeftList.length) {
      return veryLeftList[index];
    } else {
      return null;
    }
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  String _localeYear() {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '年';
    } else if (locale == LocaleType.ko) {
      return '년';
    } else {
      return '';
    }
  }

  String _localeMonth(int month) {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '$month月';
    } else if (locale == LocaleType.ko) {
      return '$month월';
    } else {
      List monthStrings = i18nObjInLocale(locale)['monthLong'] as List<String>;
      return monthStrings[month - 1];
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '日';
    } else if (locale == LocaleType.ko) {
      return '일';
    } else {
      return '';
    }
  }

  @override
  DateTime finalTime() {
    return currentTime;
  }
}

//a time picker model
class TimePickerModel extends CommonPickerModel {
  bool showSecondsColumn;

  TimePickerModel(
      {DateTime? currentTime, LocaleType? locale, this.showSecondsColumn: true})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();

    //ADD:Runa
    _currentveryLeftIndex = this.currentTime.day;
    _currentLeftIndex = this.currentTime.hour;
    _currentMiddleIndex = this.currentTime.minute;
    _currentRightIndex = this.currentTime.second;
  }

  //ADD:Runa todo
  @override
  String? veryLeftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return ":";
  }

  @override
  String rightDivider() {
    if (showSecondsColumn)
      return ":";
    else
      return "::";
  }

  //todo: runa ??
  @override
  List<int> layoutProportions() {
    if (showSecondsColumn)
      return [1, 1, 1 ,1];
    else
      return [1, 1, 1, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
        _currentLeftIndex, _currentMiddleIndex, _currentRightIndex)
        : DateTime(currentTime.year, currentTime.month, currentTime.day,
        _currentLeftIndex, _currentMiddleIndex, _currentRightIndex);
  }
}


//a time picker model
class Time12hPickerModel extends CommonPickerModel {
  Time12hPickerModel({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();

    _currentLeftIndex = this.currentTime.hour % 12;
    _currentMiddleIndex = this.currentTime.minute;
    _currentRightIndex = this.currentTime.hour < 12 ? 0 : 1;
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 12) {
      if (index == 0) {
        return digits(12, 2);
      } else {
        return digits(index, 2);
      }
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index == 0) {
      return i18nObjInLocale(this.locale)["am"] as String?;
    } else if (index == 1) {
      return i18nObjInLocale(this.locale)["pm"] as String?;
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return ":";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }

  @override
  DateTime finalTime() {
    int hour = _currentLeftIndex + 12 * _currentRightIndex;
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
        hour, _currentMiddleIndex, 0)
        : DateTime(currentTime.year, currentTime.month, currentTime.day, hour,
        _currentMiddleIndex, 0);
  }
}

@override

DateTimePickerModel model = DateTimePickerModel();
int rightIndex = model._currentRightIndex;
// a date&time picker model //todo:


class DateTimePickerModel extends CommonPickerModel {
  DateTime? maxTime;
  DateTime? minTime;

  DateTimePickerModel({DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    LocaleType? locale})
      : super(locale: locale) {
    if (currentTime != null) {
      this.currentTime = currentTime;
      if (maxTime != null &&
          (currentTime.isBefore(maxTime) ||
              currentTime.isAtSameMomentAs(maxTime))) {
        this.maxTime = maxTime;
      }
      if (minTime != null &&
          (currentTime.isAfter(minTime) ||
              currentTime.isAtSameMomentAs(minTime))) {
        this.minTime = minTime;
      }
    } else {
      this.maxTime = maxTime;
      this.minTime = minTime;
      var now = DateTime.now();
      if (this.minTime != null && this.minTime!.isAfter(now)) {
        this.currentTime = this.minTime!;
      } else if (this.maxTime != null && this.maxTime!.isBefore(now)) {
        this.currentTime = this.maxTime!;
      } else {
        this.currentTime = now;
      }
    }

    if (this.minTime != null &&
        this.maxTime != null &&
        this.maxTime!.isBefore(this.minTime!)) {
      // invalid
      this.minTime = null;
      this.maxTime = null;
    }

    _currentveryLeftIndex = 0;
    _currentLeftIndex = this.currentTime.hour % 12;
    _currentMiddleIndex = this.currentTime.minute;
    _currentRightIndex = this.currentTime.hour < 12 ? 0 : 1;
    if (this.minTime != null && isAtSameDay(this.minTime!, this.currentTime)) {
      _currentLeftIndex = this.currentTime.hour - this.minTime!.hour;
      if (_currentLeftIndex == 0) {
        _currentMiddleIndex = this.currentTime.minute - this.minTime!.minute;
      }
    }
  }

  bool isAtSameDay(DateTime? day1, DateTime? day2) {
    return day1 != null &&
        day2 != null &&
        day1
            .difference(day2)
            .inDays == 0 &&
        day1.day == day2.day;
  }

  @override
  void setveryLeftIndex(int index) {
    super.setveryLeftIndex(index);
    DateTime time = currentTime.add(Duration(days: index));
    if (isAtSameDay(minTime, time)) {
      var index = min(24 - minTime!.hour - 1, _currentLeftIndex);
      this.setLeftIndex(index);
    } else if (isAtSameDay(maxTime, time)) {
      var index = min(maxTime!.hour, _currentLeftIndex);
      this.setLeftIndex(index);
    }
  }

    bool _isAm = false;
    bool _isPm = false;

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    if (index == 0) {
      _isAm = true;
      _isPm = false;
      print('picked AM');
    }
    if (index == 1) {
      _isPm = true;
      _isAm = false;
      print('picked PM');
    }
  }



    @override
    String? veryLeftStringAtIndex(int index) {
      DateTime time = currentTime.add(Duration(days: index));
      DateTime nextTime = currentTime.add(Duration(days: index + 1));
      if (minTime != null &&
          time.isBefore(minTime!) &&
          !isAtSameDay(minTime!, time)) {
        return null;
      } else if (maxTime != null &&
          time.isAfter(maxTime!) &&
          !isAtSameDay(maxTime, time)) {
        return null;
      }
      if (time.year == DateTime
          .now()
          .year) {
        return formatDate(time, [ymdw], locale);
      } else {
        return formatDate(time, [D, ' ', M, ' ', d, ', ', yyyy], locale);
      }

      // return formatDate(time, [mm,dd,D], locale); //ymdy //[D,' ',M,' ',d]
    }

    @override
    String? rightStringAtIndex(int index) {
      if (index == 0) {
        return i18nObjInLocale(this.locale)["am"] as String?;
      } else if (index == 1) {
        return i18nObjInLocale(this.locale)["pm"] as String?;
      } else {
        return null;
      }
    }

    @override
    String? leftStringAtIndex(int index) {
      if (index >= 0 && index < 12) {
        if (index == 0) {
          return digits(12, 2);
        } else {
          return digits(index, 2);
        }
      } else {
        return null;
      }
    }

    @override
    String? middleStringAtIndex(int index) {
      if (index >= 0 && index < 60) {
        return digits(index, 2);
      } else {
        return null;
      }
    }

    // @override
    // String? rightStringAtIndex(int index) {
    //   if (index >= 0 && index < 60) {
    //     DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
    //     if (isAtSameDay(minTime, time) && _currentMiddleIndex == 0) {
    //       if (index >= 0 && index < 60 - minTime!.minute) {
    //         return digits(minTime!.minute + index, 2);
    //       } else {
    //         return null;
    //       }
    //     } else if (isAtSameDay(maxTime, time) &&
    //         _currentMiddleIndex >= maxTime!.hour) {
    //       if (index >= 0 && index <= maxTime!.minute) {
    //         return digits(index, 2);
    //       } else {
    //         return null;
    //       }
    //     }
    //     return digits(index, 2);
    //   }
    //
    //   return null;
    // }

    // @override
    // DateTime finalTime() {
    //   DateTime time = currentTime.add(Duration(days: _currentveryLeftIndex));
    //   var hour = _currentLeftIndex;
    //   var minute = _currentMiddleIndex;
    //   if (isAtSameDay(minTime, time)) {
    //     hour += minTime!.hour;
    //     if (minTime!.hour == hour) {
    //       minute += minTime!.minute;
    //     }
    //   }
    //
    //   return currentTime.isUtc
    //       ? DateTime.utc(time.year, time.month, time.day, hour, minute)
    //       : DateTime(time.year, time.month, time.day, hour, minute);
    // }

    @override
    DateTime finalTime() {
      DateTime time = currentTime.add(Duration(days: _currentveryLeftIndex));
      int hour = _currentLeftIndex;
      int minute = _currentMiddleIndex;
      if (_isPm) {
        hour = (hour + 12) % 24;
      }
      if (isAtSameDay(minTime, time)) {
        hour += minTime!.hour;
        if (minTime!.hour == hour && minTime!.minute > minute) {
          hour = (hour - 1) % 12;
        }
      }

      return currentTime.isUtc
          ? DateTime.utc(time.year, time.month, time.day, hour, minute)
          : DateTime(time.year, time.month, time.day, hour, minute);
    }

    @override
    List<int> layoutProportions() {
      return [3, 1, 1, 1];
    }

    @override
    String leftDivider() {
      return ":";
    }
  }



