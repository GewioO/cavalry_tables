import 'package:flutter/material.dart';

class CommonFlatButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressedCallback;
  const CommonFlatButton({
    super.key,
    required this.buttonText,
    required this.onPressedCallback,
  });
  @override
  State<CommonFlatButton> createState() => _CommonFlatButtonState();
}

class _CommonFlatButtonState extends State<CommonFlatButton> {
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 30),
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: widget.onPressedCallback,
      child: Text(widget.buttonText),
    );
  }
}
