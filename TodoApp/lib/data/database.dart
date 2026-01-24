import 'package:hive/hive.dart';

class Database {
  List todolist = [];
  final _myBox = Hive.box('mybox');

  void createInitialData() {
    todolist = [];
  }

  void loadData() {
    todolist = _myBox.get('todolist');
  }

  void updateData() {
    _myBox.put('todolist', todolist);
  }

}