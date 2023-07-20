import 'package:alyucado/model/finance.dart';
import 'package:flutter/cupertino.dart';
import 'package:alyucado/db/cando.dart';

class FinanceProvider with ChangeNotifier{
  final instance = CandoDatabase.instance;
  List _finance = [];
  List<Finance> get items {
    return[..._finance];
  }

  Future<void> addNewFinance(Finance finance) async{
    await Finance(description: '', debit: 0, credit: 0, lastBalance: 0,
        createdTime: DateTime.now()).create(finance);
    loadFinances();
    _finance.insert(0, finance);
    notifyListeners();
  }

  Future<List> loadFinances() async {
    _finance = await Finance(description: '', debit: 0, credit: 0, lastBalance: 0,
        createdTime: DateTime.now()).readAllFinances();
    notifyListeners();
    return _finance;
  }

  Future<List> loadSelectedFinances(int id) async{
    var data = await _finance.where((element) => element.id == id).toList();
    notifyListeners();
    return data;
  }

  Future<void> updateFinance(Finance finance) async {
    await Finance(description: '', debit: 0, credit: 0, lastBalance: 0,
        createdTime: DateTime.now()).update(finance);
    notifyListeners();
  }

  Future<void> updateFinanceAfter(String date, int lastBalanceNow) async {
    await Finance(description: '', debit: 0, credit: 0, lastBalance: 0,
        createdTime: DateTime.now()).updateAfter(DateTime.parse(date), lastBalanceNow);
    notifyListeners();
  }

  Future<void> deleteFinance(id) async {
    await Finance(description: '', debit: 0, credit: 0, lastBalance: 0,
        createdTime: DateTime.now()).delete(id);
    loadFinances();
    notifyListeners();
  }

  Future<void> deleteAllFinance() async {
    await Finance(description: '', debit: 0, credit: 0, lastBalance: 0,
        createdTime: DateTime.now()).deleteAll();
    loadFinances();
    notifyListeners();
  }
}