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

class AgendaEdit extends StatefulWidget {
  const AgendaEdit({
    Key? key, required this.id
  }) : 
        super(key: key);
  final int id;
  
  @override
  State<AgendaEdit> createState() => _AgendaEditState();
}

class _AgendaEditState extends State<AgendaEdit> {
  var id;
  var description;
  var dueDate;
  var isActive;
  late final ValueChanged<String> onChangedDescription;
  var isSwitch;
  var selectedDate;
  var dateNow;
  var timeNow;
  var dateTime;
  var aProv;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    setState(() {
      this.aProv = Provider.of<AgendaProvider>(context, listen: false).items.
      where((agd) => agd.id == widget.id).toList();
      this.id = this.aProv[0].id;
      this.description = this.aProv[0].description;
      this.dueDate = this.aProv[0].dueDate;
      this.isActive = this.aProv[0].isActive;
      this.isSwitch = this.isActive == 1 ? true : false;
      this.dateNow = DateTime.now();
      this.timeNow = TimeOfDay.now();
      this.selectedDate = DateTime.now();
      this.dateTime = this.dueDate;
      onChangedDescription = (description) => setState(() =>
      this.description = description);
    });
  }
  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy, hh:mm');
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    tProv.getTheme();
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: tProv.mode.primaryColor,
        title: Text('Edit Agenda',
          style: TextStyle(color: tProv.mode.colorScheme.secondary),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'delete',
              onPressed: deleteAgenda,
            backgroundColor: Colors.red,
            child: Icon(Icons.delete, color: Colors.white),
          ),
          SizedBox(width: 5,),
          FloatingActionButton(
            heroTag: 'edit',
            backgroundColor: Colors.green,
            onPressed: editAgenda,
            child: Icon(Icons.check, color: Colors.white,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 50),
          child: Container(
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
                              primary: tProv.mode.textTheme.headline1!.color,
                              onPrimary: tProv.mode.primaryColor
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
                    Text(formatter.format(this.dateTime),
                      style: TextStyle(color: Colors.grey.shade100),
                    ),
                    TextFormField(
                      initialValue: this.description,
                      onChanged: onChangedDescription,
                      autofocus: true,
                      maxLines: 7,
                      style: tProv.mode.textTheme.bodyText2!.copyWith(
                          color: Colors.grey.shade100
                      ),
                      decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: tProv.mode.textTheme.bodyText2!.copyWith(
                            color: Colors.grey.shade100
                          ),
                        border: InputBorder.none
                      ),
                    ),
                  ],
                )
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

  void deleteAgenda() async{
    NotificationService().cancelNotifications(this.id);
    await Provider.of<AgendaProvider>(context, listen: false).deleteAgenda(widget.id);
    Navigator.of(context).pop();
  }

  void editAgenda() async{
    var format = new DateFormat('dd-MM-yyyy, hh:mm');
    if(this.isActive == 1){
      NotificationService().showNotification(
          this.id,
          this.description,
          format.format(this.dateTime),
          this.dateTime
      );
    }else{
      NotificationService().cancelNotifications(this.id);
    }
    await Provider.of<AgendaProvider>(context, listen: false).updateAgenda(
      Agenda(
          id: this.id,
          description: this.description,
          dueDate: this.dateTime,
          isActive: this.isActive
      )
    );
    Navigator.of(context).pop();
  }
}
