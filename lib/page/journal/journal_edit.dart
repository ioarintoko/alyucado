import 'package:alyucado/model/journal.dart';
import 'package:alyucado/provider/journal_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class JournalEdit extends StatefulWidget {
  final int? journalId;
  const JournalEdit(
      {Key? key,
        required this.journalId
      }
      ) : super(key: key);
  @override
  _JournalEditState createState() => _JournalEditState();
}

class _JournalEditState extends State<JournalEdit> {
  late final journalProvider = Provider.of<JournalProvider>(context, listen: false).items.where((element) => element.id == widget.journalId).toList();
  late String color;
  late Color pickerColor;
  late String titles;
  late String description;
  late DateTime createdTime;
  late final ValueChanged<String> onChangedColor;
  late final ValueChanged<String> onChangedTitles;
  late final ValueChanged<String> onChangedDescription;
  late final ValueChanged<DateTime> onChangedCreated;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print(journalProvider);
    color = journalProvider[0].color;
    print(color);
    pickerColor = Color(int.parse(color));
    print(pickerColor);
    titles = journalProvider[0].title;
    description = journalProvider[0].description;
    createdTime = journalProvider[0].createdTime;
    _isLoading = true;
    onChangedColor = (color) => setState(() =>
      this.color = color);
    onChangedTitles = (titles) => setState(() =>
      this.titles = titles);
    onChangedDescription = (description) => setState(() =>
      this.description = description);
    onChangedCreated = (createdTime) => setState(() =>
    this.createdTime = createdTime);
  }
  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        title: Text("Edit Journal",
          style: TextStyle(
              color: tProv.mode.colorScheme.secondary,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: tProv.mode.primaryColor, systemOverlayStyle: SystemUiOverlayStyle.light,
        shadowColor: Colors.transparent,
        // actions: [
        //   ElevatedButton(
        //       onPressed: editJournal,
        //       child:
        //       Text("Save")),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: editJournal,
        backgroundColor: Colors.green,
        child: Icon(Icons.check, color: Colors.white,),
      ),
      body:
          SingleChildScrollView(
          child:
          Consumer<JournalProvider>(
            builder: (context, journal, _) =>
            journal.items.where((element) => element.id == widget.journalId) != null ?
            Container(
              padding: EdgeInsets.all(20),
                child: SizedBox(
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: true,
                          initialValue: titles,
                          style: tProv.mode.textTheme.bodyText1!.copyWith(
                            color: Colors.grey.shade100
                          ),
                          decoration: InputDecoration(
                            hintText: "Title",
                            hintStyle: tProv.mode.textTheme.bodyText1!.copyWith(
                                color: Colors.grey.shade100
                            ),
                            border: InputBorder.none
                          ),
                          onChanged: onChangedTitles,
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: pickerColor,
                              onPrimary: Colors.white
                          ),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: BlockPicker(
                                availableColors: [
                                  Color(0xff00022e),
                                  Color(0xff044a05),
                                  Color(0xff4a0100),
                                  Color(0xff280137),
                                  Color(0xff442200),
                                  Color(0xff0047ab),
                                  Color(0xff800020),
                                  Color(0xfff4c430),
                                  Color(0xff355e3b),
                                  Color(0xff008080),
                                  Color(0xff003366),
                                  Color(0xff612302),
                                  Color(0xff32174d),
                                  Color(0xffd4af37),
                                  Color(0xffee7600),
                                  Color(0xff8f8b66),
                                  Color(0xffb7410e),
                                  Color(0xff66023c),
                                  Color(0xff002147),
                                  Color(0xff343434),
                                  Color(0xffe1ad01),
                                  Color(0xff808000),
                                  Color(0xffdaa520),
                                  Color(0xff2a52be),
                                ],
                                pickerColor: Color(int.parse(journal.items[0].color)),
                                onColorChanged: (Color color){
                                  setState(() {
                                    pickerColor = color;
                                  });
                                  print(color);
                                },
                              ),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                        onPrimary: Colors.white
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text("Done"))
                              ],
                            ),
                          ),
                          child: Text("Pilih Warna"),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          initialValue: description,
                          maxLines: 7,
                          style: tProv.mode.textTheme.bodyText2!.copyWith(
                              color: Colors.grey.shade100
                          ),
                          decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: tProv.mode.textTheme.bodyText2!.copyWith(
                                color: Colors.grey.shade100
                            ),
                            border: InputBorder.none
                          ),
                          onChanged: onChangedDescription,
                        ),
                        Visibility(
                          visible: false,
                          child: TextFormField(
                            initialValue: createdTime.toString(),
                            maxLines: 7,
                            decoration: InputDecoration(
                              hintText: "Description",
                            ) ,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ): Text("Not There"),
          ),
        )
      );
  }

  void editJournal() async{
    await Provider.of<JournalProvider>(context, listen: false).updateJournal(Journal(
        id: widget.journalId,
        color: pickerColor.value.toString(),
        title: titles,
        description: description,
        createdTime: createdTime));
    Navigator.of(context).pop();
    print(journalProvider[0].id);
  }
}
