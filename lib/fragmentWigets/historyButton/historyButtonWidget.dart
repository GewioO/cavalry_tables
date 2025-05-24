import 'package:flutter/material.dart';
import 'package:cavalry_table/baseWigets/commonFlatButton.dart';

class HistoryButton extends StatefulWidget {
  const HistoryButton({Key? key}) : super(key: key);

  @override
  State<HistoryButton> createState() => _HistoryButtonState();
}

class _HistoryButtonState extends State<HistoryButton> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 30));
    return Container(
            alignment: Alignment.bottomLeft,
            child: CommonFlatButton(
              buttonText: "Історія",
              onPressedCallback: () {},
            ),
    );
  }
}


