
import 'package:alyucado/db/cando.dart';
import 'package:flutter/cupertino.dart';

final String tableCalories = 'calories';

class CaloriesFields with ChangeNotifier {
  static final List<String> values = [
    id,calory,createdTime
  ];

  static final String id = '_id';
  static final String calory = 'calory';
  static final String createdTime = 'createdTime';
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}

class Calories with ChangeNotifier{
  late int? id;
  late int calory;
  late String createdTime;

  Calories({
    this.id,
    required this.calory,
    required this.createdTime,
  });

  static Calories fromJson(Map<String, Object?> json) => Calories(
    id: json[CaloriesFields.id] as int?,
    calory: int.parse(json[CaloriesFields.calory] as String),
    createdTime: json[CaloriesFields.createdTime] as String,
  );

  Map<String, Object?> toJson() => {
    CaloriesFields.id: id,
    CaloriesFields.calory: calory,
    CaloriesFields.createdTime: createdTime,
  };

  Calories copy ({
    int? id,
    int? calory,
    String? createdTime,
  }) =>
      Calories(
        id: id ?? this.id,
        calory: calory ?? this.calory,
        createdTime: createdTime ?? this.createdTime,
      );
  var instance = CandoDatabase.instance;
  Future<Calories> create(Calories calories) async {
    final db = await instance.database;

    final id = await db.insert(tableCalories, calories.toJson());

    print("saved");
    notifyListeners();
    return calories.copy(id:id);
  }

  // Future<Calories> readCalories(int id) async {
  //   final db = await instance.database;
  //
  //   final maps = await db.query(
  //     tableCalories,
  //     columns: CaloriesFields.values,
  //     where: '${CaloriesFields.id} = ?',
  //     whereArgs: [id],
  //   );
  //   notifyListeners();
  //   if(maps.isNotEmpty) {
  //     return Calories.fromJson(maps.first);
  //   }else{
  //     throw Exception("ID $id not found");
  //   }
  // }

  Future<List<Calories>> readCalories(int idKalori) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCalories,
      columns: CaloriesFields.values,
      where: '${CaloriesFields.id} = ?',
      whereArgs: [idKalori],
    );
    List<Calories> det = [];
    notifyListeners();
    if(maps.isNotEmpty) {
      det.add(Calories.fromJson(maps.first));
      return det;
    }else{
      throw Exception("ID $id not found");
    }
  }

  Future<List<Calories>> readAllCalories() async {
    final db = await instance.database;

    final orderBy = '${CaloriesFields.id} DESC';
    var _result = await db.query(tableCalories, orderBy: orderBy);

    notifyListeners();
    return _result.map((json) => Calories.fromJson(json)).toList();

  }

  Future<int> update(Calories calories) async {
    final db = await instance.database;

    return db.update(
      tableCalories, calories.toJson(),
      where: '${CaloriesFields.id} = ?',
      whereArgs: [calories.id],
    );
  }

  Future<int> updateCalory(int id, int calory) async {
    final db = await instance.database;

    return db.rawUpdate("Update calories SET calory = calory+$calory WHERE id = $id"
      // tableCalories, calories.toJson(),
      // where: '${CaloriesFields.id} = ?',
      // whereArgs: [calories.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCalories,
      where: '${CaloriesFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;

    return await db.delete(
      tableCalories,
    );
  }
}