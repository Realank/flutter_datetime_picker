import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Migrate DiagnosticableMixin to Diagnosticable until
// https://github.com/flutter/flutter/pull/51495 makes it into stable (v1.15.21)
class FlutterDatePickerTheme with DiagnosticableTreeMixin {
  final TextStyle cancelStyle;
  final TextStyle doneStyle;
  final TextStyle itemStyle;
  final Color backgroundColor;
  final Color? headerColor;

  final double containerHeight;
  final double titleHeight;
  final double itemHeight;

  const FlutterDatePickerTheme({
    this.cancelStyle = const TextStyle(color: Colors.black54, fontSize: 20),
    this.doneStyle = const TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
    this.itemStyle = const TextStyle(color: Color(0xFF000046), fontSize: 24),
    this.backgroundColor = Colors.white,
    this.headerColor,
    this.containerHeight = 210.0,
    this.titleHeight = 50.0,
    this.itemHeight = 50.0,
  });
}
