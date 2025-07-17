import 'package:cavalry_table/utils/common_constants.dart';

class SequenceManager {
  final Map<String, dynamic> sequenceMap;
  final GeneratorTypes sequenceType;
  int currentTableIndex = 0;
  int currentSubtableIndex = 1;

  SequenceManager({
    required this.sequenceMap,
    required this.sequenceType,
  });

  String? get _sequenceKey {
    switch (sequenceType) {
      case GeneratorTypes.CHARACTER_WITH_EQUIP:
        return "tables_character_all";
      case GeneratorTypes.DEFAULT:
        return "tables_character_all";
      case GeneratorTypes.ONLY_CHARACTER:
        return "tables_only_character";
      case GeneratorTypes.KATAFRACT:
        return "tables_only_katafract";
    }
  }

  List<String>? get _sequenceList {
    final key = _sequenceKey;
    if (key == null || !sequenceMap.containsKey(key)) return null;
    final rawList = sequenceMap[key];
    return (rawList is List) ? rawList.cast<String>() : null;
  }

  String? get currentTableKey {
    final list = _sequenceList;
    if (list == null || currentTableIndex >= list.length) return null;
    return list[currentTableIndex];
  }

  int get currentSubIndex => currentSubtableIndex;

  void advanceSubtable() {
    currentSubtableIndex++;
  }

  void resetSubtable() {
    currentSubtableIndex = 1;
  }

  bool moveNextTable() {
    final list = _sequenceList;
    if (list == null || currentTableIndex + 1 >= list.length) return false;
    currentTableIndex++;
    resetSubtable();
    return true;
  }

  bool get isFinished {
    final list = _sequenceList;
    return list == null || currentTableIndex >= list.length;
  }
}