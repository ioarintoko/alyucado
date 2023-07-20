import 'package:alyucado/model/calories_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:alyucado/db/cando.dart';

class CaloriesDetailProvider with ChangeNotifier{
  final instance = CandoDatabase.instance;
  List _caloriesdet = [];
  List<CaloriesDetail> get items {
    return[..._caloriesdet];
  }

  Future<void> addNewCalories(CaloriesDetail caloriesdet) async{
    await CaloriesDetail(idKalori: caloriesdet.idKalori, calory: caloriesdet.calory, createdTime: caloriesdet.createdTime, food: caloriesdet.food).create(caloriesdet);
    loadCalories(caloriesdet.idKalori);
    _caloriesdet.insert(0, caloriesdet);
    notifyListeners();
  }

  Future<List> loadCalories(int idKalori) async {
    _caloriesdet = await CaloriesDetail(idKalori:0, calory: 0, createdTime: '', food: '').readAllCalories(idKalori);
    notifyListeners();
    return _caloriesdet;
  }

  Future<List<CaloriesDetail>> loadCaloriesByIDKalori(int idKalori) async{
    final data =
        await CaloriesDetail(idKalori: 0, calory: 0, food: "", createdTime: '')
            .readAllCaloriesByIDKalori(idKalori);
    print(data.length);
    notifyListeners();
    return data;
  }

  Future<void> loadSelectedCalories(int id) async {
    final List<CaloriesDetail> data = (await CaloriesDetail(idKalori: 0, calory: 0, food: "", createdTime: '').readCalories(id)) as List<CaloriesDetail>;
    // print(_caloriesdet.where((element) => element.id == id));
    notifyListeners();
  }

  Future<void> updateCalories(CaloriesDetail caloriesdet) async {
    //_journals[journal.id - 1] = journal;
    await CaloriesDetail(idKalori:0, calory: 0, food: "", createdTime: '').update(caloriesdet);
    loadCalories(caloriesdet.idKalori);
    notifyListeners();
  }

  Future<void> deleteCalories(id) async {
    final data = await CaloriesDetail(idKalori:0, calory: 0, food: "", createdTime: '').delete(id);
    // loadCalories();
    notifyListeners();
  }
}