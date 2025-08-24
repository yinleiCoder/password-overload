import 'package:password_overload/common/values/values.dart';

/// SQL Table
class PasswordItem {
  int? id;
  late String source;
  late String account;
  late String password;
  String? note;

  PasswordItem({this.id, required this.source, required this.account, required this.password, this.note});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      DBTable.columnSource: source,
      DBTable.columnAccount: account,
      DBTable.columnPassword: password,
    };
    if (id != null) {
      map[DBTable.columnId] = id;
    }
    if(note != null) {
      map[DBTable.columnNote] = note;
    }
    return map;
  }

  PasswordItem.fromMap(Map<String, Object?> map) {
    id = map[DBTable.columnId] as int?;
    source = map[DBTable.columnSource] as String;
    account = map[DBTable.columnAccount] as String;
    password = map[DBTable.columnPassword] as String;
    note = map[DBTable.columnNote] as String?;
  }
}