import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cavalry_table/tablesPaths.dart';
import 'package:cavalry_table/tablesHandler/tablesHandler.dart';
import 'package:cavalry_table/pages/pagesNavigator.dart';
import 'package:cavalry_table/pages/presetSequencePage/sequencesManager.dart';
import 'package:cavalry_table/fragmentWigets/diceButton/diceButtonWidget.dart';
import 'package:cavalry_table/utils/common_constants.dart';

class PresetSequencePage extends StatefulWidget {
  final PagesNavigator navigatorObj;
  final GeneratorTypes tableType;

  const PresetSequencePage({
    super.key,
    required this.navigatorObj,
    required this.tableType,
  });

  @override
  State<PresetSequencePage> createState() => _PresetSequencePageState();
}

class _PresetSequencePageState extends State<PresetSequencePage> {
  final TablesHandler tablesHandler = TablesHandler();
  final TablesPathes tablesPaths = TablesPathes();

  Map<String, dynamic> sequenceMap = {};
  SequenceManager? sequenceManager;
  Map<String, dynamic>? currentTableData;
  Map<String, dynamic>? selectedSubtable;
  List<String>? thrownResult;
  String diceButtonText = "";
  String _textLableNaming = "";
  bool _isWasLastRoll = false;
  String _textLableResult = "";
  String savedSom = "";

  @override
  void initState() {
    super.initState();
    loadSequence();
  }

  Future<void> loadSequence() async {
    final sequenceData = await tablesHandler.loadTableWholeCharacterSequence();
    sequenceMap = sequenceData['character_creation_sequence'];
    sequenceManager = SequenceManager(
      sequenceMap: sequenceMap,
      sequenceType: widget.tableType,
    );
    await loadCurrentTable();
  }

  Future<void> loadCurrentTable() async {
    if (sequenceManager == null || sequenceManager!.isFinished) {
      widget.navigatorObj.backPage(context);
      return;
    }

    final tableKey = sequenceManager!.currentTableKey;
    if (tableKey == null) return;

    final data = await loadTableByKey(tableKey);
    setState(() {
      currentTableData = data;
      updateSubtable();
    });
  }

  Future<Map<String, dynamic>?> loadTableByKey(String key) async {
    switch (key) {
      case 'tables_character':
        return (await tablesHandler.loadTablesCharacter())[key];
      case 'tables_character_skills':
        return (await tablesHandler.loadTablesCharacterSkills())[key];
      case 'tables_character_equipment':
        return (await tablesHandler.loadTablesCharacterEquipment())[key];
      case 'tables_character_extras':
        return (await tablesHandler.loadTablesCharacterExtras())[key];
      default:
        return null;
    }
  }

  void setTextLableAndDiceResult(List<String>? result) {
    debugPrint("🎲 selectedSubtable?['title']: ${selectedSubtable?['title']}");
    setState(() {
      if(selectedSubtable?['dice_type'] == 'combine') {
        _textLableResult = result![2];
        diceButtonText = "${result[0]} + ${result[1]}";
      } 
      else if(selectedSubtable?['title'] == "Стійкість та удача") {
        _textLableResult = ([int.parse(result![0]), int.parse(result![1])].reduce(max) + int.parse(savedSom)).toString();
        diceButtonText = "${result[0]} + ${result[1]}";
      }
      else if(selectedSubtable?['title'] == "Гроші") {
        _textLableResult = result!.first;
        diceButtonText = "${result[1]} + ${result[2]}";
      }
      else {
        _textLableResult = result![1];
        diceButtonText = result.first;
      }
    });
  }

  void saveSkills(List<String>? result) {
      savedSom = result![1];
  }

  void updateSubtable() {
    final subKey = "table_${sequenceManager!.currentSubIndex}";
    final nextTable = currentTableData?[subKey];
    if (nextTable != null) {
      setState(() {
        selectedSubtable = nextTable;
      });
    } 
    else {
      if (sequenceManager!.moveNextTable()) {
        loadCurrentTable();
      } 
      else {
        _isWasLastRoll = true;
      }
    }
  }

  void handleDiceRoll() {
    if (!_isWasLastRoll){
      final subtableTitle = selectedSubtable?['title'] ?? '❌ name is abscent';
      debugPrint("🎲 Using subtable: $subtableTitle");
      _textLableNaming = selectedSubtable?['title'];
      final result = tablesHandler.getResult(selectedSubtable);
      if(selectedSubtable!['title'] == "Соматика (СОМ)") {
        saveSkills(result);
      }
      setState(() {
        setTextLableAndDiceResult(result);
        thrownResult = result;
        debugPrint("🎲 thrownResult: $thrownResult");
        debugPrint("🎲 savedSom: $savedSom");
      });
      sequenceManager!.advanceSubtable();
      updateSubtable();
    }
    else {
      _isWasLastRoll = false;
      widget.navigatorObj.backPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedSubtable == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => widget.navigatorObj.backPage(context)),
        title: const Text(""),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 200),
            Text(
              (thrownResult != null && thrownResult!.length > 1)
                  ? ("$_textLableNaming: $_textLableResult")
                  : 'Киньте кістку',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            DiceButton(
              onPressedCallback: handleDiceRoll,
              buttonText: diceButtonText,
            )
          ],
        ),
      ),
    );
  }
}
