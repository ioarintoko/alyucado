import 'dart:core';
import 'dart:developer';

import 'package:alyucado/model/finance.dart';
import 'package:alyucado/provider/finance_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FinanceEdit extends StatefulWidget {
  final int? id;
  const FinanceEdit({Key? key, required this.id}) : super(key: key);

  @override
  State<FinanceEdit> createState() => _FinanceEditState();
}
class _FinanceEditState extends State<FinanceEdit> {
  late final fProv;
  var id;
  var description;
  late String nominal;
  late int debit;
  late int credit;
  var lastBalance;
  var createdTime;
  var type;
  var typeNow;
  late final ValueChanged<String> onChangedDescription;
  late final ValueChanged<String> onChangedNominal;
  var _selections;

  TextEditingController currencyControler = TextEditingController();
  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      this.fProv = Provider.of<FinanceProvider>(context, listen: false).items.where((el) => el.id == widget.id).toList();
      this.description = this.fProv[0].description;
      this.debit = this.fProv[0].debit;
      this.credit = this.fProv[0].credit;
      this.createdTime = this.fProv[0].createdTime;
      log(this.createdTime.toString());
      print(this.debit);
      print(this.credit);
      // this._isSelected = [true, false];
      if (this.debit != 0){
        this._selections = [true, false];
        this.type = 'debit';
        this.typeNow = 'debit';
      }
      if (this.credit != 0) {
        this._selections = [false, true];
        this.type = 'credit';
        this.typeNow = 'credit';
      }
      // this._selections = this._isSelected;
      this.nominal = this.type == 'debit' ? debit.toString() : credit.toString();
      // this.nominal = '1000';
      this.lastBalance = this.fProv[0].lastBalance;

      onChangedDescription = (description) => setState(() =>
      this.description = description);
      onChangedNominal = (nominal) => setState(() =>
      this.nominal = nominal);
      this.currencyControler = TextEditingController(text: this.nominal);
    });
  }
  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Text('Edit Data',
          style: TextStyle(
              color: tProv.mode.colorScheme.secondary
          ),
        ),
        backgroundColor: tProv.mode.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: editFinance,
        backgroundColor: Colors.green,
        child: Icon(Icons.check, color:  Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextFormField(
                cursorColor: Colors.grey.shade100,
                controller: this.currencyControler,
                style: tProv.mode.textTheme.bodyText1!.copyWith(
                  color: Colors.grey.shade100
                ),
                keyboardType: TextInputType.number,
                autofocus: true,
                // initialValue: this.nominal,
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
                        this.typeNow = 'debit';
                        this._selections[0] = true;
                        this._selections[1] = false;
                        print('a');
                      });
                    }else{
                      setState(() {
                        this._selections[0] = false;
                        this._selections[1] = true;
                        this.typeNow = 'credit';
                        print('a');
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

  void editFinance() async{
    var lastBalanceNow = this.lastBalance.toInt();
    log('lastBalance = $lastBalanceNow');

    var nominal  = int.parse(this.nominal.replaceAll(',', ''));
    log('nominal = $nominal');

    var debit = this.debit.toInt();
    log('debit = $debit');

    var credit = this.credit.toInt();
    log('credit = $credit');

    var count;
    if(debit > 0){
      count = debit;
    }
    if(credit > 0){
      count = credit;
    }
    // = int.parse(this.nominal.replaceAll(',', ''));
    log('count = $count');

    var gap;

    var fProv1 = Provider.of<FinanceProvider>(context, listen: false);
    var lastBalanceBefore = fProv1.items.where((element) => 
      element.createdTime.isBefore(this.createdTime)
    ).toList();
    var lbb = lastBalanceBefore[0].lastBalance;
    if(widget.id == fProv1.items[fProv1.items.length-1].id){
      if(this.typeNow != this.type){
        if(this.typeNow == 'debit'){
          lastBalanceNow = 0 + nominal;
          log('lastBalanceNow = 0 + $nominal = $lastBalanceNow');
        }else{
          lastBalanceNow = 0 - nominal;
          log('lastBalanceNow = 0 - $nominal = $lastBalanceNow');
        }
      }
    } else {
      if(this.typeNow == 'credit'){
        gap = count - (nominal * -1);
        lastBalanceNow -= gap;
        gap = gap * -1;

        debit = 0;
        credit = nominal;

      }
      if(this.typeNow == 'debit'){
        log('$nominal');
        if(count == nominal){
          gap = count - (nominal * -1);
        }else{
          gap = nominal - count;
        }
        lastBalanceNow += gap;

        debit = nominal;
        credit = 0;

      }
    }


    log('gap end $gap');
    log('balance end $lastBalanceNow');
    log('finance edit createdtime ${this.createdTime.runtimeType}');
    await Provider.of<FinanceProvider>(context, listen: false).updateFinanceAfter(
        this.createdTime.toString(),
        gap);

    await Provider.of<FinanceProvider>(context, listen: false).updateFinance(
      Finance(
          id: widget.id,
          description: this.description,
          debit: debit,
          credit: credit,
          lastBalance: lastBalanceNow,
          createdTime: this.createdTime
      )
    );


    Navigator.of(context).pop();
  }
}
