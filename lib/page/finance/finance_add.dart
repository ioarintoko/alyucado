import 'package:alyucado/model/finance.dart';
import 'package:alyucado/provider/finance_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FinanceAdd extends StatefulWidget {
  const FinanceAdd({Key? key}) : super(key: key);

  @override
  State<FinanceAdd> createState() => _FinanceAddState();
}

class _FinanceAddState extends State<FinanceAdd> {
  List<bool> _selections = [true, false];
  var cur;
  var type;
  var nominal;
  var description;
  late final ValueChanged<String> onChangedNominal;
  late final ValueChanged<String> onChangedDescription;
  late final ValueChanged<String> onChangedNV;
  NumberFormat currencyFormatter = NumberFormat.currency(
    decimalDigits: 0,
  );
  TextEditingController currencyControler = TextEditingController();
  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }
  var selectedDate;
  var dateNow;
  var timeNow;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      this.type = 'debit';
      print(this.type);
      this.nominal = '';
      this.description = '';
      this.cur = '';
      onChangedNominal = (nominal) => setState(() =>
      this.nominal = nominal);
      onChangedDescription = (description) => setState(() =>
      this.description = description);
      this.dateNow = DateTime.now();
      this.timeNow = TimeOfDay.now();
      this.selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        backgroundColor: tProv.mode.primaryColor,
        shadowColor: Colors.transparent,
        title: Text('Add Data',
          style: TextStyle(
              color: tProv.mode.colorScheme.secondary
          ),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveData,
        backgroundColor: Colors.green,
        child: Icon(Icons.check, color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextFormField(
                cursorColor: Colors.grey.shade100,
                controller: currencyControler,
                style: tProv.mode.textTheme.bodyText1!.copyWith(
                  color: Colors.grey.shade100
                ),
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Nominal',
                  hintStyle: tProv.mode.textTheme.bodyText1!.copyWith(
                    color: Colors.grey.shade100
                  ),
                  border: InputBorder.none
                ),
                onChanged: (string) {
                  setState(() {
                    this.nominal = string;
                  });
                  string = '${formNum(
                    string.replaceAll(',', ''),
                  )}';
                  currencyControler.value = TextEditingValue(
                    text: string,
                    selection: TextSelection.collapsed(
                      offset: string.length,
                    ),
                  );
                },
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: pickDateTime,
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green
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
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(100))
                ),
                child: ToggleButtons(
                  fillColor: Color(0xff000000),
                    borderColor: Color(0xff007000),
                    selectedBorderColor: Color(0xff000070),
                    borderWidth: 3,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    children: [
                      Row(
                        children: [
                          Text('Debit', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                          Icon(Icons.attach_money_sharp, color: Colors.green,),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.attach_money_sharp, color: Colors.red,),
                          Text('Credit', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                    isSelected: _selections,
                    onPressed: (int index) {
                      if (index < 1){
                        setState(() {
                          this.type = 'debit';
                          _selections[0] = true;
                          _selections[1] = false;
                        });
                      }else{
                        setState(() {
                          _selections[0] = false;
                          _selections[1] = true;
                          this.type = 'credit';
                        });
                      }
                      // print(this.type);
                    },
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                cursorColor: Colors.grey.shade100,
                style: tProv.mode.textTheme.bodyText2!.copyWith(
                  color: Colors.grey.shade100
                ),
                initialValue: this.description,
                maxLines: 7,
                decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: tProv.mode.textTheme.bodyText2!.copyWith(
                      color: Colors.grey.shade100
                    ),
                    border: InputBorder.none
                ),
                onChanged: onChangedDescription,
              ),
            ],
          ),
        ),
      ),
    );
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

  void saveData() async{
    var fProv = Provider.of<FinanceProvider>(context, listen: false).items;
    var bal;
    var debit;
    var credit;
    var nominal = int.parse(this.nominal.replaceAll(',', ''));
    var gap;

    if (this.type == 'debit'){
      debit = nominal;
      credit = 0;
    }

    if (this.type == 'credit') {
      debit = 0;
      credit = nominal;
    }

    if (fProv.isEmpty){
      if(this.type == 'debit'){
        bal = 0 + nominal;
        gap = bal;
      }

      if(this.type == 'credit'){
        bal = 0 - nominal;
        gap = bal;
      }
    }else{
      fProv = fProv.where((element) => element.createdTime.isBefore(this.dateTime)).toList();
      if(fProv.isEmpty){
        bal = 0 + nominal;
        gap = bal;
      }else{
        if(this.type == 'debit') {
          bal = fProv[fProv.length-1].lastBalance + nominal;
          gap = nominal;
        }

        if(this.type == 'credit'){
          bal = fProv[fProv.length-1].lastBalance - nominal;
          gap = nominal * -1;
        }
      }
    }

    await Provider.of<FinanceProvider>(context, listen: false).addNewFinance(
      Finance(
          description: this.description,
          debit: debit,
          credit: credit,
          lastBalance: bal,
          createdTime: this.dateTime
      )
    );

    await Provider.of<FinanceProvider>(context, listen: false).updateFinanceAfter(
      this.dateTime.toIso8601String(),
      gap
    );

    Navigator.of(context).pop();
  }
}
