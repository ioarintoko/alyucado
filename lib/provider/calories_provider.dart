import 'package:alyucado/model/calories.dart';
import 'package:flutter/cupertino.dart';
import 'package:alyucado/db/cando.dart';
import 'package:intl/intl.dart';

class CaloriesProvider with ChangeNotifier{
  final instance = CandoDatabase.instance;
  List _calories = [];
  List<Calories> get items {
    return[..._calories];
  }

  Future<void> addNewCalories(Calories calories) async{
    await Calories(calory: calories.calory, createdTime: calories.createdTime).create(calories);
    loadCalories();
    _calories.insert(0, calories);
    notifyListeners();
  }

  Future<List> loadCalories() async {
    _calories = await Calories(calory: 0, createdTime: '').readAllCalories();
    var dt = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(dt);
    var calnow = new Calories(calory: 0, createdTime: formatted);
    var t = _calories.where((tc) => tc.createdTime == formatted).length;

    if(t == 0){
      var tocal = await Future.delayed(Duration(seconds: 1), (){
        var data = _calories.where((tc) => tc.createdTime == formatted).length;
        return data;
      });

      if (tocal == 0) {
        print(tocal);
        await addNewCalories(calnow);
        tocal++;
        print(tocal);
      }
    }

    notifyListeners();
    return _calories;
  }

  Future<List<Calories>> loadSelectedCalories(int id) async {
    final List<Calories> data = (await Calories(calory: 0, createdTime: '').readCalories(id)) as List<Calories>;
    // print(_calories.where((element) => element.id == id));
    notifyListeners();
    return data;

  }

  Future<void> updateCalories(Calories calories) async {
    await Calories(calory: 0, createdTime: '').update(calories);
    loadCalories();
    notifyListeners();
  }

  Future<void> deleteCalories(id) async {
    final data = await Calories(calory: 0, createdTime: '').delete(id);
    loadCalories();
    notifyListeners();
  }

  Future<void> deleteAllCalories() async {
    final data = await Calories(calory: 0, createdTime: '').deleteAll();
    loadCalories();
    notifyListeners();
  }
}