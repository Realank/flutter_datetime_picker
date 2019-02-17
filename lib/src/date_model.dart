import 'package:flutter_datetime_picker/src/date_format.dart';
import 'package:flutter_datetime_picker/src/i18n_model.dart';
import 'datetime_util.dart';

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

  CommonPickerModel({this.currentTime, locale})
      : this.locale = locale ?? LocaleType.en;

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

  DatePickerModel(
      {DateTime currentTime,
      DateTime maxTime,
      DateTime minTime,
      LocaleType locale})
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
      return '${minMonth + index}${_localeMonth()}';
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

    _fillRightLists();
    int minDay = _minDayOfCurrentMonth();
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    int minDay = _minDayOfCurrentMonth();
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

//a time picker model
class TimePickerModel extends CommonPickerModel {
  TimePickerModel({DateTime currentTime, LocaleType locale})
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
    return ":";
  }

  @override
  DateTime finalTime() {
    return DateTime(currentTime.year, currentTime.month, currentTime.day,
        _currentLeftIndex, _currentMiddleIndex, _currentRightIndex);
  }
}

//a date&time picker model
class DateTimePickerModel extends CommonPickerModel {
  DateTime maxTime;
  DateTime minTime;

  DateTimePickerModel({DateTime currentTime, LocaleType locale, DateTime minTime, DateTime maxTime})
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
    int minHour = _minHourOfCurrentDay();
    int minMinute = _minMinuteOfCurrentHour();
    _currentLeftIndex = this.currentTime.day - this.minTime.day;
    _currentMiddleIndex = this.currentTime.hour - minHour;
    _currentRightIndex = this.currentTime.minute - minMinute;
  }

  void _fillLeftLists(){
    this.leftList = List.generate(maxTime.day - minTime.day + 1, (int index) {
      DateTime newTime = minTime.add(Duration(days: index));
      return '${formatDate(newTime, [ymdw], locale)}';
    });
  }

  int _maxHourOfCurrentDay() {
    return currentTime.day == maxTime.day ? maxTime.hour : 23;
  }
  int _minHourOfCurrentDay() {
    return currentTime.day == minTime.day ? minTime.hour : 0;
  }

  int _maxMinuteOfCurrentHour(){
    if (currentTime.day == maxTime.day && currentTime.hour == maxTime.hour)
      return maxTime.minute;
    return 59;
  }

  int _minMinuteOfCurrentHour(){
    if (currentTime.day == minTime.day && currentTime.hour == minTime.hour)
      return minTime.minute;
    return 0;
  }

  void _fillMiddleLists(){
    int minHour = _minHourOfCurrentDay();
    int maxHour = _maxHourOfCurrentDay();
    this.middleList = List.generate(maxHour - minHour + 1, (int index) {
      return '${digits(minHour + index, 2)}';
    });
  }

  void _fillRightLists(){
    int maxMinute = _maxMinuteOfCurrentHour();
    int minMinute = _minMinuteOfCurrentHour();
    this.rightList = List.generate(maxMinute - minMinute + 1, (int index) {
      return '${digits(minMinute + index, 2)}';
    });
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    DateTime newTime = currentTime.add(Duration(days: index + minTime.day -currentTime.day));
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }
    _fillMiddleLists();
    _fillRightLists();
    int minHour = _minHourOfCurrentDay();
    int minMinute = _minMinuteOfCurrentHour();
    _currentMiddleIndex = currentTime.hour - minHour;
    _currentRightIndex = currentTime.minute - minMinute;
  }

  @override
  void setMiddleIndex(int index){
    super.setMiddleIndex(index);
    int minHour = _minHourOfCurrentDay();
    DateTime newTime = currentTime.add(Duration(hours: index + minHour - currentTime.hour));
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }
    _fillRightLists();
    int minMinute = _minMinuteOfCurrentHour();
    _currentRightIndex = currentTime.minute - minMinute;
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    int minMinute = _minMinuteOfCurrentHour();
    currentTime = currentTime.add(Duration(minutes: index + minMinute - currentTime.minute));
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
  DateTime finalTime() {
    int minHour = _minHourOfCurrentDay();
    int minMinute = _minMinuteOfCurrentHour();
    return currentTime.add(Duration(
        days: minTime.day + _currentLeftIndex - currentTime.day,
        hours: minHour + _currentMiddleIndex - currentTime.hour,
        minutes: minMinute + _currentRightIndex - currentTime.minute
    ));
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
