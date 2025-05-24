import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../dices/throwDice.dart';

class TablesHandler {
  	Future<Map<String, dynamic>> loadTablesCharacter() async {
    	final String jsonString = await rootBundle.loadString('lib/assets/tablesStorage/characterTables/tables_charater.json');
    	final Map<String, dynamic> jsonData = json.decode(jsonString);
    	return jsonData;
  	}
    Future<Map<String, dynamic>> loadTablesCharacterEquipment() async {
    	final String jsonString = await rootBundle.loadString('lib/assets/tablesStorage/characterTables/tables_character_equipment.json');
    	final Map<String, dynamic> jsonData = json.decode(jsonString);
    	return jsonData;
  	}
    Future<Map<String, dynamic>> loadTablesCharacterExtras() async {
    	final String jsonString = await rootBundle.loadString('lib/assets/tablesStorage/characterTables/tables_character_extras.json');
    	final Map<String, dynamic> jsonData = json.decode(jsonString);
    	return jsonData;
  	}
    Future<Map<String, dynamic>> loadTablesCharacterSkills() async {
    	final String jsonString = await rootBundle.loadString('lib/assets/tablesStorage/characterTables/tables_character_skills.json');
    	final Map<String, dynamic> jsonData = json.decode(jsonString);
    	return jsonData;
  	}

	List<String> getResult(Map<String, dynamic>? table) {
		if (table?['dice'].length == 2 && table?['title'] != 'Гроші' &&
      table?['dice_type'] != 'separate') {
			int result = rollTwoDeces(int.parse(table?['dice'][0]), int.parse(table?['dice'][1]));
            return [result.toString(), table?['results'][result.toString()]];
        } 
    else if (table?['title'] == 'Гроші') {
      List<int> result = rollTwoDecesSeparateValues(int.parse(table?['dice'][0]), int.parse(table?['dice'][1]));
      return [(int.parse(table?['modifier']) + result[0] + result[1]).toString(), result[0].toString(), result[1].toString()];
    }
    else if (table?['dice_type'] == 'separate') {
      List<int> result = rollTwoDecesSeparateValues(int.parse(table?['dice'][0]), int.parse(table?['dice'][1]));
      return [result[0].toString(), result[1].toString()];
    }
		else {
			int result = rollOneDice(int.parse(table?['dice'][0]));
      return [result.toString(), table?['results'][result.toString()]];
    }
	}
}
