import 'package:alyucado/model/calories.dart';
import 'package:alyucado/model/calories_detail.dart';
import 'package:alyucado/provider/calories_detail_provider.dart';
import 'package:alyucado/provider/calories_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class CaloriesAdd extends StatefulWidget {
  const CaloriesAdd({
    Key? key,
    required this.caloriesId,
  }) : super(key: key);

  final int caloriesId;

  @override
  _CaloriesAddState createState() => _CaloriesAddState();
}

class _CaloriesAddState extends State<CaloriesAdd> {
  late String calor;
  late String food;
  late final ValueChanged<String> onChangedCalory;
  late final ValueChanged<String> onChangedFood;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calor = '';
    food = '';
    onChangedCalory = (calory) => setState(() =>
    this.calor = calory);
    onChangedFood = (food) => setState(() =>
    this.food = food);
  }
  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Text("Add Calories",
          style: TextStyle(color: tProv.mode.colorScheme.secondary,
              fontWeight: FontWeight.bold),),
        backgroundColor: tProv.mode.primaryColor, systemOverlayStyle: SystemUiOverlayStyle.light,
        // actions: [
        //   ElevatedButton(
        //       onPressed: saveCalories,
        //       child:
        //       Text("Save")),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: saveCalories,
        child: Icon(Icons.check, color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Container(
            padding: EdgeInsets.all(5),
            color: tProv.mode.primaryColor,
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                      autofocus: true,
                      style: tProv.mode.textTheme.bodyText1!.copyWith(
                        color: Colors.grey.shade100
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: calor.toString(),
                      decoration: InputDecoration(
                        hintText: "Calory",
                        hintStyle: tProv.mode.textTheme.bodyText1!.copyWith(
                          color: Colors.grey.shade100
                        ),
                        border: InputBorder.none
                      ) ,
                      onChanged: onChangedCalory,
                  ),
                  SizedBox(height: 40,),
                  TextFormField(
                      style: tProv.mode.textTheme.bodyText2!.copyWith(
                        color: Colors.grey.shade100
                      ),
                      initialValue: food,
                      maxLines: 7,
                      decoration: InputDecoration(
                        hintText: "Food",
                        hintStyle: tProv.mode.textTheme.bodyText2!.copyWith(
                          color: Colors.grey.shade100
                        ),
                        border: InputBorder.none
                      ) ,
                      onChanged: onChangedFood
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveCalories() async{
    var dt = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(dt); // Save this to DB
    print(formatted); // Output: 2021-05-11 08:52:45
    print(formatter.parse(formatted)); //
    final caloriesProvider = Provider.of<CaloriesProvider>(context, listen: false).items.where((element) => element.id == widget.caloriesId).toList();
    final caloriesdet = CaloriesDetail(
        idKalori: widget.caloriesId,
        food: food.toString(),
        calory: int.parse(calor),
        createdTime: formatter.format(dt),
    );
    await Provider.of<CaloriesDetailProvider>(context, listen: false).addNewCalories(caloriesdet);
    await Provider.of<CaloriesProvider>(context, listen: false).updateCalories(
        Calories(
            id: widget.caloriesId,
            calory: caloriesProvider[0].calory + int.parse(calor),
            createdTime: caloriesProvider[0].createdTime
        )
    );
    Navigator.of(context).pop();
  }
}
