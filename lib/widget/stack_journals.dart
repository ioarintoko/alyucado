import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/journal.dart';
import '../provider/journal_provider.dart';
import '../provider/theme_provider.dart';

class StackJournals extends StatelessWidget {
  const StackJournals({
    Key? key,
    required this.tProv,
    required this.formatter,
  }) : super(key: key);

  final ThemeProvider tProv;
  final DateFormat formatter;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    tProv.mode.primaryColor,
                    tProv.mode.scaffoldBackgroundColor
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24)
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(
                    top: 16,
                    left: 16
                ),
                child: Text('Journals',
                  style: tProv.mode.textTheme.bodyText1!.copyWith(
                      color: Colors.grey.shade100
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 56,
            left: 56,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FutureBuilder(
                  future: Provider.of<JournalProvider>(context, listen: false).loadJournals(),
                  builder: (context, journal){
                    if(journal.connectionState == ConnectionState.done){
                      print('ada');
                      if((journal.data as List<Journal>).isNotEmpty == true){
                        var jou = journal.data as List<Journal>;
                        return Container(
                            height: MediaQuery.of(context).size.height*0.25,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child:
                            ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: jou.length < 4 ? jou.length : 4,
                              itemBuilder: (context, index){
                                return Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(right: 10),
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.elliptical(
                                              MediaQuery.of(context).size.width,
                                              24
                                          )
                                      ),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(int.parse(jou[index].color)),
                                            Colors.white
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0.85,0.95]
                                      )
                                  ),
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        jou[index].title.length > 10 ?
                                        jou[index].title.substring(0,10):
                                        jou[index].title,
                                        style: tProv.mode.textTheme.bodyText1!.copyWith(
                                            color: Colors.grey.shade100
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(formatter.format(jou[index].createdTime),
                                        style: tProv.mode.textTheme.bodyText2!.copyWith(
                                            color: Colors.grey.shade100
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        jou[index].description.length > 60 ?
                                        jou[index].description.substring(0,60) :
                                        jou[index].description,
                                        style: tProv.mode.textTheme.bodyText2!.copyWith(
                                            color: Colors.grey.shade100
                                        ),
                                        maxLines: 4,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                        );
                      }else{
                        return Container(
                          child: Text('No Data',
                          style: TextStyle(color: Colors.grey.shade100),
                          ),
                        );
                      }
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}