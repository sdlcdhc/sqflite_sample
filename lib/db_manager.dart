import 'package:sqflite/sqflite.dart';

class User {
  int id;
  String name;
  String password;

  User(this.name, this.password, {this.id});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'password': password
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  static User fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return User(map['name'], map['password'], id: map['id']);
  }

  @override
  String toString() {
    return 'User: {id: $id, name: $name, password: $password}';
  }
}

class DBManager {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        'create table User ('
        'id integer primary key autoincrement, '
        'name text not null,'
        'password text not null)'
      );
    });
  }

  Future<User> insert(User user) async {
    user.id = await db.transaction((transaction) {
      return transaction.insert('User', user.toMap());
    });
    
    return user;
  }

  Future<User> getUser(int id) async {
    List<Map> maps = await db.transaction((transaction) {
      return transaction.query('User', where: 'id = ?', whereArgs: [id]);
    });

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }

    return null;
  }

  Future<List<User>> getAllUsers() async {
    List<Map<String, dynamic>> recordList = await db.transaction((transaction) {
      return transaction.query('User');
    });

    if (recordList.length > 0) {
      return recordList.map((record) => User.fromMap(record)).toList();
    }

    return null;
  }

  Future<int> delete(int id) async {
    int flag = await db.transaction((transaction) {
      transaction.delete('User', where: 'id = ?', whereArgs: [id]);
    });

    return flag;
  }

  Future<int> update(User user) async {
    int flag = await db.transaction((transaction) {
      return transaction.update('User', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
    });

    return flag;
  }

  Future close() async => db.close();
}
