import 'package:flutter/material.dart';
import 'package:cavalry_table/pages/pagesNavigator.dart';


void startFirstButtonSequence(BuildContext context, Widget page, PagesNavigator navigatorObj) 
{
  navigatorObj.changePage(context, page);
}