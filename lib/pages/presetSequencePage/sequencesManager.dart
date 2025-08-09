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

  List<String> getSavedGenerationMappingKey(String title) {
    switch(title){
      case "Особливість персонажа":
        return ["peculiarity"];
      case "Рідний світ персонажа":
        return ["home_world"];
      case "Передісторія персонажа":
        return ["prehistory"];
      case "Навички персонажа 1" || "Навички персонажа 2" || 
        "Навички персонажа 3" || "Навички персонажа 4":
        return ["skills"];
      case "Соматика (СОМ)":
        return ["somatic"];
      case "Моторика (МОТ)":
        return ["motor_skill"];
      case "Когніція (КОГ)":
        return ["cognition"];
      case "Емпатія (ЕМП)":
        return ["empathi"];
      case "Стійкість та удача":
        return ["stability", "lucky"];
      case "Зовнішність":
        return ["phisique"];
      case "Талісман":
        return ["talisman"];
      case "Причина сумісності":
        return ["compability"];
      case "Ім'я":
        return ["name"];
      case "Гроші":
        return ["money"];
      case "Лати":
        return ["armor"];
      case "Озброєння":
        return ["weapon"];
      case "Спорядження":
        return ["equipment"];
      case "Особливості катафрактів":
        return ["katafract_preculiarity"];
      case "Походження":
        return ["katafract_origin"];
      case "Бойовий камуфляж 1" || "Бойовий камуфляж 2":
        return ["katafract_camouflage"];
      case "Естетика 1" || "Естетика 2" || "Естетика 3":
        return ["katafract_esthetic"];
      case "Всередині утроби":
        return ["katafract_womb"];
      case "Відмітини":
        return ["katafract_marks"];
      case "Імена Скрижалі Дарованих Імен 1" || "Імена Скрижалі Дарованих Імен 2":
        return ["katafract_name"];
      case "Каркас":
        return ["katafract_carcass"];
      case "Реактор":
        return ["katafract_reactor"];
      case "Ядро":
        return ["katafract_core"];
      case "Сенсори":
        return ["katafract_sencors"];
      default:
        return [];
    }
  }
}