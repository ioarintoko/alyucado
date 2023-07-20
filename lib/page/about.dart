import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Text('About Page',
          style: TextStyle(
            color: tProv.mode.colorScheme.secondary,
          ),),
        backgroundColor: tProv.mode.primaryColor, systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/Logo.jpg'
                  ),
                ),
                SizedBox(height: 10,),
                Text('Made by Bramantio Galih',
                  style: tProv.mode.textTheme.bodyText2!.copyWith(
                    color: Colors.grey.shade100
                  ),
                  textAlign: TextAlign.left,
                ),
                Text('@2022',
                  style: tProv.mode.textTheme.bodyText2!.copyWith(
                      color: Colors.grey.shade100
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.grey.shade100
                  ),
                  onPressed: () => showLicence(context),
                  child: Text('Licence'),
                ),
                SizedBox(height: 30,),
                Text(
                  'The reason i made this app is to fill my personal need.'
                  ' Since I got burnout, things are different and i need something to remind my focus.',
                style: tProv.mode.textTheme.bodyText2!.copyWith(
                  color: Colors.grey.shade100
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                Text.rich(
                TextSpan(
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Then I got an idea to made alyucado, or '),
                      TextSpan(text: 'ALL YOU CAN DO.', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' When made alyucado, I learn Provider, sqflite, and other widget as well.')
                    ]
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                Text.rich(
                  TextSpan(
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'It is fun to made mobile app in '),
                        TextSpan(text: 'FLUTTER WAY', style: TextStyle(fontWeight: FontWeight.bold)),
                        ]
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showLicence(BuildContext context) {
    showLicensePage(
        context: context,
        applicationName: 'Alyucado',
        applicationIcon: Image.asset('assets/Logo.jpg', width: 48, height: 48,)
    );
  }
}
