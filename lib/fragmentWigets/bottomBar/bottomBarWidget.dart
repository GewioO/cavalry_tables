import 'package:flutter/material.dart';
import '../../baseWigets/commonRoundButton.dart';
import 'package:cavalry_table/fragmentWigets/bottomBar/bottomBarLogic.dart';
import 'package:cavalry_table/pages/presetSequencePage/presetSequencePage.dart';
import 'package:cavalry_table/pages/pagesNavigator.dart';
import 'package:cavalry_table/utils/common_constants.dart';

class BottomBar extends StatefulWidget {
  final PagesNavigator navigatorObj;
  const BottomBar({super.key, required this.navigatorObj});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late PresetSequencePage presetSequencePage;

  @override
  void initState() {
    super.initState();
    presetSequencePage = PresetSequencePage(navigatorObj: widget.navigatorObj, tableType: [GeneratorTypes.DEFAULT],);
    
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    void _startButtonSequence(Widget pageWithType)
    {
      startTransitionButtonSequence(context, pageWithType, widget.navigatorObj);
    }

    return Center(
      child: Row(
        children: <Widget>[
          CommonRoundButton(
            buttonText: "4", 
            onPressedCallback: () {
              presetSequencePage.tableType = [GeneratorTypes.CHARACTER_WITH_EQUIP];
              _startButtonSequence(presetSequencePage);
            }
          ),
          CommonRoundButton(
            buttonText: "1", 
            onPressedCallback: () {
              presetSequencePage.tableType = [GeneratorTypes.CHARACTER_WITH_EQUIP, GeneratorTypes.KATAFRACT];
              _startButtonSequence(presetSequencePage);
            },
          ),
          CommonRoundButton(buttonText: "1", onPressedCallback: () {},),
          CommonRoundButton(buttonText: "1", onPressedCallback: () {},),
          CommonRoundButton(buttonText: "1", onPressedCallback: () {},),
        ],
      ),
    );
  }
}