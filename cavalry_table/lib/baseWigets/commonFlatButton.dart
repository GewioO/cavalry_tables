import 'package:flutter/material.dart';

class CommonFlatButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressedCallback;
  CommonFlatButton({Key? key, required this.buttonText, required this.onPressedCallback,}) : super(key: key);
  @override
  State<CommonFlatButton> createState() => _CommonFlatButtonState();
}

class _CommonFlatButtonState extends State<CommonFlatButton> {
  final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 30));

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(style: style, onPressed: widget.onPressedCallback, child: Text(widget.buttonText));
  }
}