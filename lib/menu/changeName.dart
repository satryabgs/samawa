import 'package:flutter/material.dart';
import 'package:samawa/database/dbHelperUser.dart';
import '../models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class ChangeName extends StatefulWidget {
  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  DbHelperUser dbHelperUser = DbHelperUser();
  TextEditingController nameController = TextEditingController();
  User user;
  String name = "";
  int gender = 0;
  bool check = false;

  @override
  void initState() {
    super.initState();
    final Future<Database> dbFuture = dbHelperUser.initDbUser();
    dbFuture.then((database) {
      Future<List<User>> userListFuture = dbHelperUser.getUserList();
      userListFuture.then((userList) {
        setState(() {
          this.name = userList[0].name;
          this.gender = userList[0].gender;
          nameController.text = name;
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
          'Change Name',
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
            children: [
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: nameController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontFamily: 'Avenir', letterSpacing: 2.5),
                    textCapitalization: TextCapitalization.words,
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "My Name",
                      labelText: 'My Name',
                      errorText: check?'Name can\'t be empty':null,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                    onChanged: (value){
                      setState(() {
                        check = nameController.text.isEmpty;
                      });
                    },),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () {
                    name = nameController.text;
                    user = User(0,name, gender);
                    print(user.name);
                    print('ini nama'+name);
                    editContact(user);
                    Navigator.pop(context);
                  },
                  color: check? Colors.grey:Colors.green,
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
}
