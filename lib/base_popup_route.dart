import 'package:flutter/material.dart';

class TestInfo {
  String? name;
}

class GMDialog {
  static Future<TestInfo?> showDialog(BuildContext context) async {
    return await Navigator.push(context, GMBasePopupRoute());
  }
}

class GMBasePopupRoute<T> extends PopupRoute<T> {
  @override
  Color? get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottom = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: Colors.red,
          height: 300,
        ));
    return InheritedTheme.captureAll(context, bottom);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);
}
