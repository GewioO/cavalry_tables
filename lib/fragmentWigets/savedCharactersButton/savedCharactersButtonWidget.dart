import 'package:cavalry_table/pages/characterListPage.dart';
import 'package:cavalry_table/pages/pagesNavigator.dart';
import 'package:flutter/material.dart';
import 'package:cavalry_table/baseWigets/commonFlatButton.dart';

class SavedCharactersButton extends StatefulWidget {
    final PagesNavigator navigatorObj;
    final Map<String, dynamic> characterSavedList;
    const SavedCharactersButton(
        {super.key,
        required this.navigatorObj,
        required this.characterSavedList});

    @override
    State<SavedCharactersButton> createState() => _SavedCharactersButtonState();
}

class _SavedCharactersButtonState extends State<SavedCharactersButton> {
    @override
    Widget build(BuildContext context) {
        final ButtonStyle style = ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 30),
        );
        return Container(
            alignment: Alignment.bottomLeft,
            child: CommonFlatButton(
                buttonText: "Персонажі",
                onPressedCallback: () {
                    widget.navigatorObj.changePage(
                        context,
                        CharacterListPage(
                            navigatorObj: widget.navigatorObj,
                            characterSavedList: widget.characterSavedList,
                        ),
                    );
                },
            ),
        );
    }
}