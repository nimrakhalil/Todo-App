import 'package:hive/hive.dart';

class Database {
  List tasks = [];

  final box = Hive.box('mybox');

  void load() {
    tasks = box.get('list');
    // _date = box.get("date");
  }

  void save() {
    box.put('list', tasks);

    // box.put("date", _date);
  }
}
