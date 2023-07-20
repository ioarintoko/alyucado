import 'dart:io';

import 'package:alyucado/page/about.dart';
import 'package:alyucado/page/profile/profile_page.dart';
import 'package:alyucado/provider/profile_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    var pProv = Provider.of<ProfileProvider>(context);
    pProv.loadProfiles();
    return Drawer(
      child:
        Container(
          color: tProv.mode.scaffoldBackgroundColor.withOpacity(0.9),
          height: 12,
          child:
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: tProv.mode.primaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(5)
                      ),
                  ),
                  child: SizedBox(
                      height: 191.5,
                      width: MediaQuery.of(context).size.width,
                      child:
                        Container(
                          padding: EdgeInsets.only(top: 55),
                            child:
                              Center(
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                          child: Image.file(
                                            File(pProv.items[0].picture),
                                            fit: BoxFit.fill,
                                            height: 130,
                                            width: 130,
                                          ),

                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(pProv.items[0].name,
                                        style: TextStyle(
                                            color: tProv.mode.colorScheme.secondary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),),
                                      Text(pProv.items[0].email,
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10
                                          )),
                                    ],
                                  )
                              )
                        )
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // elevation: 20,
                            primary: Colors.transparent,
                            onPrimary: tProv.mode.textTheme.headline1!.color,
                            shadowColor: Colors.transparent
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.account_circle_sharp, size: 55,),
                              Text("Profile")
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              onPrimary: tProv.mode.textTheme.headline1!.color,
                              shadowColor: Colors.transparent
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => AboutPage()),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.info_rounded, size: 55,),
                              Text("About")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
        ),
    );
  }
  }