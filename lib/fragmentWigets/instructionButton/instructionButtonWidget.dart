import 'package:flutter/material.dart';
import 'package:cavalry_table/baseWigets/commonFlatButton.dart';

class InstructionButton extends StatefulWidget {
  const InstructionButton({super.key});

  @override
  State<InstructionButton> createState() => _InstructionButtonState();
}

class _InstructionButtonState extends State<InstructionButton> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 30),
    );
    return Container(
      alignment: Alignment.bottomRight,
      child: CommonFlatButton(
        buttonText: "Інструкція",
        onPressedCallback: () {},
      ),
    );
  }
}
