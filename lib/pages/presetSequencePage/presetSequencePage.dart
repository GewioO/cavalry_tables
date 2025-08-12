import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cavalry_table/tablesPaths.dart';
import 'package:cavalry_table/tablesHandler/tablesHandler.dart';
import 'package:cavalry_table/pages/pagesNavigator.dart';
import 'package:cavalry_table/pages/presetSequencePage/sequencesManager.dart';
import 'package:cavalry_table/fragmentWigets/diceButton/diceButtonWidget.dart';
import 'package:cavalry_table/utils/common_constants.dart';
import 'package:cavalry_table/pages/characterListPage.dart';

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
    late Map<String, dynamic> characterSavedList;
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
        debugPrint("🎲 tableType: ${widget.tableType}");
        final sequenceData = await tablesHandler.loadTableWholeCharacterSequence();
        sequenceMap = sequenceData['character_creation_sequence'];
        sequenceManager = SequenceManager(
            sequenceMap: sequenceMap,
            sequenceType: widget.tableType,
        );
        await loadCurrentTable();
        characterSavedList = await tablesHandler.loadGenerationResultsList();
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
            case 'tables_character_katafract':
                return (await tablesHandler.loadTablesCharacterKatafract())[key];
            default:
                return null;
        }
    }

    void setTextLableAndDiceResult(List<String>? result) {
        debugPrint("🎲 selectedSubtable?['title']: ${selectedSubtable?['title']}");
        setState(() {
            if (selectedSubtable?['dice_type'] == 'combine') {
                _textLableResult = result![2];
                diceButtonText = "${result[0]} + ${result[1]}";
            } else if (selectedSubtable?['title'] == "Стійкість та удача") {
                _textLableResult =
                    ([int.parse(result![0]), int.parse(result![1])].reduce(max) +
                        int.parse(savedSom))
                        .toString();
                diceButtonText = "${result[0]} + ${result[1]}";
            } else if (selectedSubtable?['title'] == "Гроші") {
                _textLableResult = result!.first;
                diceButtonText = "${result[1]} + ${result[2]}";
            } else {
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
        } else {
            if (sequenceManager!.moveNextTable()) {
                loadCurrentTable();
            } else {
                setState(() {
                    _isWasLastRoll = true;
                });
            }
        }
    }

    void handleDiceRoll() {
        if (!_isWasLastRoll) {
            final subtableTitle = selectedSubtable?['title'] ?? '❌ name is abscent';
            debugPrint("🎲 Using subtable: $subtableTitle");
            _textLableNaming = selectedSubtable?['title'];
            final result = tablesHandler.getResult(selectedSubtable);
            if (selectedSubtable!['title'] == "Соматика (СОМ)") {
                saveSkills(result);
            }
            saveGeneratedResult(
                sequenceManager!.getSavedGenerationMappingKey(
                    selectedSubtable!['title'],
                ),
                result,
            );
            setState(() {
                setTextLableAndDiceResult(result);
                thrownResult = result;
                debugPrint("🎲 thrownResult: $thrownResult");
                debugPrint("🎲 savedSom: $savedSom");
            });
            sequenceManager!.advanceSubtable();
            updateSubtable();
        } else {
            _isWasLastRoll = false;
            CharacterListPage characterListPage = CharacterListPage(
                navigatorObj: widget.navigatorObj,
                characterSavedList: characterSavedList,
            );
            widget.navigatorObj.changePage(context, characterListPage);
        }
    }

    void saveGeneratedResult(List<String> key, List<String> result) {
        if (key.isNotEmpty && key[0].isNotEmpty) {
            if (characterSavedList[key[0]] is List &&
                characterSavedList[key[0]].length > 1 &&
                characterSavedList[key[0]][1] == "") {
                characterSavedList[key[0]].removeAt(1);
            }

            for (var item in result) {
                characterSavedList[key[0]].add(item.toString());
            }

            debugPrint("!!!!! ${characterSavedList[key[0]]}");
        } else {
            debugPrint("⚠️ Key '$key' not find characterSavedList");
        }
    }

    Future<void> _quickGenerateCharacter() async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
            },
        );

        while (sequenceManager != null && !sequenceManager!.isFinished) {
            final subtableTitle = selectedSubtable?['title'] ?? '❌ name is abscent';
            debugPrint("🎲 Quickly generating for: $subtableTitle");

            final result = tablesHandler.getResult(selectedSubtable);

            if (selectedSubtable!['title'] == "Соматика (СОМ)") {
                saveSkills(result);
            }

            saveGeneratedResult(
                sequenceManager!.getSavedGenerationMappingKey(
                    selectedSubtable!['title'],
                ),
                result,
            );

            sequenceManager!.advanceSubtable();

            final subKey = "table_${sequenceManager!.currentSubIndex}";
            var nextTable = currentTableData?[subKey];

            if (nextTable != null) {
                selectedSubtable = nextTable;
            } else {
                if (sequenceManager!.moveNextTable()) {
                    final tableKey = sequenceManager!.currentTableKey;
                    if (tableKey != null) {
                        currentTableData = await loadTableByKey(tableKey);
                        final newSubKey = "table_${sequenceManager!.currentSubIndex}";
                        selectedSubtable = currentTableData?[newSubKey];
                    }
                } else {
                    break;
                }
            }
        }

        Navigator.pop(context);

        CharacterListPage characterListPage = CharacterListPage(
            navigatorObj: widget.navigatorObj,
            characterSavedList: characterSavedList,
        );
        widget.navigatorObj.changePage(context, characterListPage);
    }

    int _getDiceSides() {
        if (selectedSubtable != null) {
            if (selectedSubtable!['dice_type'] == 'separate' ||
                selectedSubtable!['dice_type'] == 'combine' ||
                (selectedSubtable!['dice'] as List).length == 2) {
                return 0; // To show dice-alt icon
            } else {
                return int.tryParse(selectedSubtable!['dice'][0].toString()) ?? 0;
            }
        }
        return 0;
    }

    @override
    Widget build(BuildContext context) {
        if (selectedSubtable == null) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
            appBar: AppBar(
                leading: BackButton(
                    onPressed: () => widget.navigatorObj.backPage(context),
                ),
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
                            diceSides: _getDiceSides(),
                            onPressedCallback: handleDiceRoll,
                            buttonText: diceButtonText,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: _quickGenerateCharacter,
                            child: const Text("Пропустити кидки"),
                        ),
                    ],
                ),
            ),
        );
    }
}