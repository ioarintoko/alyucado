import 'dart:io';

import 'package:alyucado/model/profile.dart';
import 'package:alyucado/provider/profile_provider.dart';
import 'package:alyucado/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
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
      this.pProv = Provider.of<ProfileProvider>(context, listen: false);
      this.id = this.pProv.items[0].id;
      this.name = this.pProv.items[0].name;
      this.email = this.pProv.items[0].email;
      this.password = this.pProv.items[0].password.toString();
      this.picture = this.pProv.items[0].picture;
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
    var tProv = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: tProv.mode.primaryColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: tProv.mode.primaryColor,
        title: Text('Edit Profile',
          style: TextStyle(color: tProv.mode.colorScheme.secondary),
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
        // actions: [
        //   ElevatedButton(
        //       onPressed: editProfile,
        //       child: Icon(Icons.check, color: Colors.white)
        //   )
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: editProfile,
        child: Icon(Icons.check, color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          padding: EdgeInsets.all(10),
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
                          Image.file(
                            File(this.picture),
                            fit: BoxFit.fill,
                            height: 130,
                            width: 130,
                          )
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
                      style: tProv.mode.textTheme.bodyText2!.copyWith(
                        color: Colors.grey.shade100
                      ),
                      textAlign: TextAlign.center,
                      autofocus: true,
                      initialValue: this.name,
                      onChanged: onChangedName,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      style: tProv.mode.textTheme.bodyText2!.copyWith(
                          color: Colors.grey.shade100
                      ),
                      textAlign: TextAlign.center,
                      initialValue: this.email,
                      onChanged: onChangedEmail,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      style: tProv.mode.textTheme.bodyText2!.copyWith(
                          color: Colors.grey.shade100
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
    if(this.password.length < 6){
      const snackBar = SnackBar(
        content: Text('Password Should Be 6 Characters',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.green,
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      print(this.id);
      await Provider.of<ProfileProvider>(context, listen: false).updateProfile(
          Profile(
              id: this.id,
              name: this.name,
              email: this.email,
              password: int.parse(this.password),
              picture: this.image != null ? this.image!.path : this.picture
          )
      );
      Navigator.of(context).pop();
    }
  }
}
