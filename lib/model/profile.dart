import 'package:alyucado/db/cando.dart';
import 'package:flutter/cupertino.dart';

final String tableProfile = 'profile';

class ProfileFields with ChangeNotifier {
  static final List<String> values = [
    id,name,email,password,picture
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String email = 'email';
  static final String password = 'password';
  static final String picture = 'picture';
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}

class Profile with ChangeNotifier{
  late int? id;
  late String name;
  late String email;
  late int password;
  late String picture;

  Profile({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.picture,
  });

  static Profile fromJson(Map<String, Object?> json) => Profile(
    id: json[ProfileFields.id] as int?,
    name: json[ProfileFields.name] as String,
    email: json[ProfileFields.email] as String,
    password: json[ProfileFields.password] as int,
    picture: json[ProfileFields.picture] as String,
  );

  Map<String, Object?> toJson() => {
    ProfileFields.id: id,
    ProfileFields.name: name,
    ProfileFields.email: email,
    ProfileFields.password: password,
    ProfileFields.picture: picture,
  };

  Profile copy ({
    int? id,
    String? name,
    String? email,
    int? password,
    String? picture,
  }) =>
      Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        picture: picture ?? this.picture,
      );
  var instance = CandoDatabase.instance;

  Future<Profile> create(Profile profile) async {
    final db = await instance.database;

    final id = await db.insert(tableProfile, profile.toJson());

    print("saved");
    notifyListeners();
    return profile.copy(id:id);
  }

  Future<Profile> readProfile(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableProfile,
      columns: ProfileFields.values,
      where: '${ProfileFields.id} = ?',
      whereArgs: [id],
    );
    notifyListeners();
    if(maps.isNotEmpty) {
      return Profile.fromJson(maps.first);
    }else{
      throw Exception("ID $id not found");
    }
  }

  Future<List<Profile>> readAllProfiles() async {
    final db = await instance.database;

    final orderBy = '${ProfileFields.id} ASC';
    var _result = await db.query(tableProfile, orderBy: orderBy);

    notifyListeners();
    return _result.map((json) => Profile.fromJson(json)).toList();

  }

  Future<int> update(Profile profile) async {
    final db = await instance.database;

    return db.update(
      tableProfile, profile.toJson(),
      where: '${ProfileFields.id} = ?',
      whereArgs: [profile.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableProfile,
      where: '${ProfileFields.id} = ?',
      whereArgs: [id],
    );
  }
}