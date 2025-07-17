import 'package:flutter/material.dart';
import 'package:cavalry_table/pages/pagesNavigator.dart';
import 'package:cavalry_table/tablesPaths.dart';
import 'package:cavalry_table/tablesHandler/tablesHandler.dart';

enum PageMode 
{
  CHARACTER,
  KATAFRACT
}

class CharacterListPage extends StatefulWidget {
  final PagesNavigator navigatorObj;
  final Map<String, dynamic> characterSavedList;

  const CharacterListPage({
    super.key,
    required this.navigatorObj,
    required this.characterSavedList
  });

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  PageMode _pageMode = PageMode.CHARACTER;

  void _setPageMode(PageMode mode) {
    setState(() {
      _pageMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => widget.navigatorObj.backPage(context)),
        title: const Text(""),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 200),
            Text(
              "name",
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            Text(
              "name",
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}