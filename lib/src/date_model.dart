import 'package:flutter_datetime_picker/src/date_format.dart';
import 'package:flutter_datetime_picker/src/i18n_model.dart';
import 'datetime_util.dart';

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

    fillLeftLists();
    fillMiddleLists();
    fillRightLists();
    int minMonth = minMonthOfCurrentYear();
    int minDay = minDayOfCurrentMonth();
    _currentLeftIndex = this.currentTime.year - this.minTime.year;
    _currentMiddleIndex = this.currentTime.month - minMonth;
    _currentRightIndex = this.currentTime.day - minDay;
  }

  void fillLeftLists() {
    this.leftList = List.generate(maxTime.year - minTime.year + 1, (int index) {
      return '${minTime.year + index}${_localeYear()}';
    });
  }

  int maxMonthOfCurrentYear() {
    return currentTime.year == maxTime.year ? maxTime.month : 12;
  }

  int minMonthOfCurrentYear() {
    return currentTime.year == minTime.year ? minTime.month : 1;
  }

  int maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime.year, currentTime.month);
    return currentTime.year == maxTime.year && currentTime.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int minDayOfCurrentMonth() {
    return currentTime.year == minTime.year && currentTime.month == minTime.month ? minTime.day : 1;
  }

  void fillMiddleLists() {
    int minMonth = minMonthOfCurrentYear();
    int maxMonth = maxMonthOfCurrentYear();
    this.middleList = List.generate(maxMonth - minMonth + 1, (int index) {
      return '${minMonth + index}${_localeMonth()}';
    });
  }

  void fillRightLists() {
    int maxDay = maxDayOfCurrentMonth();
    int minDay = minDayOfCurrentMonth();
    this.rightList = List.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}${_localeDay()}';
    });
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    int destYear = index + minTime.year;
    int minMonth = minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newTime = DateTime(
        destYear,
        currentTime.month,
        calcDateCount(destYear, 2),
      );
    } else {
      newTime = DateTime(
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

    fillMiddleLists();
    fillRightLists();
    minMonth = minMonthOfCurrentYear();
    int minDay = minDayOfCurrentMonth();
    _currentMiddleIndex = currentTime.month - minMonth;
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    //adjust right
    int minMonth = minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = DateTime(
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

    fillRightLists();
    int minDay = minDayOfCurrentMonth();
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    int minDay = minDayOfCurrentMonth();
    currentTime = DateTime(
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
    return currentTime;
  }
}

class TimePickerModel extends CommonPickerModel {
  TimePickerModel({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
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
    return ":";
  }

  @override
  DateTime finalTime() {
    return DateTime(currentTime.year, currentTime.month, currentTime.day, _currentLeftIndex,
        _currentMiddleIndex, _currentRightIndex);
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
    return [4, 1, 1];
  }

  @override
  String rightDivider() {
    return ':';
  }
}
