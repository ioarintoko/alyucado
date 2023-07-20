import 'package:alyucado/model/calories.dart';
import 'package:alyucado/provider/calories_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'calories_detail_page.dart';

class CaloriesPage extends StatefulWidget{
  const CaloriesPage({Key? key}) : super(key: key);

  @override
  _CaloriesPageState createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  bool _isLoading = false;
  late bool _isSearchBarShow = false;
  late String query;
  var journalx = "a";
  late final ValueChanged<String> onChangedQuery;
  var formatter = new DateFormat('dd-MM-yyyy');
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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: tProv.mode.scaffoldBackgroundColor,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(
                MediaQuery.of(context).size.width,
                24
            )
          ),
        ),
        elevation: 0,
        title: _isSearchBarShow == false ?
        Text("Calories",
          style:
          TextStyle(
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
        backgroundColor: tProv.mode.primaryColor,
        actions: [
          ElevatedButton(
            onPressed: (){
              setState(() {
                _isSearchBarShow = !_isSearchBarShow;
                print(_isSearchBarShow);
              });
            },
            child: _isSearchBarShow ?
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: addCalories,
      // ),
      body:
        Container(
          // height: size.height,
          child: FutureBuilder(
            future: Provider.of<CaloriesProvider>(context).loadCalories(),
            builder: (context, calories){
              // if(calories.connectionState == ConnectionState.done){
                if(calories.hasData){
                  var cal = calories.data as List<Calories>;
                  return
                    Column(
                      children: [
                        Center(
                          child: Container(
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
                                Text('Your Calories Today',
                                  style: TextStyle(color: Colors.grey.shade100),
                                ),
                                Text(cal[0].calory.toString(),
                                  style: TextStyle(
                                      color: tProv.mode.colorScheme.secondary,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 90
                                  ),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        onPrimary: Colors.white
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => CaloriesDetailPage(caloriesId: cal[0].id!)),
                                      );
                                    },
                                    child: Icon(Icons.edit, size: 40,)
                                ),

                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                  padding: EdgeInsets.all(0),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: cal.length,
                                  itemBuilder: (context, index){
                                    if(index > 0 &&
                                        (cal[index].calory.toString().toLowerCase().contains(this.query.toLowerCase()) ||
                                        cal[index].createdTime.toLowerCase().contains(this.query.toLowerCase()))
                                    ){
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => CaloriesDetailPage(caloriesId: cal[index].id!)),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade500)
                                          ),
                                          child: Card(
                                            elevation: 0,
                                            color: tProv.mode.cardColor,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    child:
                                                      Center(
                                                        child: Text(cal[index].calory.toString(),
                                                        style: tProv.mode.textTheme.bodyText1!.copyWith(
                                                          fontSize: 50
                                                        ),
                                                        ),
                                                      )
                                                  ),
                                                  Divider(color: Colors.grey, thickness: 9,),
                                                  Center(
                                                    child: Text(cal[index].createdTime,
                                                    style: tProv.mode.textTheme.bodyText2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }else{
                                      return Container();
                                    }
                                  }
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                }else{
                  return Center(
                    child: Text('No Data',
                    style: tProv.mode.textTheme.bodyText2,
                    ),
                  );
                }
              // }else{
              //   return CircularProgressIndicator();
              // }
            },
          ),
        ),
    );
  }

  void addCalories() async{
    final calories = Calories(
        calory: 1899,
        createdTime: formatter.format(DateTime.now()),
    );
    await Provider.of<CaloriesProvider>(context,listen: false).addNewCalories(calories);
  }
}