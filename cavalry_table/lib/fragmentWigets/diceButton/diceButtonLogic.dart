import 'package:cavalry_table/tablesHandler/tablesHandler.dart';
import 'package:flutter/material.dart';

typedef ThrownResultCallback = void Function(List<dynamic> result, String buttonText);

void handleDiceButtonPressed({
  required bool thrownModeSingleDice,
  required Map<String, dynamic>? tempSelectedTable,
  required TablesHandler tablesHandler,
  required int diceType,
  required ThrownResultCallback onResultUpdated,
}) {
  List<dynamic> result;
  String buttonText;

  if (tempSelectedTable != null && tempSelectedTable.isNotEmpty && !thrownModeSingleDice) {
    result = tablesHandler.getResult(tempSelectedTable);

    if (tempSelectedTable['title'] == 'гроші') {
      buttonText = '${result[1]} + ${result[2]}';
    } else if (tempSelectedTable['title'] == 'Стійкість та удача') {
      buttonText = 'Стійкість: ${result[0]} + Удача: ${result[1]}';
    } else if (tempSelectedTable['dice_type'] == 'separate') {
      buttonText = '${result[0]} + ${result[1]}';
    } else {
      buttonText = result.first.toString();
    }

    onResultUpdated(result, buttonText);
  } else {
    int roll = _rollOneDice(diceType);
    onResultUpdated([roll], roll.toString());
  }
}

int _rollOneDice(int sides) {
  return (1 + (sides * (new DateTime.now().microsecondsSinceEpoch % 1000000) / 1000000)).floor();
}