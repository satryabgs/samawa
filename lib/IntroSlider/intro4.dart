import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database/dbHelperUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro4 extends StatefulWidget {
  @override
  _Intro4State createState() => _Intro4State();
}

class _Intro4State extends State<Intro4> {
  DbHelperUser dbHelperUser = DbHelperUser();
  User user;
  bool check = true;
  TextEditingController nameController = TextEditingController();

  int _selectedGender = 0;
  @override
  Widget build(BuildContext context) {
    if(user !=null){
      nameController.text = user.name;
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
          decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
          child: SafeArea(
            child: Center(
      child: Column(
        children: [
          SizedBox(height: 60.0),
          Center(
            child: Text(
              'Samawa Friend',
              style: TextStyle(
                  fontFamily: 'AvenirPro',
                  letterSpacing: 1.5,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 20.0),
          Center(
            child: Text(
              'We have a friend for you!\nFirst let us know your name',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Avenir',
                  letterSpacing: 0.5,
                  fontSize: 18.0,
                  color: Colors.black45),
            ),
          ),
          SizedBox(height: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 272.0,
                child: Theme(
                  data: new ThemeData(
                    primaryColor: Colors.black54,
                    primaryColorDark: Colors.black,
                  ),
                  child: TextField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontFamily:'Avenir', letterSpacing:2.5),
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
                  ),onChanged: (value){
                      setState(() {
                        check = nameController.text.isEmpty;
                      });
                    },),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Center(
            child: Text('Then, pick a gender for your friend',
                style: TextStyle(
                    fontFamily: 'AvenirPro',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54)),
          ),
          SizedBox(height: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                _buildGender(0),
                SizedBox(width:20.0),
                _buildGender(1)
              ]),
            ],
          ),
          SizedBox(height: 30.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if(check){
                    //
                  }else{
                    user = User(0,nameController.text, _selectedGender);
                    addContact(user);
                    savePref(false);
                    Navigator.pushReplacementNamed(context,'/welcome');
                  }
                },
                child: Container(
                  height: 48.0,
                  width: 214.0,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: check?Colors.grey:Colors.black45),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                      child: Text(
                    'Get Started',
                    style: TextStyle(
                        color: check?Colors.grey:Colors.black,
                        fontFamily: 'Avenir',
                        fontSize: 16.0),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
            ),
          ),
        ),
    );
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

//buat contact
  void addContact(User object) async {
    await dbHelperUser.insert(object);
  }

  savePref(bool value) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {

      preferences.setBool("first", value);

    });

  }

}


// Route _createRoute() {
//   return PageRouteBuilder(
//     transitionDuration: Duration(milliseconds: 1000),
//     pageBuilder: (context, animation, secondaryAnimation) => Welcome(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return FadeTransition(
//         opacity: animation,
//         child: child,
//       );
//     },
//   );
// }