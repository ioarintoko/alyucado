import 'package:alyucado/db/cando.dart';
import 'package:flutter/cupertino.dart';

final String tableJournal = 'journal';

class JournalFields with ChangeNotifier {
  static final List<String> values = [
    id,color,title,description,createdTime
  ];

  static final String id = '_id';
  static final String color = 'color';
  static final String title = 'title';
  static final String description = 'description';
  static final String createdTime = 'createdTime';
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}

class Journal with ChangeNotifier{
  late int? id;
  late String color;
  late String title;
  late String description;
  late DateTime createdTime;

  Journal({
    this.id,
    required this.color,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  static Journal fromJson(Map<String, Object?> json) => Journal(
    id: json[JournalFields.id] as int?,
    color: json[JournalFields.color] as String,
    title: json[JournalFields.title] as String,
    description: json[JournalFields.description] as String,
    createdTime: DateTime.parse(json[JournalFields.createdTime] as String),
  );

  Map<String, Object?> toJson() => {
    JournalFields.id: id,
    JournalFields.color: color,
    JournalFields.title: title,
    JournalFields.description: description,
    JournalFields.createdTime: createdTime.toIso8601String(),
  };

  Journal copy ({
    int? id,
    String? color,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Journal(
          id: id ?? this.id,
          color: color ?? this.color,
          title: title ?? this.title,
          description: description ?? this.description,
          createdTime: createdTime ?? this.createdTime,
      );
  var instance = CandoDatabase.instance;

  Future<Journal> create(Journal journal) async {
    final db = await instance.database;

    final id = await db.insert(tableJournal, journal.toJson());

    print("saved");
    notifyListeners();
    return journal.copy(id:id);
  }

  Future<Journal> readJournal(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableJournal,
      columns: JournalFields.values,
      where: '${JournalFields.id} = ?',
      whereArgs: [id],
    );
    notifyListeners();
    if(maps.isNotEmpty) {
      return Journal.fromJson(maps.first);
    }else{
      throw Exception("ID $id not found");
    }
  }

  Future<List<Journal>> readAllJournals() async {
    final db = await instance.database;

    final orderBy = '${JournalFields.createdTime} DESC';
    var _result = await db.query(tableJournal, orderBy: orderBy);

    notifyListeners();
    return _result.map((json) => Journal.fromJson(json)).toList();

  }

  Future<int> update(Journal journal) async {
    final db = await instance.database;

    return db.update(
      tableJournal, journal.toJson(),
      where: '${JournalFields.id} = ?',
      whereArgs: [journal.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableJournal,
      where: '${JournalFields.id} = ?',
      whereArgs: [id],
    );
  }
}