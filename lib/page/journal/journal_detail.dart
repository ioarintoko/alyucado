import 'package:alyucado/model/journal.dart';
import 'package:alyucado/page/journal/journal_edit.dart';
import 'package:alyucado/provider/journal_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JournalDetail extends StatefulWidget {
  const JournalDetail({
    Key? key,
    required this.journalId,
  }) : super(key: key);

  final int journalId;

  @override
  _JournalDetailState createState() => _JournalDetailState();
}

class _JournalDetailState extends State<JournalDetail> {
  late Journal journald;

  bool _isLoading = false;
  late String query = '';
  late final ValueChanged<String> onChangedQuery;
  final color = "Colors.red";
  var formatter = new DateFormat('dd-MM-yyyy, hh:mm');
  static GlobalKey previewContainer = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
      query = '';
      onChangedQuery = (query) => setState(() =>
      this.query = query);
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
          appBar: AppBar(
            title: Text("Detail",
              style: TextStyle(
                  color: tProv.mode.colorScheme.secondary
              ),
            ),
            backgroundColor: tProv.mode.primaryColor,
            shadowColor: Colors.transparent,
            actions: [
              IconButton(
                  onPressed: () async{
                    Navigator.of(context).pop();
                    await Provider.of<JournalProvider>(context, listen: false)
                        .deleteJournal(widget.journalId);
                  },
                  icon: Icon(Icons.delete)
              ),
              IconButton(
                  onPressed: () async{
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => JournalEdit(journalId:widget.journalId)
                        )
                    );
                  },
                  icon: Icon(Icons.edit)
              ),
            ], systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: _isLoading == false ?
          Center(
              child: Text("No Data",
              style: tProv.mode.textTheme.bodyText2,
              )
          ) :
          RepaintBoundary(
            key: previewContainer,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: Provider.of<JournalProvider>(context)
                        .loadSelectedJournals(widget.journalId),
                    builder: (context, journals){
                      if(journals.hasData){
                        var data = (journals.data! as List<Journal>)[0];
                      return Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 35, left: 15, right: 15),
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                height: MediaQuery.of(context).size.height * 0.75,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(56)),
                                  child: Card(
                                    color: Color(int.parse(data.color)),
                                    elevation: 20,
                                    child: Container(
                                      margin: EdgeInsets.all(25),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(data.title, style: TextStyle(
                                            color: Colors.grey.shade100,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                              formatter.format(data.createdTime),
                                            style: TextStyle(color: Colors.grey.shade100),
                                          ),
                                          SizedBox(height: 15,),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Text(data.description, style: TextStyle(
                                                color: Colors.grey.shade100,
                                                fontSize: 20
                                              ),),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                      }else{
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
  }
}