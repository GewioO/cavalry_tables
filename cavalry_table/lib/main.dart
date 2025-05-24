import 'package:flutter/material.dart';
import 'package:cavalry_table/baseWigets/commonFlatButton.dart';
import 'package:cavalry_table/fragmentWigets/diceButton/diceButtonWidget.dart';
import 'package:cavalry_table/fragmentWigets/bottomBar.dart';
import 'package:cavalry_table/fragmentWigets/tablesList.dart';
import 'package:cavalry_table/dices/throwDice.dart';
import 'package:cavalry_table/tablesPaths.dart';
import 'package:cavalry_table/tablesHandler/tablesHandler.dart';
import 'package:cavalry_table/pages/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cavalry Tables',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(title: 'Cavalry Tables'),
    );
  }
}


