import 'package:alyucado/model/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:alyucado/db/cando.dart';

class ProfileProvider with ChangeNotifier{
  final instance = CandoDatabase.instance;
  List<Profile> _profile = [];
  List<Profile> get items {
    return[..._profile];
  }

  Future<void> addNewProfile(Profile profile) async{
    await Profile(
        name: '',
        email: '',
        password: 0,
        picture: ''
    ).create(profile);
    _profile.insert(0, profile);
    print(profile);
    loadProfiles();
    notifyListeners();
  }

  Future<List> loadProfiles() async {
    _profile = await Profile(
        name: '',
        email: '',
        password: 0,
        picture: ''
    ).readAllProfiles();
    notifyListeners();
    // if(_profile.isEmpty){
    //   var p = Profile(
    //       name: 'Bramantio Galih Arintoko',
    //       email: 'Bmantio20@gmail.com',
    //       password: 112233,
    //       picture: 'assets/foto.jpg'
    //   );
    //   await addNewProfile(p);
    //   notifyListeners();
    // }
    return _profile;
  }

  Future<List> loadSelectedProfiles(int id) async{
    var data = await _profile.where((element) => element.id == id).toList();
    notifyListeners();
    return data;
  }

  Future<void> updateProfile(Profile profile) async {
    await Profile(
        name: '',
        email: '',
        password: 0,
        picture: ''
    ).update(profile);
    _profile[_profile.indexWhere((element) => element.id == profile.id)] = profile;
    loadProfiles();
    notifyListeners();
  }

  Future<void> deleteProfile(id) async {
    await Profile(
        name: '',
        email: '',
        password: 0,
        picture: ''
    ).delete(id);
    loadProfiles();
    notifyListeners();
  }
}