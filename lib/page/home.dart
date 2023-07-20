import 'package:alyucado/page/agenda/agenda_page.dart';
import 'package:alyucado/page/calories/calories_page.dart';
import 'package:alyucado/page/journal/journal_page.dart';
import 'package:alyucado/provider/profile_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:alyucado/widget/card_widget.dart';
import 'package:alyucado/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/profile.dart';
import '../widget/list_things.dart';
import '../widget/stack_journals.dart';
import 'finance/finance_page.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var nama;
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  List<bool> _selections = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      this._selections = [false];
      Provider.of<ThemeProvider>(context, listen: false).setTheme();
      this.nama = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);

    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    tProv.getTheme();

    return Scaffold(
      backgroundColor: tProv.mode.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: new Theme(
        data: tProv.mode.copyWith(
          canvasColor: tProv.mode.primaryColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.elliptical(
                MediaQuery.of(context).size.width,
                24
            )
          ),
          child: BottomNavigationBar(
            // backgroundColor: tProv.mode.cardColor,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Finance',
                    icon: Icon(Icons.credit_card_rounded)
                ),
                BottomNavigationBarItem(
                  label: 'Agenda',
                    icon: Icon(Icons.list_rounded)
                ),
                BottomNavigationBarItem(
                  label: 'Journals',
                    icon: Icon(Icons.book)
                ),
                BottomNavigationBarItem(
                  label: 'Calories',
                    icon: Icon(Icons.addchart_sharp)
                )
              ],
            onTap: navigateMenu,
            ),
        ),
      ),
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: tProv.mode.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(
                MediaQuery.of(context).size.width,
                24
            )
          )
        ),
        elevation: 0,
        title: Text("AYCD", style: TextStyle(color:Colors.white70, fontWeight: FontWeight.bold, fontSize: 20),),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: ToggleButtons(
                fillColor: Colors.transparent,
                borderColor: Colors.transparent,
                selectedBorderColor: Colors.transparent,
                selectedColor: Colors.amber.withOpacity(0.7),
                borderWidth: 3,
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: _selections[0] == true ?
                    Colors.amber.withOpacity(0.7)
                        : Colors.white,)
                ],
                isSelected: this._selections,
                onPressed: (int index) {
                  setState(() {
                    this._selections[0] = !this._selections[0];
                  });
                  tProv.changeTheme();
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              onPrimary: Colors.white,
              shadowColor: Colors.transparent
            ),
              onPressed: (){
                setState((){

                });
              },
              child: Icon(Icons.refresh, size: 30,))
        ], systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body:
      Container(
       child: SingleChildScrollView(
         child:
         Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Stack(
               clipBehavior: Clip.none,
               children: [
                 ClipRRect(
                   borderRadius: BorderRadius.vertical(
                     bottom: Radius.elliptical(
                       MediaQuery.of(context).size.width,
                       24.0
                     )
                   ),
                   child: Container(
                     height: MediaQuery.of(context).size.height * 0.4,
                     padding: EdgeInsets.only(top: 60),
                     color: tProv.mode.primaryColor,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                         FutureBuilder(
                           future: Provider.of<ProfileProvider>(context, listen: false).loadProfiles(),
                           builder: (context, profile) {
                             var nam;
                             if(profile.hasData) {
                               nam = (profile.data as List<Profile>)[0].name;
                             }
                             return profile.connectionState == ConnectionState.waiting ?
                             CircularProgressIndicator() : profile.hasData ?
                             Container(
                               margin: EdgeInsets.only(left: 16),
                               padding: EdgeInsets.only(left: 5),
                               child:
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("Halo,",
                                     style: TextStyle(fontWeight: FontWeight.bold,
                                       color: tProv.mode.colorScheme.secondary,
                                       fontSize: 20),
                                   ),
                                   Text("${nam.split(' ')[0]} !",
                                     style: TextStyle(fontWeight: FontWeight.bold,
                                       color: tProv.mode.colorScheme.secondary,
                                       fontSize: 30),
                                   ),
                                 ],
                               )
                             ): CircularProgressIndicator();
                           }
                         ),
                         Container(
                           color: Colors.transparent,
                           alignment: Alignment.centerLeft,
                           padding: EdgeInsets.all(15),
                           width: MediaQuery.of(context).size.width,
                         )
                       ],
                     ),
                   ),
                 ),
                 Positioned(
                   top: 160,
                   left: 20,
                   child: CardWidget(),
                 ),
               ],
             ),
             SizedBox(height: 124,),
             StackJournals(tProv: tProv, formatter: formatter),
             SizedBox(height: 56,),
             ListThings(),
             SizedBox(height: 30,)
             // // ListThings(),
           ]
         ),
       ),
     )
    );
    // TODO: implement build
    //throw UnimplementedError();
    // Positioned(
    //   top: 140,
    //   left: 280,
    //   child: FloatingActionButton(
    //     backgroundColor: tProv.mode.primaryColor,
    //     onPressed: (){
    //       setState(() {
    //         print('floathome');
    //       });
    //     },
    //     child: Icon(Icons.refresh, color: Colors.white,)
    //   ),
    // )
  }

  void navigateMenu(int value) {
    switch(value){
      case 0: {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FinancePage()),
        );
      }
      break;

      case 1: {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AgendaPage()),
        );
      }
      break;

      case 2: {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => JournalPage()),
        );
      }
      break;

      case 3: {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CaloriesPage()),
        );
      }
      break;

      default: {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
      break;
    }


  }
}
