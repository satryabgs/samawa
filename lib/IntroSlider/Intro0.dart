import 'package:flutter/material.dart';
import 'Intro1.dart';
import 'Intro2.dart';
import 'Intro3.dart';
import 'Intro4.dart';

class Intro0 extends StatefulWidget {
  @override
  _Intro0State createState() => _Intro0State();
}

class _Intro0State extends State<Intro0> {
  int currentPage = 0;
  PageController controller = PageController();
  List<Widget> myIntro = [Intro1(), Intro2(), Intro3(), Intro4()];


  _onChanged(int index){
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(children: <Widget>[
        PageView.builder(
          controller:controller,
          onPageChanged: _onChanged,
          itemBuilder: (context, position) => myIntro[position],
          itemCount: myIntro.length,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children:<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(myIntro.length, (int index){
                return AnimatedContainer(duration: Duration(milliseconds: 300),
                height: 10.0,
                width: (index == currentPage) ? 30: 10 ,
                margin: EdgeInsets.symmetric(horizontal:5, vertical:20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (index== currentPage)?Colors.black :Colors.grey
                ),
                );
              }),
              )
          ]
        )
      ]),
    );
  }
}
