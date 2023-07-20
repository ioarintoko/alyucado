import 'package:alyucado/db/cando.dart';
import 'package:flutter/cupertino.dart';

final String tableAgenda = 'agenda';

class AgendaFields with ChangeNotifier {
  static final List<String> values = [
    id,description,dueDate,isActive
  ];

  static final String id = '_id';
  static final String description = 'description';
  static final String dueDate = 'dueDate';
  static final String isActive = 'isActive';
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}

class Agenda with ChangeNotifier{
  late int? id;
  late String description;
  late DateTime dueDate;
  late int isActive;

  Agenda({
    this.id,
    required this.description,
    required this.dueDate,
    required this.isActive,
  });

  static Agenda fromJson(Map<String, Object?> json) => Agenda(
    id: json[AgendaFields.id] as int?,
    description: json[AgendaFields.description] as String,
    dueDate: DateTime.parse(json[AgendaFields.dueDate] as String),
    isActive: json[AgendaFields.isActive] as int,
  );

  Map<String, Object?> toJson() => {
    AgendaFields.id: id,
    AgendaFields.description: description,
    AgendaFields.dueDate: dueDate.toIso8601String(),
    AgendaFields.isActive: isActive,
  };

  Agenda copy ({
    int? id,
    String? description,
    DateTime? dueDate,
    int? isActive,
  }) =>
      Agenda(
        id: id ?? this.id,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        isActive: isActive ?? this.isActive,
      );
  var instance = CandoDatabase.instance;

  Future<Agenda> create(Agenda agenda) async {
    final db = await instance.database;

    final id = await db.insert(tableAgenda, agenda.toJson());

    print("saved");
    notifyListeners();
    return agenda.copy(id:id);
  }

  Future<Agenda> readProfile(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableAgenda,
      columns: AgendaFields.values,
      where: '${AgendaFields.id} = ?',
      whereArgs: [id],
    );
    notifyListeners();
    if(maps.isNotEmpty) {
      return Agenda.fromJson(maps.first);
    }else{
      throw Exception("ID $id not found");
    }
  }

  Future<List<Agenda>> readAgendaByDate(DateTime date) async {
    final db = await instance.database;

    final maps = await db.rawQuery('''
      SELECT * FROM $tableAgenda WHERE dueDate BETWEEN ? AND ?
    ''',[date.toIso8601String(), date.add(Duration(days: 1)).toIso8601String()]);

    List<Agenda> agd = [];
    notifyListeners();
    if(maps.isNotEmpty) {

      return maps.map((json) => Agenda.fromJson(json)).toList();

    }else{
      throw Exception("ID $id not found");
    }
  }

  Future<List<Agenda>> readAllProfiles() async {
    final db = await instance.database;

    final orderBy = '${AgendaFields.id} ASC';
    var _result = await db.query(tableAgenda, orderBy: orderBy);

    notifyListeners();
    return _result.map((json) => Agenda.fromJson(json)).toList();

  }

  Future<int> update(Agenda agenda) async {
    final db = await instance.database;

    return db.update(
      tableAgenda, agenda.toJson(),
      where: '${AgendaFields.id} = ?',
      whereArgs: [agenda.id],
    );
  }

  Future<int> updateActive() async {
    DateTime date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day
    );
    final db = await instance.database;
    var isActive = 0;
    return db.rawUpdate('UPDATE $tableAgenda SET isActive = 0 WHERE dueDate < ?',
    [date.toIso8601String()]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableAgenda,
      where: '${AgendaFields.id} = ?',
      whereArgs: [id],
    );
  }
}