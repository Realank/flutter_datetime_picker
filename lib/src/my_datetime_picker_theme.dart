import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Migrate DiagnosticableMixin to Diagnosticable until
// https://github.com/flutter/flutter/pull/51495 makes it into stable (v1.15.21)
class MyDatePickerTheme with DiagnosticableTreeMixin {
  final TextStyle cancelStyle;
  final TextStyle doneStyle;
  final TextStyle itemStyle;
  final TextStyle titleStyle;
  final String title;
  final Color backgroundColor;
  final Color headerColor;
  final double containerHeight;
  final double titleHeight;
  final double itemHeight;

  const MyDatePickerTheme({
    this.cancelStyle = const TextStyle(color: Color(0xFF409EFF), fontSize: 16),
    this.doneStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.itemStyle = const TextStyle(color: Color(0xFF333333), fontSize: 18),
    this.titleStyle = const TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.w600),
    this.title = '',
    this.backgroundColor = Colors.white,
    this.headerColor = Colors.white,
    this.containerHeight = 330.0,
    this.titleHeight = 74.0,
    this.itemHeight = 48.0,
  });
}
