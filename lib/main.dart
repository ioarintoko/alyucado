import 'package:alyucado/page/home.dart';
import 'package:alyucado/page/services/notification_service.dart';
import 'package:alyucado/page/splash_screen.dart';
import 'package:alyucado/provider/agenda_provider.dart';
import 'package:alyucado/provider/calories_detail_provider.dart';
import 'package:alyucado/provider/calories_provider.dart';
import 'package:alyucado/provider/finance_provider.dart';
import 'package:alyucado/provider/journal_provider.dart';
import 'package:alyucado/provider/profile_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

  void main() {
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    runApp(ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    var tProv;
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      this.tProv = Provider.of<ThemeProvider>(context, listen: false);
      this.tProv.getTheme();
    });
  }
    // ThemeData _light = ThemeData(
    //   colorScheme: ColorScheme.light(),
    //   // scaffoldBackgroundColor: Colors.white70,
    //   primaryColor: Color(0xff800000),
    //   accentColor: Colors.amber,
    //   textTheme: TextTheme(
    //     headline1: TextStyle(color: Colors.green.withOpacity(0.9), fontSize: 22),
    //     bodyText1: TextStyle(color: Colors.black87),
    //     bodyText2: TextStyle(color: Colors.black54),
    //   ),
    // );
    //
    // ThemeData _dark = ThemeData(
    //   // scaffoldBackgroundColor: Colors.black54,
    //   colorScheme: ColorScheme.dark(),
    //   primaryColor: Color(0xff300000),
    //   accentColor: Colors.amber.withOpacity(0.7),
    //   textTheme: TextTheme(
    //     headline1: TextStyle(color: Colors.green.withOpacity(0.9), fontSize: 22),
    //     bodyText1: TextStyle(color: Colors.white12),
    //     bodyText2: TextStyle(color: Colors.white54),
    //   ),
    // );

    @override
    Widget build(BuildContext context) {
      // var tProv = Provider.of<ThemeProvider>(context);
      // tProv.getTheme();
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<JournalProvider>(create: (context) => JournalProvider(),),
          ChangeNotifierProvider<CaloriesProvider>(create: (context) => CaloriesProvider(),),
          ChangeNotifierProvider<CaloriesDetailProvider>(create: (context) => CaloriesDetailProvider(),),
          ChangeNotifierProvider<FinanceProvider>(create: (context) => FinanceProvider(),),
          ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider(),),
          ChangeNotifierProvider<ProfileProvider>(create: (context) => ProfileProvider(),),
          ChangeNotifierProvider<AgendaProvider>(create: (context) => AgendaProvider(),),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: this.tProv.mode,
          home: SplashScreen(),
          // Home(),
        ),
      );
    }
}

