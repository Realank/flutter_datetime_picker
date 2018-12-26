import 'package:flutter_datetime_picker/src/date_format.dart';
import 'package:flutter_datetime_picker/src/i18n_model.dart';
import 'package:flutter_commons_lang/flutter_commons_lang.dart';

abstract class BasePickerModel {
  String leftStringAtIndex(int index);

  String middleStringAtIndex(int index);

  String rightStringAtIndex(int index);

  void setLeftIndex(int index);

  void setMiddleIndex(int index);

  void setRightIndex(int index);

  int currentLeftIndex();

  int currentMiddleIndex();

  int currentRightIndex();

  DateTime finalTime();

  String leftDivider();

  String rightDivider();

  List<int> layoutProportions();
}

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

class DatePickerModel extends CommonPickerModel {
  DateTime max;
  DateTime min;
  int maxYear;
  int minYear;
  int maxMonth;
  int minMonth;
  int maxDay;
  int minDay;

  DatePickerModel({DateTime currentTime, this.max, this.min, LocaleType locale}) : super(locale: locale) {
    if (currentTime != null) {
      if (max != null && currentTime.compareTo(max) > 0) {
        currentTime = max;
      } else if (min != null && currentTime.compareTo(min) < 0) {
        currentTime = min;
      }
    }
    this.currentTime = currentTime ?? DateTime.now();
    fillLeftLists();
    fillMiddleLists();
    fillRightLists();
    _currentLeftIndex = this.currentTime.year - minYear;
    _currentMiddleIndex = this.currentTime.month - minMonth;
    _currentRightIndex = this.currentTime.day - minDay;
  }

  void fillLeftLists() {
    maxYear = max?.year ?? 2050;
    minYear = min?.year ?? 1970;
    this.leftList = List.generate(maxYear - minYear + 1, (int index) {
      return '${minYear + index}${_localeYear()}';
    });
  }

  void fillMiddleLists() {
    minMonth = DateUtils.truncatedEquals(currentTime, min, DateUtils.YEAR) ? min?.month : 1;
    maxMonth = DateUtils.truncatedEquals(currentTime, max, DateUtils.YEAR) ? max.month : 12;
    this.middleList = List.generate(maxMonth - minMonth + 1, (int index) {
      return '${minMonth + index}${_localeMonth()}';
    });
  }

  void fillRightLists() {
    int dayCount = DateUtils.daysOfTheMonth(currentTime);
    maxDay = DateUtils.truncatedEquals(currentTime, max, DateUtils.MONTH) ? max.day : dayCount;
    minDay = DateUtils.truncatedEquals(currentTime, min, DateUtils.MONTH) ? min.day : 1;
    this.rightList = List.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}${_localeDay()}';
    });
  }

  @override
  void setLeftIndex(int index) {
    if (index - minYear > maxYear) index = maxYear - minYear;
    super.setLeftIndex(index);
    int month = currentTime.month;
    currentTime = DateUtils.set(currentTime, year: index + minYear);
    fillMiddleLists();

    if (month > maxMonth) {
      setMiddleIndex(maxMonth - minMonth);
    } else if (month < minMonth) {
      setMiddleIndex(0);
    } else {
      setMiddleIndex(month - minMonth);
    }
  }

  @override
  void setMiddleIndex(int index) {
    if (index - minMonth > maxMonth) index = maxMonth - minMonth;
    super.setMiddleIndex(index);
    int day = currentTime.day;
    currentTime = DateUtils.set(currentTime, month: index + minMonth, day: 1);
    fillRightLists();

    if (day > maxDay) {
      setRightIndex(maxDay - minDay);
    } else if (day < minDay) {
      setRightIndex(0);
    } else {
      setRightIndex(day - minDay);
    }
  }

  @override
  void setRightIndex(int index) {
    if (index - minDay > maxDay) index = maxDay - minDay;
    super.setRightIndex(index);
    currentTime = DateUtils.set(currentTime, day: index + minDay);
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
    if (locale == LocaleType.zh) {
      return '年';
    } else {
      return '';
    }
  }

  String _localeMonth() {
    if (locale == LocaleType.zh) {
      return '月';
    } else {
      return '';
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh) {
      return '日';
    } else {
      return '';
    }
  }

  @override
  DateTime finalTime() {
    final year = _currentLeftIndex + minYear;
    final month = _currentMiddleIndex + minMonth;
    final day = _currentRightIndex + 1;
    return DateTime(year, month, day);
  }
}

class TimePickerModel extends CommonPickerModel {
  DateTime max;
  DateTime min;
  int maxHour;
  int minHour;
  int maxMinute;
  int minMinute;
  int maxSecond;
  int minSecond;

  TimePickerModel({DateTime currentTime, this.max, this.min, LocaleType locale}) : super(locale: locale) {
    if (currentTime != null) {
      if (max != null && currentTime.compareTo(max) > 0) {
        currentTime = max;
      } else if (min != null && currentTime.compareTo(min) < 0) {
        currentTime = min;
      }
    }
    this.currentTime = currentTime ?? DateTime.now();

    maxHour = max?.hour ?? 23;
    minHour = min?.hour ?? 0;
    maxMinute = DateUtils.truncatedEquals(currentTime, max, DateUtils.MINUTE) ? max.minute : 59;
    minMinute = DateUtils.truncatedEquals(currentTime, min, DateUtils.MINUTE) ? min?.minute : 0;

    _currentLeftIndex = this.currentTime.hour;
    _currentMiddleIndex = this.currentTime.minute;
    _currentRightIndex = this.currentTime.second;

    fillLeftLists();
    fillMiddleLists();
    fillRightLists();
  }

  void fillLeftLists() {
    this.leftList = List.generate(maxHour - minHour + 1, (int index) {
      return digits(minHour + index, 2);
    });
  }

  void fillMiddleLists() {
    maxMinute = DateUtils.truncatedEquals(currentTime, max, DateUtils.HOUR) ? max?.minute : 59;
    minMinute = DateUtils.truncatedEquals(currentTime, min, DateUtils.HOUR) ? min?.minute : 0;
    this.middleList = List.generate(maxMinute - minMinute + 1, (int index) {
      return digits(minMinute + index, 2);
    });
  }

  void fillRightLists() {
    maxSecond = DateUtils.truncatedEquals(currentTime, max, DateUtils.MINUTE) ? max.second : 59;
    minSecond = DateUtils.truncatedEquals(currentTime, min, DateUtils.MINUTE) ? min.second : 0;
    this.rightList = List.generate(maxSecond - minSecond + 1, (int index) {
      return digits(minSecond + index, 2);
    });
  }

  @override
  void setLeftIndex(int index) {
    if (index - minHour > maxHour) index = maxHour - minHour;
    super.setLeftIndex(index);
    int minute = currentTime.minute;
    currentTime = DateUtils.set(currentTime, hour: index + minHour);
    fillMiddleLists();

    if (minute > maxMinute) {
      setMiddleIndex(maxMinute - minMinute);
    } else if (minute < minMinute) {
      setMiddleIndex(0);
    } else {
      setMiddleIndex(minute - minMinute);
    }
  }

  @override
  void setMiddleIndex(int index) {
    if (index - minMinute > maxMinute) index = maxMinute - minMinute;
    super.setMiddleIndex(index);
    int second = currentTime.second;
    currentTime = DateUtils.set(currentTime, minute: index + minMinute, second: 1);
    fillRightLists();

    if (second > maxSecond) {
      setRightIndex(maxSecond - minSecond);
    } else if (second < minSecond) {
      setRightIndex(0);
    } else {
      setRightIndex(second - minSecond);
    }
  }

  @override
  void setRightIndex(int index) {
    if (index - minSecond > maxSecond) index = maxSecond - minSecond;
    super.setRightIndex(index);
    currentTime = DateUtils.set(currentTime, second: index + minSecond);
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

  @override
  String leftDivider() {
    return ":";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  DateTime finalTime() {
    return DateTime(currentTime.year, currentTime.month, currentTime.day, _currentLeftIndex, _currentMiddleIndex, _currentRightIndex);
  }
}

class DateTimePickerModel extends CommonPickerModel {
  DateTimePickerModel({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    _currentLeftIndex = 0;
    _currentMiddleIndex = this.currentTime.hour;
    _currentRightIndex = this.currentTime.minute;
  }

  @override
  String leftStringAtIndex(int index) {
    DateTime time = currentTime.add(Duration(days: index));
    return formatDate(time, [ymdw], locale);
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
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
  DateTime finalTime() {
    DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
    return DateTime(time.year, time.month, time.day, _currentMiddleIndex, _currentRightIndex);
  }

  @override
  List<int> layoutProportions() {
    return [3, 1, 1];
  }

  @override
  String rightDivider() {
    return ':';
  }
}
