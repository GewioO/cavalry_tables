import 'package:flutter/material.dart';

class PagesNavigator {
  final Widget _currentPage;
  PagesNavigator(this._currentPage);

  void changePage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void backPage(BuildContext context) {
    Navigator.pop(context);
  }
}
