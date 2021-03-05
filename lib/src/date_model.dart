import 'package:flutter_datetime_picker/src/date_format.dart';
import 'package:flutter_datetime_picker/src/i18n_model.dart';
import 'datetime_util.dart';
import 'dart:math';

//interface for picker data model
abstract class BasePickerModel {
  //a getter method for left column data, return null to end list
  String leftStringAtIndex(int index);
  //a getter method for middle column data, return null to end list
  String middleStringAtIndex(int index);
  //a getter method for right column data, return null to end list
  String rightStringAtIndex(int index);
  //set selected left index
  void setLeftIndex(int index);
  //set selected middle index
  void setMiddleIndex(int index);
  //set selected right index
  void setRightIndex(int index);
  //return current left index
  int currentLeftIndex();
  //return current middle index
  int currentMiddleIndex();
  //return current right index
  int currentRightIndex();
  //return final time
  DateTime finalTime();
  //return left divider string
  String leftDivider();
  //return right divider string
  String rightDivider();
  //layout proportions for 3 columns
  List<int> layoutProportions();
}

//a base class for picker data model
class CommonPickerModel extends BasePickerModel {
  List<String> leftList;
  List<String> middleList;
  List<String> rightList;
  DateTime currentTime;
  int _currentLeftIndex;
  int _currentMiddleIndex;
  int _currentRightIndex;

  LocaleType locale;

  CommonPickerModel({this.currentTime, locale}) : this.locale = locale ?? LocaleType.en;

  @override
  String leftStringAtIndex(int index) {
    return null;
  }

  @override
  String middleStringAtIndex(int index) {
    return null;
  }

  @override
  String rightStringAtIndex(int index) {
    return null;
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
    return [1, 1, 1];
  }

  @override
  DateTime finalTime() {
    return null;
  }
}

//a date picker model
class DatePickerModel extends CommonPickerModel {
  DateTime maxTime;
  DateTime minTime;

  DatePickerModel({DateTime currentTime, DateTime maxTime, DateTime minTime, LocaleType locale})
      : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    currentTime = currentTime ?? DateTime.now();
    if (currentTime != null) {
      if (currentTime.compareTo(this.maxTime) > 0) {
        currentTime = this.maxTime;
      } else if (currentTime.compareTo(this.minTime) < 0) {
        currentTime = this.minTime;
      }
    }
    this.currentTime = currentTime;

    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();
    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentLeftIndex = this.currentTime.year - this.minTime.year;
    _currentMiddleIndex = this.currentTime.month - minMonth;
    _currentRightIndex = this.currentTime.day - minDay;
  }

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
    return currentTime.year == maxTime.year && currentTime.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime.year == minTime.year && currentTime.month == minTime.month ? minTime.day : 1;
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

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
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
      List monthStrings = i18nObjInLocale(locale)['monthLong'];
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

  TimePickerModel({DateTime currentTime, LocaleType locale, this.showSecondsColumn: true})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();

    _currentLeftIndex = this.currentTime.hour;
    _currentMiddleIndex = this.currentTime.minute;
    _currentRightIndex = this.currentTime.second;
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
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
      return "";
  }

  @override
  List<int> layoutProportions() {
    if (showSecondsColumn)
      return [1, 1, 1];
    else
      return [1, 1, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day, _currentLeftIndex,
            _currentMiddleIndex, _currentRightIndex)
        : DateTime(currentTime.year, currentTime.month, currentTime.day, _currentLeftIndex,
            _currentMiddleIndex, _currentRightIndex);
  }
}

//a time picker model
class Time12hPickerModel extends CommonPickerModel {
  Time12hPickerModel({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();

    _currentLeftIndex = this.currentTime.hour % 12;
    _currentMiddleIndex = this.currentTime.minute;
    _currentRightIndex = this.currentTime.hour < 12 ? 0 : 1;
  }

  @override
  String leftStringAtIndex(int index) {
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
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index == 0) {
      return  i18nObjInLocale(this.locale)["am"];
    } else if (index == 1) {
      return i18nObjInLocale(this.locale)["pm"];
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
        ? DateTime.utc(
            currentTime.year, currentTime.month, currentTime.day, hour, _currentMiddleIndex, 0)
        : DateTime(
            currentTime.year, currentTime.month, currentTime.day, hour, _currentMiddleIndex, 0);
  }
}

// a date&time picker model
class DateTimePickerModel extends CommonPickerModel {
  DateTime maxTime;
  DateTime minTime;
  DateTimePickerModel({DateTime currentTime, DateTime maxTime, DateTime minTime, LocaleType locale})
      : super(locale: locale) {
    if (currentTime != null) {
      this.currentTime = currentTime;
      if (maxTime != null &&
          (currentTime.isBefore(maxTime) || currentTime.isAtSameMomentAs(maxTime))) {
        this.maxTime = maxTime;
      }
      if (minTime != null &&
          (currentTime.isAfter(minTime) || currentTime.isAtSameMomentAs(minTime))) {
        this.minTime = minTime;
      }
    } else {
      this.maxTime = maxTime;
      this.minTime = minTime;
      var now = DateTime.now();
      if (this.minTime != null && this.minTime.isAfter(now)) {
        this.currentTime = this.minTime;
      } else if (this.maxTime != null && this.maxTime.isBefore(now)) {
        this.currentTime = this.maxTime;
      } else {
        this.currentTime = now;
      }
    }

    if (this.minTime != null && this.maxTime != null && this.maxTime.isBefore(this.minTime)) {
      // invalid
      this.minTime = null;
      this.maxTime = null;
    }

    _currentLeftIndex = 0;
    _currentMiddleIndex = this.currentTime.hour;
    _currentRightIndex = this.currentTime.minute;
    if (this.minTime != null && isAtSameDay(this.minTime, this.currentTime)) {
      _currentMiddleIndex = this.currentTime.hour - this.minTime.hour;
      if (_currentMiddleIndex == 0) {
        _currentRightIndex = this.currentTime.minute - this.minTime.minute;
      }
    }
  }

  bool isAtSameDay(DateTime day1, DateTime day2) {
    return day1 != null &&
        day2 != null &&
        day1.difference(day2).inDays == 0 &&
        day1.day == day2.day;
  }

  @override
  void setLeftIndex(int index) {
    // TODO: implement setLeftIndex
    super.setLeftIndex(index);

    DateTime time = currentTime.add(Duration(days: index));
    if (isAtSameDay(minTime, time)) {
      var index = min(24 - minTime.hour - 1, _currentMiddleIndex);
      this.setMiddleIndex(index);
    } else if (isAtSameDay(maxTime, time)) {
      var index = min(maxTime.hour, _currentMiddleIndex);
      this.setMiddleIndex(index);
    }
  }

  @override
  void setMiddleIndex(int index) {
    // TODO: implement setMiddleIndex
    super.setMiddleIndex(index);
    DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
    if (isAtSameDay(minTime, time) && index == 0) {
      var maxIndex = 60 - minTime.minute - 1;
      if (_currentRightIndex > maxIndex) {
        _currentRightIndex = maxIndex;
      }
    } else if (isAtSameDay(maxTime, time) && _currentMiddleIndex == maxTime.hour) {
      var maxIndex = maxTime.minute;
      if (_currentRightIndex > maxIndex) {
        _currentRightIndex = maxIndex;
      }
    }
  }

  @override
  String leftStringAtIndex(int index) {
    DateTime time = currentTime.add(Duration(days: index));
    if (minTime != null && time.isBefore(minTime) && !isAtSameDay(minTime, time)) {
      return null;
    } else if (maxTime != null && time.isAfter(maxTime) && !isAtSameDay(maxTime, time)) {
      return null;
    }
    return formatDate(time, [ymdw], locale);
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
      if (isAtSameDay(minTime, time)) {
        if (index >= 0 && index < 24 - minTime.hour) {
          return digits(minTime.hour + index, 2);
        } else {
          return null;
        }
      } else if (isAtSameDay(maxTime, time)) {
        if (index >= 0 && index <= maxTime.hour) {
          return digits(index, 2);
        } else {
          return null;
        }
      }
      return digits(index, 2);
    }

    return null;
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
      if (isAtSameDay(minTime, time) && _currentMiddleIndex == 0) {
        if (index >= 0 && index < 60 - minTime.minute) {
          return digits(minTime.minute + index, 2);
        } else {
          return null;
        }
      } else if (isAtSameDay(maxTime, time) && _currentMiddleIndex >= maxTime.hour) {
        if (index >= 0 && index <= maxTime.minute) {
          return digits(index, 2);
        } else {
          return null;
        }
      }
      return digits(index, 2);
    }

    return null;
  }

  @override
  DateTime finalTime() {
    DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
    var hour = _currentMiddleIndex;
    var minute = _currentRightIndex;
    if (isAtSameDay(minTime, time)) {
      hour += minTime.hour;
      if (minTime.hour == hour) {
        minute += minTime.minute;
      }
    }

    return currentTime.isUtc
        ? DateTime.utc(time.year, time.month, time.day, hour, minute)
        : DateTime(time.year, time.month, time.day, hour, minute);
  }

  @override
  List<int> layoutProportions() {
    return [4, 1, 1];
  }

  @override
  String rightDivider() {
    return ':';
  }
}
