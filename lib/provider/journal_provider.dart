import 'package:alyucado/model/journal.dart';
import 'package:flutter/cupertino.dart';
import 'package:alyucado/db/cando.dart';

class JournalProvider with ChangeNotifier{
 final instance = CandoDatabase.instance;
 List _journals = [];
 List<Journal> get items {
   return[..._journals];
 }

 Future<void> addNewJournal(Journal journal) async{
   await Journal(color: "", title: "", description: "", createdTime: DateTime.now()).create(journal);
   loadJournals();
   _journals.insert(0, journal);
   notifyListeners();
 }

  Future<List> loadJournals() async {
    _journals = await Journal(color: "", title: "", description: "", createdTime: DateTime.now()).readAllJournals();
   notifyListeners();
   return _journals;
  }

  Future<List> loadSelectedJournals(int id) async{
   var data = await _journals.where((element) => element.id == id).toList();
   notifyListeners();
   return data;
 }

 Future<void> updateJournal(Journal journal) async {
   await Journal(id: journal.id, color: "", title: "", description: "", createdTime: DateTime.now()).update(journal);
   _journals[_journals.indexWhere((element) => element.id == journal.id)] = journal;
   print(_journals[_journals.indexWhere((element) => element.id == journal.id)].title);
   print("updated ${journal.id}, ${journal.color}");
   notifyListeners();
 }

 Future<void> deleteJournal(id) async {
   await Journal(color: "", title: "", description: "", createdTime: DateTime.now()).delete(id);
   loadJournals();
   notifyListeners();
 }
}