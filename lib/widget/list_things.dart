import 'package:alyucado/model/agenda.dart';
import 'package:alyucado/provider/agenda_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListThings extends StatefulWidget {
  const ListThings({
    Key? key,
  }) : super(key: key);

  @override
  State<ListThings> createState() => _ListThingsState();
}

class _ListThingsState extends State<ListThings> {
  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy, HH:mm');
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    tProv.getTheme();
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Container(
        margin: EdgeInsets.only(left: 12),
        width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
              color: tProv.mode.primaryColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 16, top: 5),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text('Today\'s Agenda',
                    style: tProv.mode.textTheme.bodyText1!.copyWith(
                      color: Colors.grey.shade100
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  border: Border.all(
                      color: Colors.grey
                  ),
                  color: tProv.mode.scaffoldBackgroundColor,
                ),
                child: FutureBuilder(
                  future: Provider.of<AgendaProvider>(context, listen: false).loadTodayAgendas(),
                  builder: (context, agenda){
                    if(agenda.connectionState == ConnectionState.done){
                      DateTime today = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                      );
                      var tomorrow = today.add(Duration(days: 1));
                      print(
                          today.isBefore(today)
                      );
                      print(today);
                      print(today.add(Duration(days: 1)));
                      if(agenda.hasData && (agenda.data as List<Agenda>).isNotEmpty){
                        print(agenda.data);
                        var agd = (agenda.data as List<Agenda>);
                        return Container(
                          margin: EdgeInsets.only(left: 12, top: 20),
                          padding: EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: ListView.builder(
                              padding: EdgeInsets.all(0),
                              itemCount: agd.length > 1 ? agd.length : 1,
                              itemBuilder: (context, index){
                                return 
                                    // agd[index].dueDate.isBefore(tomorrow) && agd[index].dueDate.isAfter(today) == true && 
                                    agd[index].isActive == 1 ?
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     // Text((agd[index].dueDate.isBefore(tomorrow) && agd[index].dueDate.isAfter(today)).toString()),
                                     Text(
                                       '${index+1}.',
                                       style: tProv.mode.textTheme.bodyText1!.copyWith(
                                         fontSize: 32
                                       ),
                                       textAlign: TextAlign.left,
                                     ),
                                     SizedBox(width: 5,),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(
                                             agd[index].description.length > 20 ?
                                             agd[index].description.substring(0,20) :
                                             agd[index].description,
                                           style: tProv.mode.textTheme.bodyText1!.copyWith(
                                             fontSize: 16
                                           ),
                                           textAlign: TextAlign.left,
                                         ),
                                         Text(
                                             formatter.format(agd[index].dueDate),
                                           style: tProv.mode.textTheme.bodyText2,
                                           textAlign: TextAlign.left,
                                         ),
                                       ],
                                     ),
                                     SizedBox(height: 56,)
                                   ],
                                 ) : Container(
                                      margin: EdgeInsets.all(10),
                                      child: Center(
                                        child: Text(
                                          'Not Active Agenda',
                                          style: tProv.mode.textTheme.bodyText2,
                                        ),
                                      ),
                                    );
                              }
                          ),
                        );
                      }else{
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Text(
                                'No Agenda',
                                style: tProv.mode.textTheme.bodyText2,
                            ),
                          ),
                        );
                      }
                    }else{
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                ),
              ),
            ],
          ),
        ),
    );
    // );
  }
}