import 'dart:developer';

import 'package:alyucado/db/cando.dart';
import 'package:flutter/cupertino.dart';

final String tableFinance = 'finance';

class FinanceFields with ChangeNotifier {
  static final List<String> values = [
    id,description,debit,credit,lastBalance, createdTime
  ];

  static final String id = '_id';
  static final String description = 'description';
  static final String debit = 'debit';
  static final String credit = 'credit';
  static final String lastBalance = 'lastBalance';
  static final String createdTime = 'createdTime';

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}

class Finance with ChangeNotifier{
  late int? id;
  late String description;
  late int debit;
  late int credit;
  late int lastBalance;
  late DateTime createdTime;

  Finance({
    this.id,
    required this.description,
    required this.debit,
    required this.credit,
    required this.lastBalance,
    required this.createdTime,
  });

  static Finance fromJson(Map<String, Object?> json) => Finance(
    id: json[FinanceFields.id] as int?,
    description: json[FinanceFields.description] as String,
    debit: json[FinanceFields.debit] as int,
    credit: json[FinanceFields.credit] as int,
    lastBalance: json[FinanceFields.lastBalance] as int,
    createdTime: DateTime.parse(json[FinanceFields.createdTime] as String),
  );

  Map<String, Object?> toJson() => {
    FinanceFields.id: id,
    FinanceFields.description: description,
    FinanceFields.debit: debit,
    FinanceFields.credit: credit,
    FinanceFields.lastBalance: lastBalance,
    FinanceFields.createdTime: createdTime.toIso8601String(),
  };

  Finance copy ({
    int? id,
    String? description,
    int? debit,
    int? credit,
    int? lastBalance,
    DateTime? createdTime,
  }) =>
      Finance(
        id: id ?? this.id,
        description: description ?? this.description,
        debit: debit ?? this.debit,
        credit: credit ?? this.credit,
        lastBalance: lastBalance ?? this.lastBalance,
        createdTime: createdTime ?? this.createdTime,
      );
  var instance = CandoDatabase.instance;

  Future<Finance> create(Finance finance) async {
    final db = await instance.database;

    final id = await db.insert(tableFinance, finance.toJson());

    print("saved");
    notifyListeners();
    return finance.copy(id:id);
  }

  Future<Finance> readFinance(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableFinance,
      columns: FinanceFields.values,
      where: '${FinanceFields.id} = ?',
      whereArgs: [id],
    );
    notifyListeners();
    if(maps.isNotEmpty) {
      return Finance.fromJson(maps.first);
    }else{
      throw Exception("ID $id not found");
    }
  }

  // Future<Finance> readFinanceAfter(date) async {
  //   final db = await instance.database;
  //
  //   final maps = await db.query(
  //     tableFinance,
  //     columns: FinanceFields.values,
  //     where: '${FinanceFields.createdTime} > ?',
  //     whereArgs: [date],
  //   );
  //   notifyListeners();
  //   if(maps.isNotEmpty) {
  //     return Finance.fromJson(maps.first);
  //   }else{
  //     throw Exception("ID $date not found");
  //   }
  // }

  Future<List<Finance>> readAllFinances() async {
    final db = await instance.database;

    final orderBy = '${FinanceFields.createdTime} ASC';
    var _result = await db.query(tableFinance, orderBy: orderBy);

    notifyListeners();
    return _result.map((json) => Finance.fromJson(json)).toList();

  }

  Future<int> update(Finance finance) async {
    final db = await instance.database;
    log('${finance.createdTime.runtimeType}');
    return db.update(
      tableFinance, finance.toJson(),
      where: '${FinanceFields.id} = ?',
      whereArgs: [finance.id],
    );
  }

  Future<int> updateAfter(DateTime date, int lastBalanceNow) async {
    final db = await instance.database;
    Map<String, dynamic> lastBalance = {
      'lastBalance' : '${FinanceFields.lastBalance} + $lastBalanceNow',
    };

    return db.rawUpdate('''
      UPDATE $tableFinance SET lastBalance = lastBalance + ? 
      WHERE createdTime > ? 
    ''', [lastBalanceNow, date.toIso8601String()]);

    // return db.update(
    //   tableFinance, lastBalance,
    //   where: '${FinanceFields.createdTime} > ?',
    //   whereArgs: [date],
    // );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableFinance,
      where: '${FinanceFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;

    return await db.delete(
      tableFinance,
    );
  }
}