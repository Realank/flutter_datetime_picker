library flutter_datetime_picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DateChangedCallback(int year, int month, int date);

const double _kDatePickerHeight = 210.0;
const double _kDatePickerTitleHeight = 44.0;
const double _kDatePickerItemHeight = 36.0;
const double _kDatePickerFontSize = 18.0;

const int _kDefaultMinYear = 1970;
const int _kDefaultMaxYear = 2050;

const List<String> monthNames = const <String>[
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
];

const List<int> leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

class DatePicker {
  ///
  /// Display date picker bottom sheet.
  ///
  static void showDatePicker(BuildContext context,
      {bool showTitleActions: true,
      int minYear: _kDefaultMinYear,
      int maxYear: _kDefaultMaxYear,
      int initialYear: _kDefaultMinYear,
      int initialMonth: 1,
      int initialDate: 1,
      DateChangedCallback onChanged,
      DateChangedCallback onConfirm,
      locale: 'en_NZ'}) {
    Navigator.push(
        context,
        new _DatePickerRoute(
          showTitleActions: showTitleActions,
          minYear: minYear,
          maxYear: maxYear,
          initialYear: initialYear,
          initialMonth: initialMonth,
          initialDate: initialDate,
          onChanged: onChanged,
          onConfirm: onConfirm,
          locale: locale,
          theme: Theme.of(context, shadowThemeOnly: true),
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.minYear,
    this.maxYear,
    this.initialYear,
    this.initialMonth,
    this.initialDate,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    this.locale,
    RouteSettings settings,
  }) : super(settings: settings);

  final bool showTitleActions;
  final int minYear, maxYear, initialYear, initialMonth, initialDate;
  final DateChangedCallback onChanged;
  final DateChangedCallback onConfirm;
  final ThemeData theme;
  final String locale;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        minYear: minYear,
        maxYear: maxYear,
        initialYear: initialYear,
        initialMonth: initialMonth,
        initialDay: initialDate,
        onChanged: onChanged,
        locale: this.locale,
        route: this,
      ),
    );
    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _DatePickerComponent extends StatefulWidget {
  _DatePickerComponent(
      {Key key,
      @required this.route,
      this.minYear: _kDefaultMinYear,
      this.maxYear: _kDefaultMaxYear,
      this.initialYear: -1,
      this.initialMonth: 1,
      this.initialDay: 1,
      this.onChanged,
      this.locale});

  final DateChangedCallback onChanged;
  final int minYear, maxYear, initialYear, initialMonth, initialDay;

  final _DatePickerRoute route;

  final String locale;

  @override
  State<StatefulWidget> createState() => _DatePickerState(
      this.minYear, this.maxYear, this.initialYear, this.initialMonth, this.initialDay);
}

class _DatePickerState extends State<_DatePickerComponent> {
  final int minYear, maxYear;
  int _currentYear, _currentMonth, _currentDay;
  int _dayCountOfMonth;
  FixedExtentScrollController leftScrollCtrl, middleScrollCtrl, rightScrollCtrl;

  _DatePickerState(
      this.minYear, this.maxYear, this._currentYear, this._currentMonth, this._currentDay) {
    if (this._currentYear == -1) {
      this._currentYear = this.minYear;
    }
    if (this._currentYear < this.minYear) {
      this._currentYear = this.minYear;
    }
    if (this._currentYear > this.maxYear) {
      this._currentYear = this.maxYear;
    }

    if (this._currentMonth < 1) {
      this._currentMonth = 1;
    }
    if (this._currentMonth > 12) {
      this._currentMonth = 12;
    }

    if (this._currentDay < 1) {
      this._currentDay = 1;
    }
    if (this._currentDay > 31) {
      this._currentDay = 31;
    }

    leftScrollCtrl = new FixedExtentScrollController(initialItem: _currentYear - this.minYear);
    middleScrollCtrl = new FixedExtentScrollController(initialItem: _currentMonth - 1);
    rightScrollCtrl = new FixedExtentScrollController(initialItem: _currentDay - 1);
    _dayCountOfMonth = _calcDateCount();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate: new _BottomPickerLayout(widget.route.animation.value,
                  showTitleActions: widget.route.showTitleActions),
              child: new GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  child: _renderPickerView(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _setYear(int index) {
    int year = widget.minYear + index;
    if (_currentYear != year) {
      _currentYear = year;
      _notifyDateChanged();
    }
  }

  void _setMonth(int index) {
    int month = index + 1;
    if (_currentMonth != month) {
      _currentMonth = month;
      int dateCount = _calcDateCount();
      if (_dayCountOfMonth != dateCount) {
        setState(() {
          _dayCountOfMonth = dateCount;
        });
      }
      if (_currentDay > dateCount) {
        _currentDay = dateCount;
      }
      _notifyDateChanged();
    }
  }

  void _setDay(int index) {
    int date = index + 1;
    if (_currentDay != date) {
      _currentDay = date;
      _notifyDateChanged();
    }
  }

  int _calcDateCount() {
    if (leapYearMonths.contains(_currentMonth)) {
      return 31;
    } else if (_currentMonth == 2) {
      if ((_currentYear % 4 == 0 && _currentYear % 100 != 0) || _currentYear % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }

  List<String> _yearList() {
    return List.generate(widget.maxYear - widget.minYear + 1, (int index) {
      return '${widget.minYear + index}${_localeYear()}';
    });
  }

  List<String> _monthList() {
    return monthNames.map((string) => '$string${_localeMonth()}').toList();
  }

  List<String> _dayList() {
    return List.generate(_dayCountOfMonth, (int index) {
      return '${index + 1}${_localeDay()}';
    });
    ;
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(_currentYear, _currentMonth, _currentDay);
    }
  }

  Widget _renderPickerView() {
    Widget itemView = _renderItemView();
    if (widget.route.showTitleActions) {
      return Column(
        children: <Widget>[
          _renderTitleActionsView(),
          itemView,
        ],
      );
    }
    return itemView;
  }

  Widget _renderColumnView(
      List<String> lists, ScrollController scrollController, ValueChanged<int> selectedChanged) {
    return Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: _kDatePickerHeight,
          decoration: BoxDecoration(color: Colors.white),
          child: CupertinoPicker.builder(
              backgroundColor: Colors.white,
              scrollController: scrollController,
              itemExtent: _kDatePickerItemHeight,
              onSelectedItemChanged: (int index) {
                selectedChanged(index);
              },
              useMagnifier: true,
              itemBuilder: (BuildContext context, int index) {
                if (index < lists.length && index >= 0) {
                  return Container(
                    height: _kDatePickerItemHeight,
                    alignment: Alignment.center,
                    child: Text(
                      lists[index],
                      style: TextStyle(color: Color(0xFF000046), fontSize: _kDatePickerFontSize),
                      textAlign: TextAlign.start,
                    ),
                  );
                } else {
                  return null;
                }
              })),
    );
  }

  Widget _renderItemView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _renderColumnView(_yearList(), leftScrollCtrl, (year) {
          _setYear(year);
        }),
        _renderColumnView(_monthList(), middleScrollCtrl, (month) {
          _setMonth(month);
        }),
        _renderColumnView(_dayList(), rightScrollCtrl, (day) {
          _setDay(day);
        }),
      ],
    );
  }

  // Title View
  Widget _renderTitleActionsView() {
    String done = _localeDone();
    String cancel = _localeCancel();

    return Container(
      height: _kDatePickerTitleHeight,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: _kDatePickerTitleHeight,
            child: FlatButton(
              child: Text(
                '$cancel',
                style: TextStyle(
                  color: Theme.of(context).unselectedWidgetColor,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            height: _kDatePickerTitleHeight,
            child: FlatButton(
              child: Text(
                '$done',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                if (widget.route.onConfirm != null) {
                  widget.route.onConfirm(_currentYear, _currentMonth, _currentDay);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _localeDone() {
    if (widget.locale == null) {
      return 'Done';
    }

    String lang = widget.locale.split('_').first;

    switch (lang) {
      case 'en':
        return 'Done';
        break;

      case 'zh':
        return '确定';
        break;

      default:
        return '';
        break;
    }
  }

  String _localeCancel() {
    if (widget.locale == null) {
      return 'Cancel';
    }

    String lang = widget.locale.split('_').first;

    switch (lang) {
      case 'en':
        return 'Cancel';
        break;

      case 'zh':
        return '取消';
        break;

      default:
        return '';
        break;
    }
  }

  String _localeYear() {
    if (widget.locale == null) {
      return '';
    }

    String lang = widget.locale.split('_').first;

    switch (lang) {
      case 'zh':
        return '年';
        break;

      default:
        return '';
        break;
    }
  }

  String _localeMonth() {
    if (widget.locale == null) {
      return '';
    }

    String lang = widget.locale.split('_').first;

    switch (lang) {
      case 'zh':
        return '月';
        break;

      default:
        return '';
        break;
    }
  }

  String _localeDay() {
    if (widget.locale == null) {
      return '';
    }

    String lang = widget.locale.split('_').first;

    switch (lang) {
      case 'zh':
        return '日';
        break;

      default:
        return '';
        break;
    }
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.itemCount, this.showTitleActions});

  final double progress;
  final int itemCount;
  final bool showTitleActions;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = _kDatePickerHeight;
    if (showTitleActions) {
      maxHeight += _kDatePickerTitleHeight;
    }

    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
