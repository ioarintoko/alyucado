import 'package:alyucado/db/cando.dart';
import 'package:flutter/cupertino.dart';

final String tableCaloriesDet = 'caloriesdet';

class CaloriesDetailFields with ChangeNotifier {
  static final List<String> values = [
    id,idKalori,food,calory,createdTime
  ];

  static final String id = '_id';
  static final String idKalori = 'idKalori';
  static final String food = 'food';
  static final String calory = 'calory';
  static final String createdTime = 'createdTime';
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}

class CaloriesDetail with ChangeNotifier{
  late int? id;
  late int idKalori;
  late String food;
  late int calory;
  late String createdTime;

  CaloriesDetail({
    this.id,
    required this.idKalori,
    required this.food,
    required this.calory,
    required this.createdTime,
  });

  static CaloriesDetail fromJson(Map<String, Object?> json) => CaloriesDetail(
    id: json[CaloriesDetailFields.id] as int?,
    idKalori: json[CaloriesDetailFields.idKalori] as int,
    food: json[CaloriesDetailFields.food] as String,
    calory: int.parse(json[CaloriesDetailFields.calory] as String),
    createdTime: json[CaloriesDetailFields.createdTime] as String,
  );

  Map<String, Object?> toJson() => {
    CaloriesDetailFields.id: id,
    CaloriesDetailFields.idKalori: idKalori,
    CaloriesDetailFields.food: food,
    CaloriesDetailFields.calory: calory,
    CaloriesDetailFields.createdTime: createdTime,
  };

  CaloriesDetail copy ({
    int? id,
    int? idKalori,
    String? food,
    int? calory,
    String? createdTime,
  }) =>
      CaloriesDetail(
        id: id ?? this.id,
        idKalori: idKalori ?? this.idKalori,
        food: food ?? this.food,
        calory: calory ?? this.calory,
        createdTime: createdTime ?? this.createdTime,
      );
  var instance = CandoDatabase.instance;
  Future<CaloriesDetail> create(CaloriesDetail caloriesdet) async {
    final db = await instance.database;

    final id = await db.insert(tableCaloriesDet, caloriesdet.toJson());

    print("saved");
    notifyListeners();
    return caloriesdet.copy(id:id, idKalori: caloriesdet.idKalori);
  }

  Future<CaloriesDetail> readCalories(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCaloriesDet,
      columns: CaloriesDetailFields.values,
      where: '${CaloriesDetailFields.id} = ?',
      whereArgs: [id],
    );
    notifyListeners();
    if(maps.isNotEmpty) {
      return CaloriesDetail.fromJson(maps.first);
    }else{
      throw Exception("ID $id not found");
    }
  }

  Future<List<CaloriesDetail>> readAllCalories(int idKalori) async {
    final db = await instance.database;

    final orderBy = '${CaloriesDetailFields.id} DESC';
    var _result = await db.query(tableCaloriesDet,
        where: '${CaloriesDetailFields.idKalori} = ?',
        whereArgs: [idKalori],
    );

    notifyListeners();
    return _result.map((json) => CaloriesDetail.fromJson(json)).toList();

  }

  Future<List<CaloriesDetail>> readAllCaloriesByIDKalori(int idKalori) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCaloriesDet,
      columns: CaloriesDetailFields.values,
      where: '${CaloriesDetailFields.idKalori} = ?',
      whereArgs: [idKalori],
    );
    List<CaloriesDetail> det = [];
    notifyListeners();
    if(maps.isNotEmpty) {
      print(maps);
      return maps.map((json) => CaloriesDetail.fromJson(json)).toList();
    }else{
      throw Exception("ID $id not found");
    }
  }

  Future<int> update(CaloriesDetail caloriesdet) async {
    final db = await instance.database;

    return db.update(
      tableCaloriesDet, caloriesdet.toJson(),
      where: '${CaloriesDetailFields.id} = ?',
      whereArgs: [caloriesdet.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCaloriesDet,
      where: '${CaloriesDetailFields.id} = ?',
      whereArgs: [id],
    );
  }
}