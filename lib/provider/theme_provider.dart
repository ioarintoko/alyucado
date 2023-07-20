import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _mode = ThemeData();
  ThemeData get mode {
    return _mode;
  }
  static Color primaryGradient = Colors.white;
  static Color secondaryGradient = Colors.white;

  ThemeData _light = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
        style:  ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.7)),
        )
    ),
    scaffoldBackgroundColor: Color(0xffffffff),
    primaryColor: Color(0xff8b0000),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      // backgroundColor: Color(0xff800000),
      unselectedItemColor: Colors.white.withOpacity(0.9),
      selectedItemColor: Colors.white.withOpacity(0.9),
      unselectedLabelStyle: TextStyle(color: Colors.white.withOpacity(0.7),),
      selectedLabelStyle: TextStyle(color: Colors.white.withOpacity(0.7),),
    ),
    iconTheme: IconThemeData(
      color: Colors.black54
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
          color: Color(0xff008a5b),
          fontSize: 22,
          fontWeight: FontWeight.bold
      ),
      bodyText1: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20
      ),
      bodyText2: TextStyle(color: Colors.black54),
    ),
    cardColor: Color(0xfffafbfc),
    cardTheme: CardTheme(
      elevation: 20
    ), colorScheme: ColorScheme.light().copyWith(secondary: Colors.amberAccent)
  );

  ThemeData _dark = ThemeData(
    scaffoldBackgroundColor: Color(0xff0d1117),
    elevatedButtonTheme: ElevatedButtonThemeData(
     style:  ButtonStyle(
       backgroundColor: MaterialStateProperty.all(Colors.amber.withOpacity(0.7)),
     )
    ),
    primaryColor: Color(0xff000055),
    // Color(0xff300000),
    cardColor: Color(0xff161b22),
    cardTheme: CardTheme(
        elevation: 20
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedIconTheme: IconThemeData(
        color: Colors.white.withOpacity(0.7)
      ),
      selectedIconTheme: IconThemeData(
          color: Color(0xff89929b)
      ),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      selectedItemColor: Colors.amberAccent,
      unselectedItemColor: Colors.amberAccent,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold
      ),
      unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xff89929b),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
          color: Color(0xff7ce38b),
          fontSize: 22,
          fontWeight: FontWeight.bold
      ),
      bodyText1: TextStyle(
          color: Colors.white70,
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),
      bodyText2: TextStyle(color: Colors.white54),
    ), colorScheme: ColorScheme.dark().copyWith(secondary: Colors.amberAccent),
  );

  Future<void> setTheme() async{
    _mode = _light;
  }

  Future<void> getTheme() async{
    //print(_mode);
    if(_mode != _light && _mode != _dark){
      _mode = _light;
    }else if (_mode != _light) {
      _mode = _dark;
    }else{
      _mode = _light;
    }
    // _mode = _light;
    // notifyListeners();
    // return _mode[0];
  }

  Future<void> changeTheme() async{
    if(_mode == _light){
      //print('mode light');
      _mode = _dark;
      //print('change to dark');
      }else{
      //print('mode dark');
      _mode = _light;
      //print('change to light');
      }
    //print(_mode);
    notifyListeners();
    // return _mode[0];
  }
}