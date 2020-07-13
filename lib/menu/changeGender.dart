import 'package:flutter/material.dart';
import 'package:samawa/database/dbHelperUser.dart';
import '../models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class ChangeGender extends StatefulWidget {
  @override
  _ChangeGenderState createState() => _ChangeGenderState();
}

class _ChangeGenderState extends State<ChangeGender> {
  DbHelperUser dbHelperUser = DbHelperUser();
  User user;
  String name = "";
  int _selectedGender, check;

  @override
  void initState() {
    super.initState();
    final Future<Database> dbFuture = dbHelperUser.initDbUser();
    dbFuture.then((database) {
      Future<List<User>> userListFuture = dbHelperUser.getUserList();
      userListFuture.then((userList) {
        setState(() {
          this.name = userList[0].name;
          this._selectedGender = userList[0].gender;
          check =userList[0].gender;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Change Gender',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'AvenirPro',
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover)),
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                _buildGender(0),
                SizedBox(width:20.0),
                _buildGender(1)
              ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () {
                    user = User(0,name, _selectedGender);
                    editContact(user);
                    Navigator.pop(context);
                  },
                 color: _selectedGender == check? Colors.grey:Colors.green,
                  textColor: Colors.white,
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'AvenirPro',
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void editContact(User object) async {
    await dbHelperUser.update(object);
  }
  Widget _buildGender(int index) {
  String gambar = "assets/images/", gambarGelap;
  String gender;
  if (index == 0){
    gambarGelap = gambar +"man1.png";
    gambar=gambar+"man0.png";
    gender = "Male";
  }else{
    gambarGelap = gambar +"woman1.png";
    gambar=gambar+"woman0.png";
    gender = "Female";
  }
  return GestureDetector(
    onTap: (){
      setState(() {
        _selectedGender = index;
      });
    },
      child: Container(
      width: 150.0,
      height: 225.0,
      decoration: BoxDecoration(
          color: _selectedGender == index ? Colors.grey[100] : Colors.grey[350],
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(color: Colors.black26, offset: _selectedGender == index ? Offset(0.0, 2.0):Offset(0.0,0.0))
          ]),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: _selectedGender == index ? AssetImage(gambar) : AssetImage(gambarGelap),
              height: _selectedGender == index ? 150.0 : 120.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              gender,
              style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 14.0,
                  letterSpacing: 0.5,
                  color: Colors.black54),
            ),
          ]),
    ),
  );
}
}
