import 'dart:async';

import 'package:alyucado/page/journal/journal_page.dart';
import 'package:alyucado/page/sign_in.dart';
import 'package:alyucado/page/sign_up.dart';
import 'package:alyucado/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var pProv;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      this.pProv = Provider.of<ProfileProvider>(context, listen: false);
      this.pProv.loadProfiles();
    });
    Timer(Duration(seconds: 3), () => Navigator.pushReplacement(context, 
    MaterialPageRoute(builder: (context) => this.pProv.items.length > 0 ? SignIn() : SignUp())
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff903030),
            Color(0xff000040),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomRight
        )
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 30,),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
              child: 
              Image.asset(
                'assets/Logo.jpg', 
                height: 150, 
                width: 150,
              )
          ),
          // Text('Alyucado',
          //   style: TextStyle(
          //       color: Colors.white70,
          //       decoration: TextDecoration.none
          //   ),
          // ),
          CircularProgressIndicator(
            color: Color(0xff000040),
            backgroundColor: Color(0xff903030),
          )
        ],
      ),
    );
  }
}
