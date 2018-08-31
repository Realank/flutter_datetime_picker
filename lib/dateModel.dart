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
}

class CommonPickerModel extends BasePickerModel {
  List<String> leftList;
  List<String> middleList;
  List<String> rightList;
  DateTime currentTime;
  int _currentLeftIndex;
  int _currentMiddleIndex;
  int _currentRightIndex;

  String locale;
  CommonPickerModel({this.currentTime, locale}) : this.locale = locale ?? 'cn';

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
  DateTime finalTime() {}
}

class DatePickerModel extends CommonPickerModel {
  int maxYear;
  int minYear;

  List<int> _leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];
  int _calcDateCount() {
    final currentYear = _currentLeftIndex + minYear;
    final currentMonth = _currentMiddleIndex + 1;

    if (_leapYearMonths.contains(currentMonth)) {
      return 31;
    } else if (currentMonth == 2) {
      if ((currentYear % 4 == 0 && currentYear % 100 != 0) || currentYear % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }

  DatePickerModel({this.maxYear = 2050, this.minYear = 1970, DateTime currentTime, String locale})
      : super(currentTime: currentTime ?? DateTime.now(), locale: locale) {
    _currentLeftIndex = this.currentTime.year - minYear;
    _currentMiddleIndex = this.currentTime.month - 1;
    _currentRightIndex = this.currentTime.day - 1;

    this.leftList = List.generate(maxYear - minYear + 1, (int index) {
      return '${minYear + index}${_localeYear()}';
    });
    this.middleList = List.generate(12, (int index) {
      return '${index + 1}${_localeMonth()}';
    });
    this.rightList = List.generate(_calcDateCount(), (int index) {
      return '${index + 1}${_localeDay()}';
    });
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
    if (locale.matchAsPrefix('cn') == null) {
      return '';
    } else {
      return '年';
    }
  }

  String _localeMonth() {
    if (locale.matchAsPrefix('cn') == null) {
      return '';
    } else {
      return '月';
    }
  }

  String _localeDay() {
    if (locale.matchAsPrefix('cn') == null) {
      return '';
    } else {
      return '日';
    }
  }

  @override
  DateTime finalTime() {
    final year = _currentLeftIndex + minYear;
    final month = _currentMiddleIndex + 1;
    final day = _currentRightIndex + 1;
    return DateTime(year, month, day);
  }
}
