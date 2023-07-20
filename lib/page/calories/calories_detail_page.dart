import 'package:alyucado/model/calories.dart';
import 'package:alyucado/page/calories/calories_edit.dart';
import 'package:alyucado/provider/calories_detail_provider.dart';
import 'package:alyucado/provider/calories_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'calories_add.dart';

class CaloriesDetailPage extends StatefulWidget{
  const CaloriesDetailPage({
    Key? key,
    required this.caloriesId,
  }) : super(key: key);

  final int caloriesId;

  @override
  _CaloriesDetailPageState createState() => _CaloriesDetailPageState();
}

class _CaloriesDetailPageState extends State<CaloriesDetailPage> {
  bool _isLoading = false;
  late bool _isSearchBarShow = false;
  late String query;
  late final ValueChanged<String> onChangedQuery;
  var formatter = new DateFormat('dd-MM-yyyy, hh:mm');
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      query = '';
      onChangedQuery = (query) => setState(() =>
      this.query = query);
      print(_isLoading);
    });
  }
  @override
  Widget build(BuildContext context) {
  // TODO: implement build
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: tProv.mode.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: tProv.mode.primaryColor,
            shadowColor: Colors.transparent
          ),
          onPressed: () async{
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: Colors.white,),
        ),
        foregroundColor: tProv.mode.primaryColor,
        title: _isSearchBarShow == false ?
        Text("Calories Detail",
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
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          ElevatedButton(
            onPressed: (){
              setState(() {
                _isSearchBarShow = !_isSearchBarShow;
                print(_isSearchBarShow);
              });
            },
            child:_isSearchBarShow ?
            CloseButton(onPressed: () {
              setState((){
                _isSearchBarShow = false;
                this.query = '';
              });
              },
            ) :
            Icon(Icons.search),
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent
            ),
          )
        ], systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body:
      SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: FutureBuilder(
                future: Provider.of<CaloriesProvider>(context, listen: false).loadSelectedCalories(widget.caloriesId),
                builder: (context, calories){
                  // if(calories.connectionState == ConnectionState.done){
                    if(calories.hasData){
                      var cal = calories.data as List<Calories>;
                      return Container(
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.only(top: 90),
                        height: size.height * 0.5,
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.elliptical(
                                  size.width,
                                  24
                              ),
                            ),
                            color: tProv.mode.primaryColor
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Your Calories, \n${cal[0].createdTime}',
                                    style: TextStyle(color: Colors.grey.shade100),
                                  ),
                                  Text(cal[0].calory.toString(),
                                    style: TextStyle(
                                        color: tProv.mode.colorScheme.secondary,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 90
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }else{
                      return Container(child: Text('No Data'),);
                    }
                  // }else{
                  //   return Center(child: CircularProgressIndicator(),);
                  // }

                },
              ),
            ),
            FutureBuilder(
              future: Provider.of<CaloriesDetailProvider>(context, listen: false).loadCalories(widget.caloriesId),
              builder:(context, calories){
                return calories.hasData ?
                Container(
                    height: size.height * 0.5,
                    width: size.width,
                    padding: EdgeInsets.all(20),
                    child:
                    (calories.data as List).where((cd) => cd.idKalori == widget.caloriesId).isEmpty ?
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Data", style: tProv.mode.textTheme.bodyText2),
                        ],
                      ),
                    ) : (calories.data as List).where((cd) => cd.idKalori == widget.caloriesId).isNotEmpty ?
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(0),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount:
                              (calories.data as List).length,
                              itemBuilder: (context, index){
                                return (calories.data as List)[index].calory.toString().toLowerCase().contains(this.query) ||
                                    (calories.data as List)[index].food.toLowerCase().contains(this.query) ?
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CaloriesEdit(caloriesId: (calories.data as List)[index].id),
                                    ));
                                  },
                                  child: Card(
                                    color: tProv.mode.cardColor,
                                    child: ListTile(
                                      leading: Text(
                                        (calories.data as List)[index].calory.toString(),
                                        style: tProv.mode.textTheme.bodyText1!.copyWith(
                                          fontSize: 20
                                        ),
                                      ),
                                      subtitle: Text((calories.data as List)[index].createdTime,
                                        style: tProv.mode.textTheme.bodyText2,),
                                      title: Text((calories.data as List)[index].food,
                                        style: tProv.mode.textTheme.bodyText2),
                                    ),
                                  ),
                                ):Container();
                              }
                          ),
                        ),
                      ],
                    ) : Container()
                ): Text(calories.hasData.toString());
              },
            ),
          ],
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white,),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CaloriesAdd(caloriesId: widget.caloriesId,),
            )
            );
          }
      ),
    );
  }
}