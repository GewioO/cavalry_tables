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
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
    );

    void startButtonSequence(Widget pageWithType) {
      startTransitionButtonSequence(context, pageWithType, widget.navigatorObj);
    }

    return Center(
      child: Row(
        children: <Widget>[
          CommonRoundButton(
            buttonText: "CHARACTER_WITH_EQUIP",
            onPressedCallback: () {
              presetSequencePage = PresetSequencePage(
                navigatorObj: widget.navigatorObj,
                tableType: GeneratorTypes.CHARACTER_WITH_EQUIP,
              );
              startButtonSequence(presetSequencePage);
            },
          ),
          CommonRoundButton(
            buttonText: "ONLY_CHARACTER",
            onPressedCallback: () {
              presetSequencePage = PresetSequencePage(
                navigatorObj: widget.navigatorObj,
                tableType: GeneratorTypes.ONLY_CHARACTER,
              );
              startButtonSequence(presetSequencePage);
            },
          ),
          CommonRoundButton(
            buttonText: "KATAFRACT",
            onPressedCallback: () {
              presetSequencePage = PresetSequencePage(
                navigatorObj: widget.navigatorObj,
                tableType: GeneratorTypes.KATAFRACT,
              );
              startButtonSequence(presetSequencePage);
            },
          ),
        ],
      ),
    );
  }
}
