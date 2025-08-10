import 'package:flutter/material.dart';
import '../../tablesPaths.dart';
import 'package:cavalry_table/tablesHandler/tablesHandler.dart';

class Tableslist extends StatefulWidget {
  final TablesHandler tablesHandler;
  final Map<String, dynamic>? tablesCharacter;
  final Map<String, dynamic>? tablesCharacterEquipment;
  final Map<String, dynamic>? tablesCharacterExtras;
  final Map<String, dynamic>? tablesCharacterSkills;
  final Function(Map<String, dynamic>?) onResultSelected;
  final Function(Map<String, dynamic>?) updateTempTable;
  const Tableslist({
    super.key,
    required this.tablesHandler,
    required this.tablesCharacter,
    required this.onResultSelected,
    required this.updateTempTable,
    required this.tablesCharacterEquipment,
    required this.tablesCharacterExtras,
    required this.tablesCharacterSkills,
  });

  @override
  State<Tableslist> createState() => _TableslistState();
}

class _TableslistState extends State<Tableslist> {
  //get table handler for parent class
  void _tapOnElement(Map<String, dynamic>? table) {
    widget.onResultSelected(table);
    widget.updateTempTable(table);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('Таблиці персонажа'),
          children: [
            Column(
              children: List.generate(7, (index) {
                final key = 'table_${index + 1}';
                final table = widget.tablesCharacter![key];
                return ListTile(
                  onTap: () {
                    _tapOnElement(table);
                  },
                  title: Text(table['title']),
                );
              }),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Таблиці Спорядження'),
          children: [
            Column(
              children: List.generate(4, (index) {
                final key = 'table_${index + 1}';
                final table = widget.tablesCharacterEquipment![key];
                return ListTile(
                  onTap: () {
                    _tapOnElement(table);
                  },
                  title: Text(table['title']),
                );
              }),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Таблиці Дееталей Персонажа'),
          children: [
            Column(
              children: List.generate(4, (index) {
                final key = 'table_${index + 1}';
                final table = widget.tablesCharacterExtras![key];
                return ListTile(
                  onTap: () {
                    _tapOnElement(table);
                  },
                  title: Text(table['title']),
                );
              }),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Таблиці Навичок Персонажа'),
          children: [
            Column(
              children: List.generate(2, (index) {
                final key = 'table_${index + 1}';
                final table = widget.tablesCharacterSkills![key];
                return ListTile(
                  onTap: () {
                    _tapOnElement(table);
                  },
                  title: Text(table['title']),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
