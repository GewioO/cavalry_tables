import 'package:flutter/material.dart';

class CommonRoundButton extends StatefulWidget {
    final String buttonText;
    final VoidCallback onPressedCallback;
    const CommonRoundButton({
        super.key,
        required this.buttonText,
        required this.onPressedCallback,
    });
    @override
    State<CommonRoundButton> createState() => _CommonRoundButtonState();
}

class _CommonRoundButtonState extends State<CommonRoundButton> {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 30),
    );

    @override
    Widget build(BuildContext context) {
        return IconButton(
            icon: const Icon(Icons.plus_one),
            onPressed: widget.onPressedCallback,
        );
    }
}