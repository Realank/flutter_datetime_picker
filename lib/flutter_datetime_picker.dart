library flutter_datetime_picker;

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';
import 'package:flutter_datetime_picker/src/date_model.dart';
import 'package:flutter_datetime_picker/src/i18n_model.dart';

export 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';
export 'package:flutter_datetime_picker/src/date_model.dart';
export 'package:flutter_datetime_picker/src/i18n_model.dart';

typedef DateChangedCallback(DateTime time);
typedef DateCancelledCallback();
typedef String? StringAtIndexCallBack(int index);

class DatePicker {
  ///
  /// Display date picker bottom sheet.
  ///
  static Future<DateTime?> showDatePicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime? minTime,
    DateTime? maxTime,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale: LocaleType.en,
    DateTime? currentTime,
    DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: DatePickerModel(
          currentTime: currentTime,
          maxTime: maxTime,
          minTime: minTime,
          locale: locale,
        ),
      ),
    );
  }

  ///
  /// Display time picker bottom sheet.
  ///
  static Future<DateTime?> showTimePicker(
    BuildContext context, {
    bool showTitleActions: true,
    bool showSecondsColumn: true,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale: LocaleType.en,
    DateTime? currentTime,
    DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: TimePickerModel(
          currentTime: currentTime,
          locale: locale,
          showSecondsColumn: showSecondsColumn,
        ),
      ),
    );
  }

  ///
  /// Display time picker bottom sheet with AM/PM.
  ///
  static Future<DateTime?> showTime12hPicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale: LocaleType.en,
    DateTime? currentTime,
    DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: Time12hPickerModel(
          currentTime: currentTime,
          locale: locale,
        ),
      ),
    );
  }

  ///
  /// Display date&time picker bottom sheet.
  ///
  static Future<DateTime?> showDateTimePicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime? minTime,
    DateTime? maxTime,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale: LocaleType.en,
    DateTime? currentTime,
    DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: DateTimePickerModel(
          currentTime: currentTime,
          minTime: minTime,
          maxTime: maxTime,
          locale: locale,
        ),
      ),
    );
  }

  ///
  /// Display date picker bottom sheet witch custom picker model.
  ///
  static Future<DateTime?> showPicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale: LocaleType.en,
    BasePickerModel? pickerModel,
    DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: pickerModel,
      ),
    );
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    DatePickerTheme? theme,
    this.barrierLabel,
    this.locale,
    RouteSettings? settings,
    BasePickerModel? pickerModel,
  })  : this.pickerModel = pickerModel ?? DatePickerModel(),
        this.theme = theme ?? DatePickerTheme(),
        super(settings: settings);

  final bool? showTitleActions;
  final DateChangedCallback? onChanged;
  final DateChangedCallback? onConfirm;
  final DateCancelledCallback? onCancel;
  final LocaleType? locale;
  final DatePickerTheme theme;
  final BasePickerModel pickerModel;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        onChanged: onChanged,
        locale: this.locale,
        route: this,
        pickerModel: pickerModel,
      ),
    );
    return InheritedTheme.captureAll(context, bottomSheet);
  }
}

class DatePickerWidget extends StatelessWidget {
  DatePickerWidget({
    Key? key,
    this.showTitleActions = true,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    this.locale = LocaleType.en,
    this.pickerModel,
    this.theme,
  })  : route = _DatePickerRoute(
          showTitleActions: showTitleActions,
          onChanged: onChanged,
          onConfirm: onConfirm,
          onCancel: onCancel,
          locale: locale,
          theme: theme,
          pickerModel: pickerModel,
        ),
        super(key: key);

  final bool showTitleActions;
  final DateChangedCallback? onChanged;
  final DateChangedCallback? onConfirm;
  final DateCancelledCallback? onCancel;
  final LocaleType locale;
  final BasePickerModel? pickerModel;
  final DatePickerTheme? theme;
  final _DatePickerRoute route;

  @override
  Widget build(BuildContext context) {
    return _RenderPickerView(
      route: route,
      itemView: _ItemView(
        pickerModel: route.pickerModel,
        onChanged: route.onChanged,
        theme: route.theme,
      ),
      titleActionsView: _TitleActionsView(
        route: route,
      ),
    );
  }
}

class _DatePickerComponent extends StatelessWidget {
  _DatePickerComponent({
    Key? key,
    required this.route,
    required this.pickerModel,
    this.onChanged,
    this.locale,
  }) : super(key: key);

  final DateChangedCallback? onChanged;

  final _DatePickerRoute route;

  final LocaleType? locale;

  final BasePickerModel pickerModel;

  @override
  Widget build(BuildContext context) {
    DatePickerTheme theme = route.theme;
    return GestureDetector(
      child: AnimatedBuilder(
        animation: route.animation!,
        builder: (BuildContext context, Widget? child) {
          final double bottomPadding = MediaQuery.of(context).padding.bottom;
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(
                route.animation!.value,
                theme,
                showTitleActions: route.showTitleActions!,
                bottomPadding: bottomPadding,
              ),
              child: _RenderPickerView(
                route: route,
                itemView: _ItemView(
                  theme: theme,
                  onChanged: onChanged,
                  pickerModel: pickerModel,
                ),
                titleActionsView: _TitleActionsView(
                  route: route,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RenderPickerView extends StatelessWidget {
  const _RenderPickerView({
    Key? key,
    required this.route,
    required this.itemView,
    required this.titleActionsView,
  }) : super(key: key);

  final _DatePickerRoute route;

  final _ItemView itemView;
  final _TitleActionsView titleActionsView;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        color: route.theme.backgroundColor,
        child: Column(
          children: <Widget>[
            if (route.showTitleActions == true) titleActionsView,
            itemView,
          ],
        ),
      ),
    );
  }
}

class _ItemView extends StatefulWidget {
  const _ItemView({
    Key? key,
    required this.theme,
    this.onChanged,
    required this.pickerModel,
  }) : super(key: key);
  final DatePickerTheme theme;
  final DateChangedCallback? onChanged;
  final BasePickerModel pickerModel;

  @override
  __ItemViewState createState() => __ItemViewState();
}

class __ItemViewState extends State<_ItemView> {
  late FixedExtentScrollController leftScrollCtrl,
      middleScrollCtrl,
      rightScrollCtrl;

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.theme.backgroundColor,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: widget.pickerModel.layoutProportions()[0] > 0
                  ? _renderColumnView(
                      ValueKey(widget.pickerModel.currentLeftIndex()),
                      widget.theme,
                      widget.pickerModel.leftStringAtIndex,
                      leftScrollCtrl,
                      widget.pickerModel.layoutProportions()[0], (index) {
                      widget.pickerModel.setLeftIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
            Text(
              widget.pickerModel.leftDivider(),
              style: widget.theme.itemStyle,
            ),
            Container(
              child: widget.pickerModel.layoutProportions()[1] > 0
                  ? _renderColumnView(
                      ValueKey(widget.pickerModel.currentLeftIndex()),
                      widget.theme,
                      widget.pickerModel.middleStringAtIndex,
                      middleScrollCtrl,
                      widget.pickerModel.layoutProportions()[1], (index) {
                      widget.pickerModel.setMiddleIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
            Text(
              widget.pickerModel.rightDivider(),
              style: widget.theme.itemStyle,
            ),
            Container(
              child: widget.pickerModel.layoutProportions()[2] > 0
                  ? _renderColumnView(
                      ValueKey(widget.pickerModel.currentMiddleIndex() * 100 +
                          widget.pickerModel.currentLeftIndex()),
                      widget.theme,
                      widget.pickerModel.rightStringAtIndex,
                      rightScrollCtrl,
                      widget.pickerModel.layoutProportions()[2], (index) {
                      widget.pickerModel.setRightIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderColumnView(
    ValueKey key,
    DatePickerTheme theme,
    StringAtIndexCallBack stringAtIndexCB,
    ScrollController scrollController,
    int layoutProportion,
    ValueChanged<int> selectedChangedWhenScrolling,
    ValueChanged<int> selectedChangedWhenScrollEnd,
  ) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: theme.containerHeight,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 &&
                notification is ScrollEndNotification &&
                notification.metrics is FixedExtentMetrics) {
              final FixedExtentMetrics metrics =
                  notification.metrics as FixedExtentMetrics;
              final int currentItemIndex = metrics.itemIndex;
              selectedChangedWhenScrollEnd(currentItemIndex);
            }
            return false;
          },
          child: CupertinoPicker.builder(
            key: key,
            backgroundColor: theme.backgroundColor,
            scrollController: scrollController as FixedExtentScrollController,
            itemExtent: theme.itemHeight,
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
                height: theme.itemHeight,
                alignment: Alignment.center,
                child: Text(
                  content,
                  style: theme.itemStyle,
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.pickerModel.finalTime()!);
    }
  }

  void refreshScrollOffset() {
//    print('refreshScrollOffset ${widget.pickerModel.currentRightIndex()}');
    leftScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl = FixedExtentScrollController(
        initialItem: widget.pickerModel.currentRightIndex());
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(
    this.progress,
    this.theme, {
    this.itemCount,
    this.showTitleActions,
    this.bottomPadding = 0,
  });

  final double progress;
  final int? itemCount;
  final bool? showTitleActions;
  final DatePickerTheme theme;
  final double bottomPadding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = theme.containerHeight;
    if (showTitleActions == true) {
      maxHeight += theme.titleHeight;
    }

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight + bottomPadding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _TitleActionsView extends StatelessWidget {
  const _TitleActionsView({
    Key? key,
    required this.route,
  }) : super(key: key);
  final _DatePickerRoute route;

  @override
  Widget build(BuildContext context) {
    final done = _localeDone();
    final cancel = _localeCancel();

    return Container(
      height: route.theme.titleHeight,
      decoration: BoxDecoration(
        color: route.theme.headerColor ?? route.theme.backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: route.theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsetsDirectional.only(start: 16, top: 0),
              child: Text(
                '$cancel',
                style: route.theme.cancelStyle,
              ),
              onPressed: () {
                Navigator.pop(context);
                if (route.onCancel != null) {
                  route.onCancel!();
                }
              },
            ),
          ),
          Container(
            height: route.theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsetsDirectional.only(end: 16, top: 0),
              child: Text(
                '$done',
                style: route.theme.doneStyle,
              ),
              onPressed: () {
                Navigator.pop(context, route.pickerModel.finalTime());
                if (route.onConfirm != null) {
                  route.onConfirm!(route.pickerModel.finalTime()!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _localeDone() {
    return i18nObjInLocale(route.locale)['done'] as String;
  }

  String _localeCancel() {
    return i18nObjInLocale(route.locale)['cancel'] as String;
  }
}
