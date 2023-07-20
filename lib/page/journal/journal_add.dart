import 'package:alyucado/model/journal.dart';
import 'package:alyucado/provider/journal_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
class JournalAdd extends StatefulWidget {
  const JournalAdd({Key? key}) : super(key: key);

  @override
  _JournalAddState createState() => _JournalAddState();
}

class _JournalAddState extends State<JournalAdd> {
  late String titles;
  late String description;
  List<Color> colorx = [
    Color(0xff800000),
    Color(0xff123456),
    Color(0xff654321),
  ];
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  changeColor(Color color) {
    setState(() => pickerColor = color);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titles = '';
    description = '';
  }
  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        title: Text("Add Journal",
          style: TextStyle(
              color: tProv.mode.colorScheme.secondary,
              fontWeight: FontWeight.bold),),
        backgroundColor: tProv.mode.primaryColor, systemOverlayStyle: SystemUiOverlayStyle.light,
        shadowColor: Colors.transparent,
        // actions: [
        //   ElevatedButton(
        //       onPressed: saveJournal,
        //       child:
        //       Text("Save")),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: saveJournal,
        child: Icon(Icons.check, color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    ) ,
                    onChanged: (titles) => setState(() => this.titles = titles)
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(pickerColor.value),
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
                          pickerColor: pickerColor,
                          onColorChanged: (Color color){
                            setState(() {
                              pickerColor = color;
                            });
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
                      color: Colors.grey.shade100,
                      ),
                      border: InputBorder.none
                    ) ,
                    onChanged: (description) => setState(() => this.description = description)
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveJournal() async{
    final journal = Journal(
      title: titles,
      color: pickerColor.value.toString(),
      description: description,
      createdTime: DateTime.now()
    );
    await Provider.of<JournalProvider>(context, listen: false).addNewJournal(journal);

    Navigator.of(context).pop();
  }
}
