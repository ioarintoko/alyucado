import 'package:alyucado/model/agenda.dart';
import 'package:flutter/cupertino.dart';
import 'package:alyucado/db/cando.dart';

class AgendaProvider with ChangeNotifier{
  final instance = CandoDatabase.instance;
  List _agenda = [];
  List<Agenda> get items {
    return[..._agenda];
  }

  Future<void> addNewAgenda(Agenda agenda) async{
    await Agenda(
        description: '',
        dueDate: DateTime.now(),
        isActive: 0
    ).create(agenda);
    loadAgendas();
    _agenda.insert(0, agenda);
    notifyListeners();
  }

  Future<List> loadAgendas() async {
    _agenda = await Agenda(
        description: '',
        dueDate: DateTime.now(),
        isActive: 0
    ).readAllProfiles();
    notifyListeners();
    return _agenda;
  }

  Future<List> loadSelectedAgendas(int id) async{
    var data = await _agenda.where((element) => element.id == id).toList();
    notifyListeners();
    return data;
  }

  Future<List<Agenda>> loadTodayAgendas() async{
    loadAgendas();
    updateActive();
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    DateTime tomorrow = today.add(Duration(days: 1));
    var data = await _agenda.where((element) =>
    element.dueDate.isAfter(today) && element.dueDate.isBefore(tomorrow)
    ).toList() as List<Agenda>;
    notifyListeners();
    return data;
  }

  Future<List<Agenda>> loadAgendasByDate(DateTime date) async{
    var data = await Agenda(
        description: '',
        dueDate: DateTime.now(),
        isActive: 0
    ).readAgendaByDate(date);
    // print(data.length);
    notifyListeners();
    return data;
  }

  Future<void> updateAgenda(Agenda agenda) async {
    await Agenda(
        description: '',
        dueDate: DateTime.now(),
        isActive: 0
    ).update(agenda);
    _agenda[_agenda.indexWhere((element) => element.id == agenda.id)] = agenda;
    loadAgendas();
    notifyListeners();
  }

  Future<void> updateActive() async {
    await Agenda(
        description: '',
        dueDate: DateTime.now(),
        isActive: 0
    ).updateActive();
    loadAgendas();
    notifyListeners();
  }

  Future<void> deleteAgenda(id) async {
    await Agenda(
        description: '',
        dueDate: DateTime.now(),
        isActive: 0
    ).delete(id);
    loadAgendas();
    notifyListeners();
  }
}