import 'package:alyucado/model/calories.dart';
import 'package:alyucado/model/calories_detail.dart';
import 'package:alyucado/provider/calories_detail_provider.dart';
import 'package:alyucado/provider/calories_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CaloriesEdit extends StatefulWidget {
  final int caloriesId;
  const CaloriesEdit(
      {Key? key,
        required this.caloriesId
      }
      ) : super(key: key);
  @override
  _CaloriesEditState createState() => _CaloriesEditState();
}

class _CaloriesEditState extends State<CaloriesEdit> {
  late final caloriesdetProvider = Provider.of<CaloriesDetailProvider>(context, listen: false).items.where((element) => element.id == widget.caloriesId).toList();
  late String calory;
  late String food;
  late String caloryNew;
  late String foodNew;
  late String createdTime;
  late int idKalori;
  late final ValueChanged<String> onChangedCalory;
  late final ValueChanged<String> onChangedFood;
  late final ValueChanged<String> onChangedCreatedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print(caloriesdetProvider);
    caloryNew = caloriesdetProvider[0].calory.toString();
    foodNew = caloriesdetProvider[0].food;
    idKalori = caloriesdetProvider[0].idKalori;
    calory = caloriesdetProvider[0].calory.toString();
    food = caloriesdetProvider[0].food;
    createdTime = caloriesdetProvider[0].createdTime;
    _isLoading = true;
    onChangedCalory = (calory) => setState(() =>
    this.caloryNew = calory);
    onChangedFood = (food) => setState(() =>
    this.foodNew = food);
  }
  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          title: Text("Edit Calories",
            style: TextStyle(
                color: tProv.mode.colorScheme.secondary,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: tProv.mode.primaryColor, systemOverlayStyle: SystemUiOverlayStyle.light,
          // actions: [
          //   ElevatedButton(
          //       onPressed: editCalories,
          //       child:
          //       Text("Save")),
          // ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'Button Delete',
                backgroundColor: Colors.red,
                onPressed: deleteCalories,
                child: Icon(Icons.delete, color: Colors.white,),
              ),
              SizedBox(width: 20,),
              FloatingActionButton(
                heroTag: 'Button Edit',
                backgroundColor: Colors.green,
                onPressed: editCalories,
                child: Icon(Icons.check, color: Colors.white,)
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body:
        SingleChildScrollView(
          child:
          Consumer<CaloriesDetailProvider>(
            builder: (context, caloriesdet, _) =>
            caloriesdet.items.where((element) => element.id == widget.caloriesId) != null ?
            Container(
              color: tProv.mode.primaryColor,
              padding: EdgeInsets.all(30),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          style: tProv.mode.textTheme.bodyText1!.copyWith(
                            color: Colors.grey.shade100
                          ),
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          initialValue: calory.toString(),
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
                          onChanged: onChangedFood,
                        ),
                      ],
                    ),
                  ),
                ),
            ): Text("Not There", style: tProv.mode.textTheme.bodyText2,),
          ),
        )
    );
  }

  void editCalories() async{
    final caloriesProvider = Provider.of<CaloriesProvider>(context, listen: false).items.where((element) => element.id == idKalori).toList();
    await Provider.of<CaloriesDetailProvider>(context, listen: false).updateCalories(
        CaloriesDetail(
          id: widget.caloriesId,
          calory: int.parse(caloryNew),
          food: foodNew,
          idKalori: idKalori,
          createdTime: createdTime,
    ));

    var calGap = int.parse(caloryNew) - int.parse(calory);
    await Provider.of<CaloriesProvider>(context, listen: false).updateCalories(
      Calories(
          id: idKalori,
          calory: caloriesProvider[0].calory + calGap,
          createdTime: caloriesProvider[0].createdTime
      )
    );
    Navigator.of(context).pop();
    print(int.parse(caloryNew) - int.parse(calory));
  }

  void deleteCalories() async {
    final caloriesProvider = Provider.of<CaloriesProvider>(context, listen: false).items.where((element) => element.id == idKalori).toList();
    await Provider.of<CaloriesProvider>(context, listen: false).updateCalories(
      Calories(
          id: idKalori,
          calory: caloriesProvider[0].calory - int.parse(calory),
          createdTime: createdTime
      )
    );

    await Provider.of<CaloriesDetailProvider>(context, listen: false).deleteCalories(widget.caloriesId);
    Navigator.of(context).pop();
  }
}
