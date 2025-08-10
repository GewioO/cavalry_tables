import 'package:flutter/material.dart';
import 'package:cavalry_table/pages/pagesNavigator.dart';

void startTransitionButtonSequence(
  BuildContext context,
  Widget page,
  PagesNavigator navigatorObj,
) {
  navigatorObj.changePage(context, page);
}
