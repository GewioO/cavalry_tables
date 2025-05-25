import 'package:flutter/material.dart';
import 'package:cavalry_table/baseWigets/commonFlatButton.dart';
import 'package:cavalry_table/fragmentWigets/diceButton/diceButtonWidget.dart';
import 'package:cavalry_table/fragmentWigets/tablesList/tablesList.dart';
import 'package:cavalry_table/tablesPaths.dart';
import 'package:cavalry_table/tablesHandler/tablesHandler.dart';
import 'package:cavalry_table/fragmentWigets/diceButton/diceButtonLogic.dart';
import 'package:cavalry_table/fragmentWigets/historyButton/historyButtonWidget.dart';
import 'package:cavalry_table/fragmentWigets/InstructionButton/InstructionButtonWidget.dart';
import 'package:cavalry_table/pages/homePage.dart';
import 'package:cavalry_table/pages/pagesNavigator.dart';

class PresetSequencePage extends StatefulWidget {
  final PagesNavigator navigatorObj;
  const PresetSequencePage({super.key, required this.navigatorObj});
  
  @override
  State<PresetSequencePage> createState() => _PresetSequencePageState();
}

class _PresetSequencePageState extends State<PresetSequencePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var tablesHandler = TablesHandler();
  Map<String, dynamic>? tablesCharacter;
  Map<String, dynamic>? tablesCharacterEquipment;
  Map<String, dynamic>? tablesCharacterExtras;
  Map<String, dynamic>? tablesCharacterSkills;
  final tablesPaths = TablesPathes();
  Map<String, dynamic>? selectedTable;

  @override
  void initState() {
    super.initState();
    tablesHandler.loadTablesCharacter().then((data) {
      setState(() {
        tablesCharacter = data['tables_character'];
        selectedTable = tablesCharacter?["table_1"];
      });
    });
    tablesHandler.loadTablesCharacterEquipment().then((data) {
      setState(() {
        tablesCharacterEquipment = data['tables_character_equipment'];
      });
    });
    tablesHandler.loadTablesCharacterExtras().then((data) {
      setState(() {
        tablesCharacterExtras = data['tables_character_extras'];
      });
    });
    tablesHandler.loadTablesCharacterSkills().then((data) {
      setState(() {
        tablesCharacterSkills = data['tables_character_skills'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tablesCharacter == null ||
        tablesCharacter![tablesCharacter?.keys.first] == null ||
        tablesCharacter![tablesCharacter?.keys.first]['title'] == null ||
        tablesCharacterEquipment == null ||
        tablesCharacterEquipment![tablesCharacterEquipment?.keys.first] == null ||
        tablesCharacterEquipment![tablesCharacterEquipment?.keys.first]['title'] == null ||
        tablesCharacterExtras == null ||
        tablesCharacterExtras![tablesCharacterExtras?.keys.first] == null ||
        tablesCharacterExtras![tablesCharacterExtras?.keys.first]['title'] == null ||
        tablesCharacterSkills == null ||
        tablesCharacterSkills![tablesCharacterSkills?.keys.first] == null ||
        tablesCharacterSkills![tablesCharacterSkills?.keys.first]['title'] == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: BackButton(
          onPressed: () {
            widget.navigatorObj.backPage(context);
          },
        ),
      ),
      body: PresetPageContent(
        tablesHandler: tablesHandler,
        tablesCharacter: tablesCharacter,
        selectedTable: selectedTable,
        onPressedCallback: () {},
      ),
    );
  }
}

class PresetPageContent extends StatefulWidget {
  final TablesHandler tablesHandler;
  final Map<String, dynamic>? tablesCharacter;
  final Map<String, dynamic>? selectedTable;
  final VoidCallback onPressedCallback;
  
  @override
  const PresetPageContent({
    Key? key,
    required this.tablesHandler,
    required this.tablesCharacter,
    required this.selectedTable,
    required this.onPressedCallback,
  }) : super(key: key);

  @override
  State<PresetPageContent> createState() => _PresetPageContentState();
}

class _PresetPageContentState extends State<PresetPageContent> {
  final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  static const int defaultRollValue = 20;
  int lastRoll = defaultRollValue;
  int _diceType = defaultRollValue;
  String _diceButtonText = defaultRollValue.toString();
  var _thrownResult;
  List<int> diceValues = [4, 6, 8, 10, 12, 20, 100];

  @override
  void didUpdateWidget(covariant PresetPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTable != widget.selectedTable && widget.selectedTable != null) {
      setState(() {
        _thrownResult = widget.tablesHandler.getResult(widget.selectedTable);
        lastRoll = int.parse(_thrownResult.first);
        _diceButtonText = _thrownResult.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          SizedBox(height: 200),
                Container(
                  alignment: Alignment.topCenter,
                  child: (_thrownResult != null && _thrownResult.length > 1) ?
                    Text(_thrownResult[1], textAlign: TextAlign.center,) :
                    Text('text', textAlign: TextAlign.center,),
                ),
                SizedBox(height: 20),
                DiceButton(
                  onPressedCallback: () {
                    handleDiceButtonPressed(
                      thrownModeSingleDice: false,
                      tempSelectedTable: widget.selectedTable,
                      tablesHandler: widget.tablesHandler,
                      diceType: _diceType,
                      onResultUpdated: (result, buttonText) {
                        setState(() {
                          _thrownResult = result;
                          _diceButtonText = buttonText;
                          
                          lastRoll = int.tryParse(result.first.toString()) ?? lastRoll;
                        });
                      },
                    );
                  },
                  buttonText: _diceButtonText,
                ),
        ],
      ),
    );
  }
}