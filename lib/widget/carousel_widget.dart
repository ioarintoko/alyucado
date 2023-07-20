import 'package:alyucado/model/journal.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({
    Key? key,
  required this.journals
  }) : super(key: key);
  final List<Journal> journals;
  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: CarouselSlider(
        options: CarouselOptions(height: 200.0),
        items: journals.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87),
                      color: Colors.white12
                  ),
                  child: Center(
                      child:
                        Column(
                          children: [
                            Text('${journals[journals.indexOf(item)].title}',
                              style: tProv.mode.textTheme.bodyText1!.copyWith(
                                fontSize: 20,
                              )
                            ),
                            SizedBox(height: 5,),
                            Text('${journals[journals.indexOf(item)].description.length >50 ?
                            journals[journals.indexOf(item)].description.substring(0,50) :
                            journals[journals.indexOf(item)].description}...',
                              style: tProv.mode.textTheme.bodyText2
                            ),
                          ],
                        )
                  )
              );
            },
          );
        }).toList(),
      ),
    );
  }
}