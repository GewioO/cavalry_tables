import 'package:flutter/material.dart';
import 'package:cavalry_table/baseWigets/commonFlatButton.dart';
import 'package:cavalry_table/fragmentWigets/diceButton/diceButtonWidget.dart';
import 'package:cavalry_table/fragmentWigets/bottomBar/bottomBar.dart';
import 'package:cavalry_table/fragmentWigets/tablesList/tablesList.dart';
import 'package:cavalry_table/tablesPaths.dart';
import 'package:cavalry_table/tablesHandler/tablesHandler.dart';
import 'package:cavalry_table/fragmentWigets/diceButton/diceButtonLogic.dart';
import 'package:cavalry_table/fragmentWigets/historyButton/historyButtonWidget.dart';
import 'package:cavalry_table/fragmentWigets/InstructionButton/InstructionButtonWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //create state for preset button or separate table value
  //create preset button, that uses a few table

  var tablesHandler = TablesHandler();
  Map<String, dynamic>? selectedResult;
  Map<String, dynamic>? tablesCharacter;
  Map<String, dynamic>? tablesCharacterEquipment;
  Map<String, dynamic>? tablesCharacterExtras;
  Map<String, dynamic>? tablesCharacterSkills;
  final tablesPaths = TablesPathes();
  Map<String, dynamic>? tempSelectedTable;
  bool isSingleThrown = false;

  @override
  void initState() {
    super.initState();
    tablesHandler.loadTablesCharacter().then((data) {
      setState(() {
        tablesCharacter = data['tables_character'];
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

  void updateResult(Map<String, dynamic>? result) {
    setState(() {
      selectedResult = result;
      isSingleThrown = false;
      _closeDrawer();
    });
  }

  void updateTempTable(Map<String, dynamic>? table) {
    setState(() {
      tempSelectedTable = table;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  void changeSingleThrownValue() {
    setState(() {
      isSingleThrown = true;
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
      appBar: AppBar(title: const Text('')),
      body: MainPageContent(
        tablesHandler: tablesHandler,
        tablesCharacter: tablesCharacter,
        selectedTable: selectedResult,
        tempSelectedTable: tempSelectedTable,
        isSingleThrown: isSingleThrown,
        onPressedCallback: changeSingleThrownValue,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: BottomBar(),
      ),
      endDrawer: Drawer(
        child: Tableslist(
          tablesHandler: tablesHandler,
          tablesCharacter: tablesCharacter,
          tablesCharacterEquipment: tablesCharacterEquipment,
          onResultSelected: updateResult,
          updateTempTable: updateTempTable,
          tablesCharacterExtras: tablesCharacterExtras,
          tablesCharacterSkills: tablesCharacterSkills,
        ),
      ),
    );
  }
}

class MainPageContent extends StatefulWidget {
  final TablesHandler tablesHandler;
  final Map<String, dynamic>? tablesCharacter;
  final Map<String, dynamic>? selectedTable;
  final Map<String, dynamic>? tempSelectedTable;
  final VoidCallback onPressedCallback;
  final bool isSingleThrown; 
  const MainPageContent({
    Key? key,
    required this.tablesHandler,
    required this.tablesCharacter,
    required this.selectedTable,
    required this.tempSelectedTable,
    required this.onPressedCallback,
    required this.isSingleThrown,
  }) : super(key: key);

  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  static const int defaultRollValue = 20;
  int lastRoll = defaultRollValue;
  bool _expandedDicesList = false;
  int _diceType = defaultRollValue;
  String _diceButtonText = defaultRollValue.toString();
  var _thrownResult;
  bool _thrownModeSingleDice = false;
  List<int> diceValues = [4, 6, 8, 10, 12, 20, 100];
  
  @override
  void initState() {
    super.initState();
    setState(() {
      _thrownModeSingleDice = widget.isSingleThrown;
    });
  }

  @override
  void didUpdateWidget(covariant MainPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSingleThrown != widget.isSingleThrown) {
      setState(() {
        _thrownModeSingleDice = widget.isSingleThrown;
      });
    }
    if (oldWidget.selectedTable != widget.selectedTable && widget.selectedTable != null) {
      setState(() {
        _thrownResult = widget.tablesHandler.getResult(widget.selectedTable);
        lastRoll = int.parse(_thrownResult.first);
        _diceButtonText = _thrownResult.first;
      });
    }
  }

  void _changeExpandedValue() {
    setState(() {
      _expandedDicesList = _expandedDicesList?false:true;
    });
  }

  void _changeDiceType(int value) {
    setState(() {
      print('Change');
      _diceType = value;
      lastRoll = value;
      _diceButtonText = lastRoll.toString();
      widget.onPressedCallback();
    });
  }

  //change dice tiles on builder
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand (
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                SizedBox(height: 200),
                Container(
                  alignment: Alignment.topCenter,
                  child: (!_thrownModeSingleDice && _thrownResult != null && _thrownResult.length > 1) ?
                    Text(_thrownResult[1], textAlign: TextAlign.center,) :
                    Text('text', textAlign: TextAlign.center,),
                ),
                SizedBox(height: 20),
                _expandedDicesList?
                Container():
                DiceButton(
                  onPressedCallback: () {
                    handleDiceButtonPressed(
                      thrownModeSingleDice: _thrownModeSingleDice,
                      tempSelectedTable: widget.tempSelectedTable,
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
                Container(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: ExpansionTile(title: Text('Обери кістку'),
                        initiallyExpanded: _expandedDicesList,
                        onExpansionChanged:(bool expanded) {
                          _changeExpandedValue();
                        },
                        children: diceValues.map((value) {
                          return CommonFlatButton(
                            buttonText: value.toString(),
                            onPressedCallback: () => _changeDiceType(value),
                          );
                        }).toList(),),
                    ),
                ),
            ],
          ),
          HistoryButton(),
          InstructionButton(),
        ],
      )
    );
  }
}