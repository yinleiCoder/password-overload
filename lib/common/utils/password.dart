import 'dart:math';

/// 生成一个强随机密码
/// [length] 密码长度（默认16，建议至少12）
/// [withUpper] 是否包含大写字母
/// [withLower] 是否包含小写字母
/// [withNumbers] 是否包含数字
/// [withSymbols] 是否包含特殊符号
String generateStrongPassword({
  int length = 16,
  bool withUpper = true,
  bool withLower = true,
  bool withNumbers = true,
  bool withSymbols = true,
}) {
  final random = Random.secure();
  final buffer = StringBuffer();
  final allChars = StringBuffer();

  // 定义字符集
  const lowerChars = 'abcdefghijklmnopqrstuvwxyz';
  const upperChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numberChars = '0123456789';
  const symbolChars = '!@#\$%^&*()-_=+[]{}|;:,.<>?';

  // 根据参数构建可用字符集
  if (withLower) allChars.write(lowerChars);
  if (withUpper) allChars.write(upperChars);
  if (withNumbers) allChars.write(numberChars);
  if (withSymbols) allChars.write(symbolChars);

  final allCharsString = allChars.toString();

  // 确保每种启用字符集至少出现一次
  final mustHaveChars = [
    if (withLower) _getRandomChar(lowerChars, random),
    if (withUpper) _getRandomChar(upperChars, random),
    if (withNumbers) _getRandomChar(numberChars, random),
    if (withSymbols) _getRandomChar(symbolChars, random),
  ]..shuffle(random);

  mustHaveChars.forEach(buffer.write);

  // 填充剩余字符
  for (var i = mustHaveChars.length; i < length; i++) {
    buffer.write(_getRandomChar(allCharsString, random));
  }

  // 将密码字符随机排序
  final chars = buffer.toString().split('')..shuffle(random);
  return chars.join();
}

/// 从字符集中随机选择一个字符
String _getRandomChar(String charSet, Random random) {
  return charSet[random.nextInt(charSet.length)];
}

// void main() {
//   print('标准密码: ${generateStrongPassword()}');
//   print('短密码: ${generateStrongPassword(length: 12)}');
//   print('无符号密码: ${generateStrongPassword(withSymbols: false)}');
//   print('纯数字密码: ${generateStrongPassword(
//     withUpper: false,
//     withLower: false,
//     withSymbols: false,
//   )}');
// }