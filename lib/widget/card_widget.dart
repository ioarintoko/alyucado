import 'package:alyucado/model/agenda.dart';
import 'package:alyucado/model/calories.dart';
import 'package:alyucado/model/finance.dart';
import 'package:alyucado/model/journal.dart';
import 'package:alyucado/provider/agenda_provider.dart';
import 'package:alyucado/provider/calories_provider.dart';
import 'package:alyucado/provider/finance_provider.dart';
import 'package:alyucado/provider/journal_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context).size;
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    tProv.getTheme();
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        height: deviceData.height * 0.32,
        width: deviceData.width * 0.9,
        child: Card(
          color: tProv.mode.cardColor,
          // borderOnForeground: true,
          // color: Colors.white12,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
                bottom: Radius.elliptical(
                MediaQuery.of(context).size.width,
                48
            )
            ),
          ),
          child:
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(2),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyBalance(tProv: tProv, currencyFormatter: currencyFormatter),
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AgendaIcon(tProv: tProv),
                      JournalsIcon(tProv: tProv),
                      CaloriesIcon(tProv: tProv),
                    ],
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}

class CaloriesIcon extends StatelessWidget {
  const CaloriesIcon({
    Key? key,
    required this.tProv,
  }) : super(key: key);

  final ThemeProvider tProv;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: deviceData/1.1/3,
        child:
          Column(
            children: [
              Icon(Icons.calculate_outlined,
                color: tProv.mode.iconTheme.color,
                size: 40,),
              Text("Calories",
                style: tProv.mode.textTheme.bodyText1!.copyWith(
                  fontSize: 10
                )
              ),
              FutureBuilder(
                future: Provider.of<CaloriesProvider>(context, listen: false).loadCalories(),
                builder: (context, calories) {
                  if(calories.connectionState == ConnectionState.done){
                    if(calories.hasData){
                      var cal = calories.data as List<Calories>;
                      return Text(cal[0].calory.toString(),
                        style: tProv.mode.textTheme.bodyText1!.copyWith(
                          // color:Colors.green.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),);
                    }else{
                      return Text('0',
                        style: tProv.mode.textTheme.bodyText1!.copyWith(
                          // color:Colors.green.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),);
                    }
                  }else{
                    return CircularProgressIndicator();
                  }
                }
              ),
            ],
          )
    );
  }

}

class JournalsIcon extends StatelessWidget {
  const JournalsIcon({
    Key? key,
    required this.tProv,
  }) : super(key: key);

  final ThemeProvider tProv;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // width: deviceData/1.1/3,
        child:
        Column(
          children: [
            Icon(
              Icons.book_outlined,
              color: tProv.mode.iconTheme.color,
              size: 40,),
            Text("Journals",
              style: tProv.mode.textTheme.bodyText1!.copyWith(
                  fontSize: 10),),
            FutureBuilder(
              future: Provider.of<JournalProvider>(context, listen: false).loadJournals(),
              builder: (context, journal) {
                if(journal.connectionState == ConnectionState.done){
                  if(journal.hasData){
                    var jou = journal.data as List<Journal>;
                    return Text(jou.length.toString(),
                      style: tProv.mode.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),);
                  }else{
                    return Text('0',
                      style: tProv.mode.textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),);
                  }
                }else{
                  return CircularProgressIndicator();
                }
              }
            ),
          ],
        )
    );
  }
}

class AgendaIcon extends StatelessWidget {
  const AgendaIcon({
    Key? key,
    required this.tProv,
  }) : super(key: key);

  final ThemeProvider tProv;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: deviceData/1.1/3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt_outlined,
            color: tProv.mode.iconTheme.color,
            size: 40,),
          Text("Agenda",
            style: tProv.mode.textTheme.bodyText1!.copyWith(
                fontSize: 10),),
          FutureBuilder(
            future: Provider.of<AgendaProvider>(context, listen: false).loadTodayAgendas(),
            builder: (context, agenda) {
              if(agenda.connectionState == ConnectionState.done){
                if(agenda.hasData){
                  var agd = (agenda.data as List<Agenda>).toList();
                  var agdl = agd.where((agd) => agd.isActive == 1).length;
                  return Text(agdl.toString(),
                    style: tProv.mode.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12),);
                }else{
                  return Text('0',
                    style: tProv.mode.textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12),);
                }
              }else{
                return CircularProgressIndicator();
              }
            }
          ),
        ],
      ),
    );
  }
}

class MyBalance extends StatelessWidget {
  const MyBalance({
    Key? key,
    required this.tProv,
    required this.currencyFormatter,
  }) : super(key: key);

  final ThemeProvider tProv;
  final NumberFormat currencyFormatter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.credit_card_rounded,
          color: tProv.mode.iconTheme.color,
          size: 50,
        ),
        SizedBox(width: 10,),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("My Balance",
              style: tProv.mode.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w500),),
            FutureBuilder(
              future: Provider.of<FinanceProvider>(context, listen: false).loadFinances(),
              builder: (context, finance){
                if(finance.connectionState == ConnectionState.done){
                  if(finance.hasData){
                    var fin = (finance.data as List<Finance>);
                    if (fin.isNotEmpty){
                      return Text(currencyFormatter.format(fin.last.lastBalance),
                        style: tProv.mode.textTheme.headline1,);
                    }else{
                      return Text(currencyFormatter.format(0),
                        style: tProv.mode.textTheme.headline1,);
                    }
                  }else{
                    return Text(currencyFormatter.format(0),
                          style: tProv.mode.textTheme.headline1,);
                  }
                }else{
                  return CircularProgressIndicator();
                }
              }
            ),
          ],
        ),
      ],
    );
  }
}