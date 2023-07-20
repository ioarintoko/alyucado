import 'dart:io';

import 'package:alyucado/model/profile.dart';
import 'package:alyucado/page/profile/profile_edit.dart';
import 'package:alyucado/provider/profile_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    // var pProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text('Profile',
        style: TextStyle(color: tProv.mode.colorScheme.secondary),
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileEdit(),
                ));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                onPrimary: Colors.white
              ),
              child: Icon(Icons.edit),

          )
        ], systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Provider.of<ProfileProvider>(context).loadProfiles(),
          builder: (context, profile){
            var profiles;
            if(profile.hasData){
              profiles = profile.data as List<Profile>;
            }
          return profile.hasData ?
          Container(
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.only(top: 40),
              child: profiles.isEmpty ?
              Container(
                child: Center(
                  child: Text('No Data',
                  style: tProv.mode.textTheme.bodyText2,
                  ),
                ),
              ) :
              Center(
                child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Positioned(
                          top: 90,
                          child: Container(
                            padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height/2,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                elevation: 0,
                                color: tProv.mode.cardColor,
                                child: Container(
                                  padding: EdgeInsets.only(top: 80),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(profiles[0].name,
                                          style: tProv.mode.textTheme.bodyText1!.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          )
                                          ),
                                          Text(profiles[0].email,
                                            style: tProv.mode.textTheme.bodyText2!.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            )
                                          ),
                                          SizedBox(height: 20,),
                                          Text('Passcode',
                                            style: tProv.mode.textTheme.bodyText2!.copyWith(
                                                fontSize: 16,
                                                color: tProv.mode.textTheme.headline1!.color,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          Text(profiles[0].password.toString(),
                                            style: tProv.mode.textTheme.bodyText2!.copyWith(
                                                fontSize: 36,
                                                color: tProv.mode.textTheme.headline1!.color,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                            ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 0,
                                offset: Offset.zero
                              ),
                            ],
                            border: Border.all(
                              width: 0,
                              style: BorderStyle.solid,
                              color: tProv.mode.primaryColor.withOpacity(0.788)
                            ),
                            shape: BoxShape.circle,
                            color: tProv.mode.primaryColor,
                          ),
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.width,
                          child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    child: Image.file(
                                        File(profiles[0].picture),
                                      fit: BoxFit.fill,
                                      height: 130,
                                      width: 130,
                                    ),

                                ),
                              ),
                        ),
                      ],
                      fit: StackFit.passthrough,
                    ),
              ),
            ):Container();
          }
        ),
      ),
    );
  }
}
