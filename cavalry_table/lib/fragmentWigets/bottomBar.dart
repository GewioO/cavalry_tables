import 'package:flutter/material.dart';
import '../baseWigets/commonRoundButton.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Row(
        children: <Widget>[
          CommonRoundButton(buttonText: "1", onPressedCallback: () {},),
          CommonRoundButton(buttonText: "1", onPressedCallback: () {},),
          CommonRoundButton(buttonText: "1", onPressedCallback: () {},),
          CommonRoundButton(buttonText: "1", onPressedCallback: () {},),
          CommonRoundButton(buttonText: "1", onPressedCallback: () {},),
        ],
      ),
    );
  }
}