import 'dart:math';

int rollOneDice(int value) {
  final random = Random();
  return random.nextInt(value) + 1;
}

int rollTwoDeces(int firstDice, int secondDice) {
  final random = Random();
  return (random.nextInt(firstDice) + 1) + (random.nextInt(secondDice) + 1);
}

List<int> rollTwoDecesSeparateValues(int firstDice, int secondDice) {
  final random = Random();
  return [(random.nextInt(firstDice) + 1), (random.nextInt(secondDice) + 1)];
}
