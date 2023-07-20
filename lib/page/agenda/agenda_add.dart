import 'package:alyucado/model/agenda.dart';
import 'package:alyucado/page/services/notification_service.dart';
import 'package:alyucado/provider/agenda_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AgendaAdd extends StatefulWidget {
  const AgendaAdd({Key? key}) : super(key: key);

  @override
  State<AgendaAdd> createState() => _AgendaAddState();
}

class _AgendaAddState extends State<AgendaAdd> {
 var description;
 late final ValueChanged<String> onChangedDescription;
 var isSwitch;
 var isActive;
 var selectedDate;
 var dateNow;
 var timeNow;
 DateTime dateTime = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();

    setState(() {
      this.isSwitch = false;
      this.isActive = 0;
      this.dateNow = DateTime.now();
      this.timeNow = TimeOfDay.now();
      this.selectedDate = DateTime.now();
      this.description = '';
      onChangedDescription = (description) => setState(() =>
      this.description = description);
    });
  }
  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    tProv.getTheme();
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: tProv.mode.primaryColor,
        title: Text('Add Agenda',
        style: TextStyle(color: tProv.mode.colorScheme.secondary),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveAgenda,
        backgroundColor: Colors.green,
        child: Icon(Icons.check, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('OFF',
                      style: tProv.mode.textTheme.bodyText2!.copyWith(
                        color: Colors.grey.shade100,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      Switch(
                        activeColor: tProv.mode.colorScheme.secondary,
                        onChanged: switchToggle,
                        value: this.isSwitch,
                      ),
                      Text('ON',
                        style: tProv.mode.textTheme.bodyText2!.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: pickDateTime,
                        style: ElevatedButton.styleFrom(
                          primary: tProv.mode.textTheme.headline1!.color
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.date_range),
                            SizedBox(width:15),
                            Text('Pick a Date')
                          ],
                        )
                    ),
                  ),
                  TextFormField(
                    initialValue: this.description,
                    onChanged: onChangedDescription,
                    autofocus: true,
                    maxLines: 7,
                    style: tProv.mode.textTheme.bodyText2!.copyWith(
                      color: Colors.grey.shade100,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle: tProv.mode.textTheme.bodyText2!.copyWith(
                        color: Colors.grey.shade100,
                        fontWeight: FontWeight.bold
                      ),
                      border: InputBorder.none
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void switchToggle(bool value) {
    setState(() {
      this.isSwitch = !this.isSwitch;
      if(this.isSwitch == true){
        this.isActive = 1;
      }else{
        this.isActive = 0;
      }
      // print(this.isSwitch);
      // print(this.isActive);
    });
  }

  Future pickDate() async{
    final selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2050)
    );
    if (selected != null && selected != this.selectedDate) {
      setState(() {
        this.selectedDate = selected;
      });
    }
    return this.selectedDate;
  }

  Future pickTime() async {
    final selected = await showTimePicker(
        context: context,
        initialTime: this.timeNow
    );
    if (selected != null && selected != this.timeNow) {
      setState(() {
        this.timeNow = selected;
      });
    }
    return this.timeNow;
  }

  Future pickDateTime() async{
    final date = await pickDate();
    if(date == null) return;

    final time = await pickTime();
    if(time == null) return;

    setState(() {
      this.dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
    print(this.dateTime);
  }

  void saveAgenda() async{
    var format = new DateFormat('dd-MM-yyyy, hh:mm');
    var prov = Provider.of<AgendaProvider>(context, listen: false);
    var len = prov.items.length + 1;
    if(this.isActive == 1){
      NotificationService().showNotification(
          len,
          this.description,
          format.format(this.dateTime),
          this.dateTime
      );
    }
    await Provider.of<AgendaProvider>(context, listen: false).addNewAgenda(
      Agenda(
          description: this.description,
          dueDate: this.dateTime,
          isActive: this.isActive
      )
    );
    Navigator.of(context).pop();
  }
}
