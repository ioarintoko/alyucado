import 'package:alyucado/model/agenda.dart';
import 'package:alyucado/page/agenda/agenda_add.dart';
import 'package:alyucado/page/agenda/agenda_edit.dart';
import 'package:alyucado/page/services/notification_service.dart';
import 'package:alyucado/provider/agenda_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
 var isActive;
 late String query;
 late bool _isSearchBarShow = false;
 late final ValueChanged<String> onChangedQuery;
 var date;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    setState(() {
      this.query= '';
      onChangedQuery = (query) => setState(() =>
      this.query = query);
      this.date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day
      );
      print('${this.date} initstate');
    });
  }

  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    tProv.getTheme();
    var formatter = new DateFormat('dd-MM-yyyy, hh:mm');
    return Scaffold(
      backgroundColor: tProv.mode.scaffoldBackgroundColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: tProv.mode.primaryColor,
        title: _isSearchBarShow == false ?
        Text('Agenda',
          style: TextStyle(
              color: tProv.mode.colorScheme.secondary
          ),
        ):
        TextFormField(
          initialValue: this.query,
          cursorColor: Colors.amber.withOpacity(0.7),
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white)
          ),
          onChanged: onChangedQuery,
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              setState(() {
                _isSearchBarShow = !_isSearchBarShow;
                print('$_isSearchBarShow searchbarshow');
              });
            },
            child: _isSearchBarShow ?
            CloseButton(onPressed: () {
              _isSearchBarShow = false;
              this.query = '';
            },) :
            Icon(Icons.search),
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent
            ),
          )
        ], systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AgendaAdd(),
          ));
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width,
                      24
                  )
              ),
              color: tProv.mode.primaryColor,
            ),
            child: AnimatedHorizontalCalendar(
              duration: 0,
              tableCalenderIcon: Icon(
                Icons.calendar_today,
                color: Colors.white,
                shadows: [
                  Shadow(color: tProv.mode.primaryColor, offset: Offset.infinite),
                  Shadow(color: tProv.mode.primaryColor, offset: Offset.infinite)
                ],
              ),
              date: this.date,
              textColor: Colors.black45,
              backgroundColor: Colors.white,
              selectedColor: Colors.green,
              tableCalenderButtonColor: Colors.green,
              onDateSelected: (date){
                setState((){
                  this.date = DateTime.parse(date);
                  print('${this.date} calendar');
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: Provider.of<AgendaProvider>(context).loadAgendasByDate(this.date),
                builder: (context, agenda){
                  var agd;
                  if(agenda.hasData){
                    agd = agenda.data as List<Agenda>;
                  }
                return agenda.hasData ?
                  Container(
                    child:
                    (agenda.data as List<Agenda>).isEmpty ?
                    Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No Agenda",
                              style: tProv.mode.textTheme.bodyText2,
                            ),
                          ],
                        ),
                    ) :
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: agd.length,
                              itemBuilder: (context, index) {
                                return agd[index].description.toLowerCase().contains(this.query) ||
                                    agd[index].dueDate.toString().toLowerCase().contains(this.query) ?
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AgendaEdit(id: agd[index].id),
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              tProv.mode.colorScheme.secondary,
                                              tProv.mode.primaryColor
                                              ]
                                        ),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24),
                                        bottom: Radius.elliptical(
                                            MediaQuery.of(context).size.width,
                                            24
                                        )
                                      )
                                    ),
                                    margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
                                    padding: EdgeInsets.all(5),
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.5,
                                                child: Text(agd[index].description.length > 20 ?
                                                agd[index].description.substring(0,10) :
                                                agd[index].description,
                                                  style: tProv.mode.textTheme.bodyText1,
                                                ),
                                              ),
                                              Text(formatter.format(agd[index].dueDate),
                                              style: tProv.mode.textTheme.bodyText2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch(
                                            value: agd[index].isActive == 1 ? true : false,
                                            onChanged: (value) => editActive(
                                                value,
                                                agd[index].id,
                                                agd[index].description,
                                                agd[index].dueDate
                                            ),
                                        ),
                                        Text(agd[index].isActive == 1 ? 'On' : 'Off',
                                        style: tProv.mode.textTheme.bodyText1,
                                        )
                                      ],
                                    ),
                                  ),
                                ) : Container();
                              }
                          ),
                        ),
                      ],
                    ),
                  ) :
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No Agenda",
                        style: tProv.mode.textTheme.bodyText2,
                      ),
                    ],
                  ),
                );
                }
              ),
          ),
        ],
      ),
    );
  }

  Future editActive(bool value, int id, String title, DateTime date) async{
    var format = new DateFormat('dd-MM-yyyy, hh:mm');
    setState(() {
      if(value == true){
        this.isActive = 1;
        NotificationService().showNotification(
            id,
            title,
            format.format(date),
            date
        );
      } else {
        this.isActive = 0;
        NotificationService().cancelNotifications(id);
      }
    });
    var aProv = Provider.of<AgendaProvider>(context, listen: false);
    var agendas = aProv.items.where((agd) => agd.id == id).toList();
    await aProv.updateAgenda(
      Agenda(
          id: id,
          description: agendas[0].description,
          dueDate: agendas[0].dueDate,
          isActive: this.isActive
      )
    );
  }
}
