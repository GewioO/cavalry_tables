import 'dart:convert';
import 'dart:io';
import 'package:cavalry_table/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cavalry_table/pages/pagesNavigator.dart';

class CharacterListPage extends StatefulWidget {
    final PagesNavigator navigatorObj;
    final Map<String, dynamic> characterSavedList;

    const CharacterListPage({
        super.key,
        required this.navigatorObj,
        required this.characterSavedList,
    });

    @override
    State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
    late Map<String, TextEditingController> _controllers;
    late final List<String> _allKeys;

    @override
    void initState() {
        super.initState();
        _allKeys = widget.characterSavedList.keys.toList();

        _controllers = {};
        for (var key in _allKeys) {
            _controllers[key] = TextEditingController(text: "Редагувати значення");
        }
    }

    @override
    void dispose() {
        _controllers.forEach((_, controller) => controller.dispose());
        super.dispose();
    }

    Future<void> _saveChanges() async {
        try {
            final directory = await getApplicationDocumentsDirectory();
            final dirPath = directory.path;
            int nextFileNumber = 1;
            while (await File(
                '$dirPath/персонаж_$nextFileNumber.json',
            ).exists()) {
                nextFileNumber++;
            }

            final filePath = '$dirPath/персонаж_$nextFileNumber.json';
            final file = File(filePath);

            Map<String, dynamic> updatedData = {};
            for (var key in _allKeys) {
                var originalValue = widget.characterSavedList[key];
                if (originalValue is List && originalValue.isNotEmpty) {
                    String newValue = _controllers[key]?.text ?? '';
                    updatedData[key] = [originalValue[0], newValue];
                }
            }

            String jsonString = json.encode(updatedData);
            await file.writeAsString(jsonString);

            ScaffoldMessenger.of(
                context,
            ).showSnackBar(SnackBar(content: Text('Character saved to $filePath')));
        } catch (e) {
            ScaffoldMessenger.of(
                context,
            ).showSnackBar(SnackBar(content: Text('Error saving changes: $e')));
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                leading: BackButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                        (Route<dynamic> route) => false,
                ),
                ),
                title: const Text("Character Sheet"),
            ),
            body: Column(
                children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: _allKeys.length,
                            itemBuilder: (context, index) {
                                String key = _allKeys[index];
                                var itemData = widget.characterSavedList[key];

                                if (itemData is List && itemData.isNotEmpty) {
                                    final displayText =
                                        itemData.length > 1 ? itemData.sublist(1).join(', ') : '';

                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 16.0,
                                        ),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    '${itemData[0]}: $displayText',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                ),
                                                SizedBox(height: 8.0),
                                                TextFormField(
                                                    controller: _controllers[key],
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        isDense: true,
                                                    ),
                                                ),
                                            ],
                                        ),
                                    );
                                }
                                return SizedBox.shrink();
                            },
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                            ),
                            child: const Text("Save Character"),
                        ),
                    ),
                ],
            ),
        );
    }
}