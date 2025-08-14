import 'package:cavalry_table/pages/pagesNavigator.dart';
import 'package:cavalry_table/pages/savedCharactersPage.dart';
import 'package:flutter/material.dart';
import 'package:cavalry_table/baseWigets/commonFlatButton.dart';

class SavedCharactersButton extends StatefulWidget {
    final PagesNavigator navigatorObj;
    const SavedCharactersButton(
        {super.key,
        required this.navigatorObj});

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
                        const SavedCharactersPage(),
                    );
                },
            ),
        );
    }
}