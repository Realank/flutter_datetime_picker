library flutter_datetime_picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/src/date_model.dart';
import 'package:flutter_datetime_picker/src/i18n_model.dart';
export 'package:flutter_datetime_picker/src/date_model.dart';
export 'package:flutter_datetime_picker/src/i18n_model.dart';

typedef DateChangedCallback(DateTime time);
typedef String StringAtIndexCallBack(int index);

const double _kDatePickerHeight = 210.0;
const double _kDatePickerTitleHeight = 44.0;
const double _kDatePickerItemHeight = 36.0;
const double _kDatePickerFontSize = 18.0;

class DatePicker {
  ///
  /// Display date picker bottom sheet.
  ///
  static void showDatePicker(BuildContext context,
      {bool showTitleActions: true,
      DateChangedCallback onChanged,
      DateChangedCallback onConfirm,
      locale: LocaleType.en,
      DateTime currentTime}) {
    Navigator.push(
        context,
        new _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            locale: locale,
            theme: Theme.of(context, shadowThemeOnly: true),
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            pickerModel: DatePickerModel(currentTime: currentTime, locale: locale)));
  }

  ///
  /// Display time picker bottom sheet.
  ///
  static void showTimePicker(BuildContext context,
      {bool showTitleActions: true,
      DateChangedCallback onChanged,
      DateChangedCallback onConfirm,
      locale: LocaleType.en,
      DateTime currentTime}) {
    Navigator.push(
        context,
        new _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            locale: locale,
            theme: Theme.of(context, shadowThemeOnly: true),
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            pickerModel: TimePickerModel(currentTime: currentTime, locale: locale)));
  }

  ///
  /// Display date&time picker bottom sheet.
  ///
  static void showDateTimePicker(BuildContext context,
      {bool showTitleActions: true,
      DateChangedCallback onChanged,
      DateChangedCallback onConfirm,
      locale: LocaleType.en,
      DateTime currentTime}) {
    Navigator.push(
        context,
        new _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            locale: locale,
            theme: Theme.of(context, shadowThemeOnly: true),
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            pickerModel: DateTimePickerModel(currentTime: currentTime, locale: locale)));
  }

  ///
  /// Display date picker bottom sheet witch custom picker model.
  ///
  static void showPicker(BuildContext context,
      {bool showTitleActions: true,
      DateChangedCallback onChanged,
      DateChangedCallback onConfirm,
      locale: LocaleType.en,
      BasePickerModel pickerModel}) {
    Navigator.push(
        context,
        new _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            locale: locale,
            theme: Theme.of(context, shadowThemeOnly: true),
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            pickerModel: pickerModel));
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.onChanged,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    this.locale,
    RouteSettings settings,
    pickerModel,
  })  : this.pickerModel = pickerModel ?? DatePickerModel(),
        super(settings: settings);

  final bool showTitleActions;
  final DateChangedCallback onChanged;
  final DateChangedCallback onConfirm;
  final ThemeData theme;
  final LocaleType locale;
  final BasePickerModel pickerModel;

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
        onChanged: onChanged,
        locale: this.locale,
        route: this,
        pickerModel: pickerModel,
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
      {Key key, @required this.route, this.onChanged, this.locale, this.pickerModel});

  final DateChangedCallback onChanged;

  final _DatePickerRoute route;

  final LocaleType locale;

  final BasePickerModel pickerModel;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<_DatePickerComponent> {
  FixedExtentScrollController leftScrollCtrl, middleScrollCtrl, rightScrollCtrl;

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }

  void refreshScrollOffset() {
    leftScrollCtrl =
        new FixedExtentScrollController(initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl =
        new FixedExtentScrollController(initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl =
        new FixedExtentScrollController(initialItem: widget.pickerModel.currentRightIndex());
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

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(widget.pickerModel.finalTime());
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
      StringAtIndexCallBack stringAtIndexCB,
      ScrollController scrollController,
      int layoutProportion,
      ValueChanged<int> selectedChangedWhenScrolling,
      ValueChanged<int> selectedChangedWhenScrollEnd) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: _kDatePickerHeight,
          decoration: BoxDecoration(color: Colors.white),
          child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (notification.depth == 0 &&
                    selectedChangedWhenScrollEnd != null &&
                    notification is ScrollEndNotification &&
                    notification.metrics is FixedExtentMetrics) {
                  final FixedExtentMetrics metrics = notification.metrics;
                  final int currentItemIndex = metrics.itemIndex;
                  selectedChangedWhenScrollEnd(currentItemIndex);
                }
                return false;
              },
              child: CupertinoPicker.builder(
                  key: ValueKey(widget.pickerModel.currentMiddleIndex()),
                  backgroundColor: Colors.white,
                  scrollController: scrollController,
                  itemExtent: _kDatePickerItemHeight,
                  onSelectedItemChanged: (int index) {
                    selectedChangedWhenScrolling(index);
                  },
                  useMagnifier: true,
                  itemBuilder: (BuildContext context, int index) {
                    final content = stringAtIndexCB(index);
                    if (content == null) {
                      return null;
                    }
                    return Container(
                      height: _kDatePickerItemHeight,
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        style: TextStyle(color: Color(0xFF000046), fontSize: _kDatePickerFontSize),
                        textAlign: TextAlign.start,
                      ),
                    );
                  }))),
    );
  }

  Widget _renderItemView() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _renderColumnView(widget.pickerModel.leftStringAtIndex, leftScrollCtrl,
              widget.pickerModel.layoutProportions()[0], (index) {
            setState(() {
              widget.pickerModel.setLeftIndex(index);
            });
            _notifyDateChanged();
          }, null),
          Text(
            widget.pickerModel.leftDivider(),
            style: TextStyle(color: Color(0xFF000046), fontSize: _kDatePickerFontSize),
          ),
          _renderColumnView(widget.pickerModel.middleStringAtIndex, middleScrollCtrl,
              widget.pickerModel.layoutProportions()[1], (index) {
            widget.pickerModel.setMiddleIndex(index);
          }, (index) {
            setState(() {
              refreshScrollOffset();
            });
            _notifyDateChanged();
          }),
          Text(
            widget.pickerModel.rightDivider(),
            style: TextStyle(color: Color(0xFF000046), fontSize: _kDatePickerFontSize),
          ),
          _renderColumnView(widget.pickerModel.rightStringAtIndex, rightScrollCtrl,
              widget.pickerModel.layoutProportions()[2], (index) {
            setState(() {
              widget.pickerModel.setRightIndex(index);
            });
            _notifyDateChanged();
          }, null),
        ],
      ),
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
                  widget.route.onConfirm(widget.pickerModel.finalTime());
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
    return i18nObjInLocale(widget.locale)['done'];
  }

  String _localeCancel() {
    return i18nObjInLocale(widget.locale)['cancel'];
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
