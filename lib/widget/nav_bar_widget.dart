import 'package:alyucado/page/calories/calories_page.dart';
import 'package:alyucado/page/finance/finance_page.dart';
import 'package:alyucado/page/journal/journal_page.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    tProv.getTheme();

    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => JournalPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.credit_card_rounded,
                    size: 30,),
                  Text("Finance", style: TextStyle(
                      color: tProv.mode.colorScheme.secondary,
                      fontSize: 12, fontWeight: FontWeight.w500),)
                ],
              ),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => JournalPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.list_alt,size: 30,),
                  Text("Agenda", style: TextStyle(
                      color: tProv.mode.colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),)
                ],
              ),
            ),
          ),
          Container(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => JournalPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.book,size: 30,),
                      Text("Journal", style: TextStyle(
                          color: tProv.mode.colorScheme.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CaloriesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calculate, size: 30,),
                  Text("Calories", style: TextStyle(
                      color: tProv.mode.colorScheme.secondary,
                      fontSize: 12, fontWeight:
                  FontWeight.w500),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}