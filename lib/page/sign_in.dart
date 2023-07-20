import 'package:alyucado/page/home.dart';
import 'package:alyucado/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var pass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState((){
      this.pass = '';
      if(this.pass.length == 6){
        this.pass = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80,),
            Text('Masukkan Sandi',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                decoration: TextDecoration.none
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 90,
              child: Text(this.pass,
              style: TextStyle(
                color: Colors.white70,
                decoration: TextDecoration.none,
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),
              )
            ),
            SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('1');
                            });
                          },
                          child:
                            Text('1',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 40
                            ),
                            )
                      ),
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('2');
                            });
                          },
                          child:
                          Text('2',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('3');
                            });
                          },
                          child:
                          Text('3',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('4');
                            });
                          },
                          child:
                          Text('4',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('5');
                            });
                          },
                          child:
                          Text('5',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('6');
                            });
                          },
                          child:
                          Text('6',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('7');
                            });
                          },
                          child:
                          Text('7',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('8');
                            });
                          },
                          child:
                          Text('8',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('9');
                            });
                          },
                          child:
                          Text('9',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child:
                          Text('',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                            setState((){
                              addPass('0');
                            });
                          },
                          child:
                          Text('0',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                            setState((){
                              this.pass = '';
                            });
                          },
                          child:
                          Text('X',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addPass(String s){
    var password = Provider.of<ProfileProvider>(context, listen: false);
    password.loadProfiles();
    setState((){
      this.pass += s;
      if(this.pass.length == 6) {
        print(password.items[0].password.runtimeType);
        if(int.parse(this.pass) == password.items[0].password){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Home())
          );
        }
        if(int.parse(this.pass) != password.items[0].password){
          const snackBar = SnackBar(
            content: Text('Password Salah',
              style: TextStyle(color: Colors.white70),
            ),
            backgroundColor: Colors.green,
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          this.pass = '';
        }
      }
    });
  }
}
