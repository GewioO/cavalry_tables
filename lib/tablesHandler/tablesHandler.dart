import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../dices/throwDice.dart';

class TablesHandler {
  Future<Map<String, dynamic>> loadTablesCharacter() async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/tablesStorage/characterTables/tables_charater.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData;
  }

  Future<Map<String, dynamic>> loadTablesCharacterEquipment() async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/tablesStorage/characterTables/tables_character_equipment.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData;
  }

  Future<Map<String, dynamic>> loadTablesCharacterExtras() async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/tablesStorage/characterTables/tables_character_extras.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData;
  }

  Future<Map<String, dynamic>> loadTablesCharacterSkills() async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/tablesStorage/characterTables/tables_character_skills.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData;
  }

  Future<Map<String, dynamic>> loadTableWholeCharacterSequence() async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/tablesStorage/presetSequences/character_creation_sequence.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData;
  }

  Future<Map<String, dynamic>> loadTablesCharacterKatafract() async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/tablesStorage/characterTables/tables_character_katafract.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData;
  }

  Future<Map<String, dynamic>> loadGenerationResultsList() async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/tablesStorage/generationResultsTables/generation_results.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return jsonData;
  }

  List<String> getResult(Map<String, dynamic>? table) {
    if (table?['title'] == 'Гроші') {
      List<int> result = rollTwoDecesSeparateValues(
        int.parse(table?['dice'][0]),
        int.parse(table?['dice'][1]),
      );
      return [
        (int.parse(table?['modifier']) + result[0] + result[1]).toString(),
        result[0].toString(),
        result[1].toString(),
      ];
    } else if (table?['dice_type'] == 'separate') {
      List<int> result = rollTwoDecesSeparateValues(
        int.parse(table?['dice'][0]),
        int.parse(table?['dice'][1]),
      );
      return [result[0].toString(), result[1].toString()];
    } else if (table?['dice_type'] == 'combine') {
      List<int> result = rollTwoDecesSeparateValues(
        int.parse(table?['dice'][0]),
        int.parse(table?['dice'][1]),
      );
      return [
        result[0].toString(),
        result[1].toString(),
        table?['results'][result[0].toString() + result[1].toString()],
      ];
    } else if (table?['dice'].length == 2) {
      int result = rollTwoDeces(
        int.parse(table?['dice'][0]),
        int.parse(table?['dice'][1]),
      );
      return [result.toString(), table?['results'][result.toString()]];
    } else {
      int result = rollOneDice(int.parse(table?['dice'][0]));
      return [result.toString(), table?['results'][result.toString()]];
    }
  }

  //add result to json. Returnupdated json
  //save json
}
