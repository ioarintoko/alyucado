import 'package:alyucado/model/agenda.dart';
import 'package:alyucado/model/calories.dart';
import 'package:alyucado/model/calories_detail.dart';
import 'package:alyucado/model/finance.dart';
import 'package:alyucado/model/journal.dart';
import 'package:alyucado/model/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CandoDatabase with ChangeNotifier{
  static final CandoDatabase instance = CandoDatabase._init();

  static Database? _database;

  CandoDatabase._init();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDB('cando.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE $tableJournal (
    ${JournalFields.id} $idType,
    ${JournalFields.color} $stringType,
    ${JournalFields.title} $stringType,
    ${JournalFields.description} $stringType,
    ${JournalFields.createdTime} $stringType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableCalories (
    ${CaloriesFields.id} $idType,
    ${CaloriesFields.calory} $stringType,
    ${CaloriesFields.createdTime} $stringType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableCaloriesDet (
    ${CaloriesDetailFields.id} $idType,
    ${CaloriesDetailFields.idKalori} 'INTEGER',
    ${CaloriesDetailFields.food} $stringType,
    ${CaloriesDetailFields.calory} $stringType,
    ${CaloriesDetailFields.createdTime} $stringType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableFinance (
    ${FinanceFields.id} $idType,
    ${FinanceFields.description} $stringType,
    ${FinanceFields.debit} 'INTEGER',
    ${FinanceFields.credit} 'INTEGER',
    ${FinanceFields.lastBalance} 'INTEGER',
    ${FinanceFields.createdTime} $stringType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableProfile (
    ${ProfileFields.id} $idType,
    ${ProfileFields.name} $stringType,
    ${ProfileFields.email} $stringType,
    ${ProfileFields.password} 'INTEGER',
    ${ProfileFields.picture} $stringType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableAgenda (
    ${AgendaFields.id} $idType,
    ${AgendaFields.description} $stringType,
    ${AgendaFields.dueDate} $stringType,
    ${AgendaFields.isActive} 'INTEGER'
    )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}