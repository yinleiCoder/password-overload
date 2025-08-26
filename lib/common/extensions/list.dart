import 'dart:math';

extension RandomElement<T> on List<T> {
  T getRandomElement() {
    final random = Random();
    return this[random.nextInt(length)];
  }
}