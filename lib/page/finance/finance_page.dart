import 'dart:developer';

import 'package:alyucado/model/finance.dart';
import 'package:alyucado/model/profile.dart';
import 'package:alyucado/page/finance/finance_add.dart';
import 'package:alyucado/page/finance/finance_edit.dart';
import 'package:alyucado/provider/finance_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({
    Key? key,
  }) : super(key: key);


  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  var formatter = new DateFormat('dd-MM-yyyy, hh:mm');
  var firstDate;
  var lastDate;
  var query;
  late final ValueChanged<String> onChangedQuery;
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );
  var tProv;
  bool isFilterOn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      this.firstDate = DateTime(2021);
      this.lastDate = DateTime(2050);
      this.query = '';
      onChangedQuery = (query) => setState(() =>
      this.query = query);
      print(this.query);
      this.tProv = Provider.of<ThemeProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var pProv = Provider.of<ProfileProvider>(context, listen: false);
    pProv.loadProfiles();
    var name = pProv.items[0].name.split(' ')[0];
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: this.tProv.mode.scaffoldBackgroundColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: this.tProv.mode.primaryColor,
        title: Text('Finance',
          style: TextStyle(color: tProv.mode.colorScheme.secondary),),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body:
        FutureBuilder(
          future: Provider.of<FinanceProvider>(context).loadFinances(),
          builder: (context, finance) {
            return finance.hasData ?
              Container(
                child: (finance.data as List<Finance>).isEmpty ?
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Data", style: this.tProv.mode.textTheme.bodyText2,),
                      ],
                    ),
                  ) :
                Container(
                    child:
                      Column(
                        children: [
                          Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.elliptical(
                                    MediaQuery.of(context).size.width,
                                    24
                                )
                            ),
                            color: tProv.mode.primaryColor,
                          ),
                          padding: EdgeInsets.only(top: 90, bottom: 10),
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Visibility(
                                visible: !this.isFilterOn,
                                  child: Container(
                                    margin: EdgeInsets.all(16),
                                    child: Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Hi, $name!',
                                                style: tProv.mode.textTheme.bodyText2!.copyWith(
                                                    color: Colors.grey.shade100,
                                                    fontSize: 25.0,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional.topEnd,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors.transparent,
                                                        shadowColor: Colors.transparent
                                                    ),
                                                    onPressed: (){
                                                      setState((){
                                                        this.isFilterOn = true;
                                                      });
                                                    },
                                                    child: Icon(Icons.filter_list_alt)
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 30,),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.vertical(
                                                bottom: Radius.elliptical(
                                                    MediaQuery.of(context).size.width,
                                                    24
                                                ),
                                                top: Radius.circular(24)
                                              ),
                                              color: tProv.mode.cardColor
                                            ),
                                            child: Column(
                                              children: [
                                                Text('Your Last Balance',
                                                  style: tProv.mode.textTheme.bodyText2!.copyWith(
                                                      // color: Colors.grey.shade100,
                                                      fontSize: 15.0
                                                  ),
                                                ),
                                                Text('${currencyFormatter.format((finance.data as List<Finance>)
                                                [(finance.data as List<Finance>).length -1]
                                                    .lastBalance)}',
                                                  style: tProv.mode.textTheme.bodyText1!.copyWith(
                                                      color: tProv.mode.textTheme.headline1!.color,
                                                      fontSize: 30.0
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ),
                              Visibility(
                                visible: this.isFilterOn,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Search Filter',
                                      style: tProv.mode.textTheme.bodyText1.copyWith(
                                        color: Colors.grey.shade100,
                                        fontSize: 30.0,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.horizontal(
                                              left: Radius.elliptical(
                                                  50,
                                                  100
                                              ),
                                              right: Radius.elliptical(
                                                  50,
                                                  100
                                              )
                                          ),
                                          color: tProv.mode.cardColor
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: TextFormField(
                                        initialValue: this.query,
                                        style: tProv.mode.textTheme.bodyText2,
                                        decoration: InputDecoration(
                                            hintText: 'Search By Description...',
                                            hintStyle: tProv.mode.textTheme.bodyText2,
                                            border: InputBorder.none
                                        ),
                                        textAlign: TextAlign.center,
                                        onChanged: onChangedQuery,
                                      ),
                                    ),
                                    SizedBox(height: 30,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(
                                                      bottom: Radius.elliptical(
                                                          MediaQuery.of(context).size.width,
                                                          24
                                                      )
                                                  )
                                              ),
                                              primary: Colors.green
                                          ),
                                          onPressed: () => selectDate(context),
                                          child: Text('Pick Date'),
                                        ),
                                        CloseButton(
                                          color: Colors.white,
                                          onPressed: (){
                                            setState((){
                                              this.isFilterOn = false;
                                              ref();
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(10),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: (finance.data as List<Finance>).length,
                              itemBuilder: (context, index){
                                var datafinance = (finance.data as List<Finance>);
                                // var firstBalance = datafinance[0].lastBalance;
                                var lastBalance;
                                if(index < 1) {
                                  lastBalance = 0;
                                } else {
                                  lastBalance = datafinance[index-1].lastBalance;
                                }
                                return
                                        (datafinance[index].createdTime.isAfter(this.firstDate) &&
                                        datafinance[index].createdTime.isBefore(this.lastDate)) &&
                                datafinance[index].description.toLowerCase().contains(this.query) ?
                                  GestureDetector(
                                    onTap: () {
                                      showDialog<void>(
                                        context: context,
                                        barrierColor: Colors.white12,
                                        builder: (context) {
                                          return new AlertDialog(
                                            title: Center(
                                              child: Text('Detail Transaksi',
                                                style: TextStyle(fontSize: 20, color: Colors.white54),),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary: Colors.transparent,
                                                      onPrimary: Colors.blueAccent
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showDialog<void>(
                                                      barrierColor: Colors.white54,
                                                        context: context,
                                                        builder: (context) {
                                                          return new AlertDialog(
                                                            actions: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      primary: Colors.transparent,
                                                                      onPrimary: Colors.blueAccent
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text('Cancel')
                                                              ),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      primary: Colors.transparent,
                                                                      onPrimary: Colors.blueAccent
                                                                  ),
                                                                  onPressed: () => deleteFinance(
                                                                      datafinance[index].id,
                                                                      datafinance[index].createdTime.toIso8601String(),
                                                                    datafinance[index].debit == 0 ? datafinance[index].credit :
                                                                    datafinance[index].debit,
                                                                    datafinance[index].debit == 0 ? 'credit' : 'debit'
                                                                  ),
                                                                  child: Text('Delete')
                                                              ),
                                                            ],
                                                            backgroundColor: Colors.black,
                                                            content: Text('Are you sure want to delete this transaction?',
                                                            style: TextStyle(color: Colors.white54),
                                                            ),
                                                          );
                                                        }
                                                    );
                                                  },
                                                  child: Text('Delete')
                                              ),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary: Colors.transparent,
                                                      onPrimary: Colors.blueAccent
                                                  ),
                                                  onPressed: () async {
                                                      await Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => FinanceEdit(id: datafinance[index].id),
                                                      ));
                                                      Navigator.of(context).pop();
                                                    },
                                                  child: Text('Edit')
                                              ),
                                            ],
                                            backgroundColor: Colors.black,
                                            content: Container(
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(datafinance[index].description,
                                                    style: TextStyle(fontSize: 20, color: Colors.white54),),
                                                  SizedBox(height: 15,),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.centerRight,
                                                        child: Text('Saldo Awal ${(currencyFormatter.format(lastBalance))}',
                                                          style: TextStyle(color: Colors.white54, fontSize: 15),),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          // datafinance[index].credit == 0 ?
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('Debit', style: TextStyle(color: Colors.white54),),
                                                              Text(currencyFormatter.format(datafinance[index].debit),
                                                                  style: TextStyle(color: Colors.green))
                                                            ],
                                                          ),
                                                              //:
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('Credit', style: TextStyle(color: Colors.white54),),
                                                              Text(currencyFormatter.format(datafinance[index].credit),
                                                                style: TextStyle(color: Colors.red),),
                                                            ],
                                                          ),
                                                          Divider(color: Colors.white54,),
                                                        ],
                                                      ),
                                                      Container(
                                                        alignment: Alignment.centerRight,
                                                        child: Text('Saldo Akhir ${(currencyFormatter.format(datafinance[index].lastBalance))}',
                                                          style: TextStyle(color: Colors.white54, fontSize: 15),),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.elliptical(
                                              MediaQuery.of(context).size.width, 
                                              24
                                          ),
                                        ),
                                        side: BorderSide(color: Colors.grey.shade100)
                                      ),
                                      color: this.tProv.mode.cardColor,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(3),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text( datafinance[index].description.length > 10 ?
                                                      datafinance[index].description.substring(0,5) :
                                                    datafinance[index].description,
                                                    style: this.tProv.mode.textTheme.bodyText2,),
                                                    Text('Saldo ${(currencyFormatter.format(datafinance[index].lastBalance))}',
                                                    style: this.tProv.mode.textTheme.bodyText2,),
                                                  ],
                                                ),
                                              ),
                                              Divider(color: this.tProv.mode.accentColor,),
                                              Container(
                                                padding: EdgeInsets.all(3),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(formatter.format(datafinance[index].createdTime),
                                                      style: this.tProv.mode.textTheme.bodyText2,),
                                                    datafinance[index].credit == 0 ?
                                                    Text(currencyFormatter.format(datafinance[index].debit),
                                                      style: TextStyle(color: Colors.green)) :
                                                    Text(currencyFormatter.format(datafinance[index].credit),
                                                      style: TextStyle(color: Colors.red),),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    ),
                                  ) : Container();
                              }
                            ),
                          ),
                        ],
                      ),
                  ),
              )
              : Container();
          },
        ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              heroTag: 'add',
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FinanceAdd(),
                ));
              },
              child: Icon(Icons.add, color: Colors.white,),
            )
    );
  }

  void addFinance() async{
    var debit = 0;
    var credit = 20000;
    var fProvider = Provider.of<FinanceProvider>(context, listen: false).items;
    var balance;
    if (fProvider.length < 1) {
      balance = 0;
    } else {
      balance = fProvider[fProvider.length-1].lastBalance;
    }
    var inputted;
    if(debit > 0){
      inputted = balance + debit;
    }
    if (credit > 0) {
      inputted = balance - credit;
    }
    await Provider.of<FinanceProvider>(context, listen: false).addNewFinance(
      Finance(
          description: 'tes b',
          debit: debit,
          credit: credit,
          lastBalance: inputted,
          createdTime: DateTime.now()
      ));
  }

  void delFinance() async{
    await Provider.of<FinanceProvider>(context, listen: false).deleteAllFinance();
  }

  Future<void> selectDate(BuildContext context) async{
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022),
        lastDate: DateTime(2099)
    );
    if(picked != null){
      setState(() {
        this.firstDate = picked.start;
        print(firstDate);
        this.lastDate = picked.end;
        print(lastDate);
      });
    }
    // Navigator.of(context).pop();
  }

  void ref() {
    setState(() {
      this.query = '';
      print(this.query);
      this.firstDate = DateTime(2021);
      print(this.firstDate);
      this.lastDate = DateTime(2052);
      print(this.lastDate);
    });
  }

   Future<void> deleteFinance(int? id, String date, int lastBalanceNow, String type) async{
    var gap;
    if(type == 'debit') {
      gap = lastBalanceNow * -1;
    }
    if(type == 'credit') {
      gap = lastBalanceNow;
    }
    await Provider.of<FinanceProvider>(context, listen: false).updateFinanceAfter(
        date,
        gap);

    await Provider.of<FinanceProvider>(context, listen: false).deleteFinance(id);

    Navigator.of(context).pop();
  }
}
