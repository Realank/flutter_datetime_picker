import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DatePickerTheme extends Diagnosticable {
  /// Whether null values are replaced with their value in an ancestor text
  /// style (e.g., in a [TextSpan] tree).
  ///
  /// If this is false, properties that don't have explicit values will revert
  /// to the defaults: white in color, a font size of 10 pixels, in a sans-serif
  /// font face.
  final bool inherit;

  final TextStyle cancelStyle;
  final TextStyle doneStyle;
  final TextStyle itemStyle;
  final Color backgroundColor;
  final Color barrierColor;

  final double containerHeight;
  final double titleHeight;
  final double itemHeight;

  const DatePickerTheme({
    this.inherit,
    this.cancelStyle,
    this.doneStyle,
    this.itemStyle,
    this.backgroundColor,
    this.barrierColor,
    this.containerHeight = 210.0,
    this.titleHeight = 44.0,
    this.itemHeight = 36.0,
  });

  /// Creates a copy of this theme data but with the given fields replaced with
  /// the new values.
  DatePickerTheme copyWith({
    TextStyle cancelStyle,
    TextStyle doneStyle,
    TextStyle itemStyle,
    Color backgroundColor,
    Color barrierColor,
    double pickerHeight,
    double pickerTitleHeight,
    double pickerItemHeight,
  }) {
    return DatePickerTheme(
      inherit: inherit,
      cancelStyle: cancelStyle != null ? cancelStyle.merge(this.cancelStyle) : this.cancelStyle,
      doneStyle: doneStyle != null ? doneStyle.merge(this.doneStyle) : this.doneStyle,
      itemStyle: itemStyle != null ? itemStyle.merge(this.itemStyle) : this.itemStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      barrierColor: barrierColor ?? this.barrierColor,
      containerHeight: pickerHeight ?? this.containerHeight,
      titleHeight: pickerTitleHeight ?? this.titleHeight,
      itemHeight: pickerItemHeight ?? this.itemHeight,
    );
  }

  /// Returns a new theme data that is a combination of this style and the given
  /// [other] style.
  ///
  /// If the given [other] theme data has its [DatePickerTheme.inherit] set to true,
  /// its null properties are replaced with the non-null properties of this text
  /// style. The [other] style _inherits_ the properties of this style. Another
  /// way to think of it is that the "missing" properties of the [other] style
  /// are _filled_ by the properties of this style.
  ///
  /// If the given [other] theme data has its [DatePickerTheme.inherit] set to false,
  /// returns the given [other] style unchanged. The [other] style does not
  /// inherit properties of this style.
  ///
  /// If the given theme data is null, returns this theme data.
  DatePickerTheme merge(DatePickerTheme other) {
    if (other == null) return this;
    if (!other.inherit) return other;

    return copyWith(
      cancelStyle: other.cancelStyle,
      doneStyle: other.doneStyle,
      itemStyle: other.itemStyle,
      backgroundColor: other.backgroundColor,
      barrierColor: other.barrierColor,
      pickerHeight: other.containerHeight,
      pickerTitleHeight: other.titleHeight,
      pickerItemHeight: other.itemHeight,
    );
  }
}

/// The theme data to apply to descendant [DatePicker] widgets without explicit style.
class DefaultDatePickerTheme extends InheritedWidget {
  /// Creates a default theme data for the given subtree.
  ///
  /// Consider using [DefaultDatePickerTheme.merge] to inherit styling information
  /// from the current default theme data for a given [BuildContext].
  ///
  const DefaultDatePickerTheme({
    Key key,
    @required this.theme,
    @required Widget child,
  })  : assert(theme != null),
        assert(child != null),
        super(key: key, child: child);

  /// A const-constructible default theme data that provides fallback values.
  ///
  /// Returned from [of] when the given [BuildContext] doesn't have an enclosing default theme data.
  ///
  /// This constructor creates a [DefaultDatePickerTheme] that lacks a [child], which
  /// means the constructed value cannot be incorporated into the tree.
  const DefaultDatePickerTheme.fallback() : theme = const DatePickerTheme();

  /// Creates a default theme data that overrides the theme datas in scope at
  /// this point in the widget tree.
  ///
  /// The given [style] is merged with the [style] from the default theme data
  /// for the [BuildContext] where the widget is inserted, and any of the other
  /// arguments that are not null replace the corresponding properties on that
  /// same default theme data.
  ///
  /// This constructor cannot be used to override the [maxLines] property of the
  /// ancestor with the value null, since null here is used to mean "defer to
  /// ancestor". To replace a non-null [maxLines] from an ancestor with the null
  /// value (to remove the restriction on number of lines), manually obtain the
  /// ambient [DefaultDatePickerTheme] using [DefaultDatePickerTheme.of], then create a new
  /// [DefaultDatePickerTheme] using the [new DefaultDatePickerTheme] constructor directly.
  /// See the source below for an example of how to do this (since that's
  /// essentially what this constructor does).
  static Widget merge({
    Key key,
    DatePickerTheme theme,
    @required Widget child,
  }) {
    assert(child != null);
    return Builder(
      builder: (BuildContext context) {
        final DefaultDatePickerTheme parent = DefaultDatePickerTheme.of(context);
        return DefaultDatePickerTheme(
          key: key,
          theme: parent.theme.merge(theme),
          child: child,
        );
      },
    );
  }

  /// The theme data to apply.
  final DatePickerTheme theme;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If no such instance exists, returns an instance created by
  /// [DefaultDatePickerTheme.fallback], which contains fallback values.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// DefaultDatePickerTheme style = DefaultDatePickerTheme.of(context);
  /// ```
  static DefaultDatePickerTheme of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DefaultDatePickerTheme) ?? const DefaultDatePickerTheme.fallback();
  }

  @override
  bool updateShouldNotify(DefaultDatePickerTheme oldWidget) {
    return theme != oldWidget.theme;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    theme?.debugFillProperties(properties);
  }
}
