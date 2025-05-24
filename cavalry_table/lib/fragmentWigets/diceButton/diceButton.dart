import 'package:flutter/material.dart';

class DiceButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressedCallback;
  const DiceButton({Key? key, required this.buttonText, required this.onPressedCallback,}) : super(key: key);

  @override
  State<DiceButton> createState() => _DiceButtonState();
}

class _DiceButtonState extends State<DiceButton> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 30));
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(style: style, onPressed: widget.onPressedCallback, child: Text(widget.buttonText),),
        
      ),
    );
  }
}