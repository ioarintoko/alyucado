import 'package:alyucado/model/journal.dart';
import 'package:alyucado/page/journal/journal_add.dart';
import 'package:alyucado/page/journal/journal_detail.dart';
import 'package:alyucado/provider/journal_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JournalPage extends StatefulWidget{
  const JournalPage({Key? key}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  bool _isLoading = false;
  late bool _isSearchBarShow = false;
  late String query;
  var journalx = "a";
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: tProv.mode.scaffoldBackgroundColor,
      appBar: AppBar(
        title: _isSearchBarShow == false ?
        Text("Journal",
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
            child: _isSearchBarShow ?
            CloseButton(onPressed: () {
              _isSearchBarShow = false;
              this.query = '';
              },) :
            Icon(Icons.search),
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent
            ),
          )
        ], systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body:
      FutureBuilder(
        future: Provider.of<JournalProvider>(context).loadJournals(),
        builder:(context, journals){
          return journals.hasData ?
              Container(
                  child:
                  (journals.data as List<Journal>).isEmpty ?
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Journal",
                            style: tProv.mode.textTheme.bodyText2
                        ),
                      ],
                    ),
                  ) :
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: tProv.mode.primaryColor,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                                MediaQuery.of(context).size.width,
                                24
                            )
                          )
                        ),
                        child: Container(
                          padding: EdgeInsets.only(top: 90, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Your Journal Status',
                              style: tProv.mode.textTheme.bodyText2!.copyWith(
                                color: Colors.grey.shade100
                              ),
                              ),
                              Text('${(journals.data as List<Journal>).length}',
                                  style: TextStyle(
                                  color: tProv.mode.colorScheme.secondary,
                                  fontSize: 50
                              ),
                              ),
                              Text('${(journals.data as List<Journal>).length > 1 ? 'Journals' : 'Journal'} ',
                              style: TextStyle(
                                color: tProv.mode.colorScheme.secondary,
                                fontSize: 50
                              ),
                              ),
                              Text('Last update '
                                  '${formatter.format(
                                  (journals.data as List<Journal>)[0].createdTime)}',
                                style: tProv.mode.textTheme.bodyText2!.copyWith(
                                  color: Colors.grey.shade100,
                                  fontSize: 10
                                ),
                              )
                              // Container(
                              //   height: 50,
                              //   width: MediaQuery.of(context).size.width,
                              //   margin: EdgeInsets.only(left: 24, right: 24),
                              //   padding: EdgeInsets.only(left: 24, right: 24),
                              //   decoration: BoxDecoration(
                              //     color: Colors.grey.shade100,
                              //     borderRadius: BorderRadius.horizontal(
                              //       left: Radius.elliptical(50, 100),
                              //       right: Radius.elliptical(50, 100)
                              //     )
                              //   ),
                              //   child: TextFormField(
                              //     textAlign: TextAlign.center,
                              //     decoration: InputDecoration(
                              //       border: InputBorder.none
                              //     ),
                              //     onChanged: onChangedQuery,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 24, right: 24, top: 16),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount:
                            (journals.data as List<Journal>).length,
                            itemBuilder: (context, index){
                              return (journals.data as List<Journal>)[index].title.toLowerCase().contains(this.query) ||
                                  (journals.data as List<Journal>)[index].description.toLowerCase().contains(this.query) ?
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => JournalDetail(journalId: (journals.data as List<Journal>)[index].id!),
                                  ));
                                },
                                child: Card(
                                  color: Color(int.parse((journals.data as List<Journal>)[index].color)),
                                  child: ListTile(
                                    title: Text((journals.data as List<Journal>)[index].title.toString(), style: TextStyle(color: Color(0xFFE0F2F1),),),
                                    subtitle: Text(formatter.format((journals.data as List<Journal>)[index].createdTime).toString(), style: TextStyle(color: Color(0xFFE0F2F1),),),
                                    leading: Text((journals.data as List<Journal>)[index].id.toString(), style: TextStyle(color: Color(0xFFE0F2F1),),),
                                  ),
                                ),
                              ):Container();
                            }
                        ),
                      ),
                    ],
                  )
              ): Text(journals.connectionState.toString());
          },
      ),
      floatingActionButton:
      FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white,),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => JournalAdd(),
            )
            );
          }
      ),
    );
  }
}