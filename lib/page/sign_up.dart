import 'dart:io';

import 'package:alyucado/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

import '../model/profile.dart';
import '../provider/profile_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File? image;
  var picture;
  var imagePath;
  var id;
  var name;
  var email;
  late String password;
  late final ValueChanged<String> onChangedName;
  late final ValueChanged<String> onChangedEmail;
  late final ValueChanged<String> onChangedPassword;
  var con;
  var pProv;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      this.name = '';
      this.email = '';
      this.password = '';
      this.picture = '';
      onChangedName = (name) => setState(() =>
      this.name = name);
      onChangedEmail = (email) => setState(() =>
      this.email = email);
      onChangedPassword = (password) => setState(() =>
      this.password = password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: saveProfile,
        child: Icon(Icons.check, color: Colors.white,),
      ),
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
        padding: EdgeInsets.only(top: 50, left: 30, right: 30),
        child: Card(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: editPhoto,
                      child: CircleAvatar(
                        radius: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: this.image != null ?
                          Image.file(
                            this.image!,
                            fit: BoxFit.fill,
                            height: 130,
                            width: 130,
                          ) :
                              Icon(Icons.camera_alt)
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                        // padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
                        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.pressed)) return Colors.red; // <-- Splash color
                        }),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            fontSize: 15,
                          )
                      ),
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                      autofocus: true,
                      initialValue: this.name,
                      onChanged: onChangedName,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            fontSize: 15,
                          )
                      ),
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                      initialValue: this.email,
                      onChanged: onChangedEmail,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 15,
                        )
                      ),
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      initialValue: this.password,
                      onChanged: onChangedPassword,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future editPhoto() async {
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanently = await saveImagePermanently(image.path);
      print(imagePermanently.path);
      setState(() {
        this.image = imagePermanently;
      });
    } on PlatformException catch(e) {
      print('Failed to load image cause : $e');
    }

  }

  Future<File> saveImagePermanently(String path) async{
    final directory = await getApplicationDocumentsDirectory();
    final name = Path.basename(path);
    final image = File('${directory.path}/$name');
    print(image.path);
    return File(path).copy(image.path);
  }

  Future<void> editProfile() async{
    await Provider.of<ProfileProvider>(context, listen: false).addNewProfile(
        Profile(
            name: this.name,
            email: this.email,
            password: int.parse(this.password),
            picture: this.image != null ? this.image!.path : this.picture
        )
    );
    Navigator.of(context).pop();
  }

  void saveProfile() async{
    if(this.image == null || this.name == '' || this.email == '' || this.password == ''){
      const snackBar = SnackBar(
        content: Text('Please Fill All Form',
        style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.green,
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    await Provider.of<ProfileProvider>(context, listen: false).addNewProfile(
      Profile(
          name: this.name,
          email: this.email,
          password: int.parse(this.password),
          picture: this.image!.path
      )
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Home())
    );
  }
}

