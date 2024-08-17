import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tak_toe/colors.dart';
import 'package:tic_tak_toe/screen/home_screen.dart';

class StartScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _StartScreenState() ;
}

class _StartScreenState extends State<StartScreen> {

  var player1Controller = TextEditingController();
  var player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title:Text("Tie Tac Toe" , style:TextStyle(fontWeight: FontWeight.bold , fontSize: 35 , fontFamily: "myBox"),), centerTitle: true,
     backgroundColor: appAppBar,
     ),
     body: Container(
       height: double.infinity,
       width: double.infinity,
       color:spColorTTT,
       child: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             SizedBox(height: 30,),
         
             Container(
               height:300,
               width: 300,
               child: Image.asset("assets/images/tic-tac-toe.png"),) ,

             SizedBox(height: 20,) ,

             /////////////////// Player 1 /////////////
         
             Container(
               margin: EdgeInsets.all(16),
               child: TextField(
                 controller: player1Controller,
                 decoration: InputDecoration(
                   focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(12) ,
                     borderSide: BorderSide(width: 2 , color: Colors.greenAccent)
                   ) ,
                   enabledBorder: OutlineInputBorder(
                     borderSide: BorderSide(width: 2 ,color: Colors.greenAccent) ,
                     borderRadius: BorderRadius.circular(12)
                   ) ,
                   disabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(12) ,
                     borderSide: BorderSide(width: 2 , color: Colors.greenAccent)
                   ) ,
                     label: Text("Player First" , style: TextStyle(fontSize: 25 ,
                         fontWeight: FontWeight.bold ,
                         fontFamily: "myFonts" ,
                         color: Colors.deepPurple),
                     )
                 ),
                 style: TextStyle(fontSize: 30 , fontFamily: "myBoxNew" ),
               ),
             ),
         
             SizedBox(height: 20,) ,

             ///////////// Player 2 /////////////////////
             Container(
               margin: EdgeInsets.all(16),
               child: TextField(
                 controller: player2Controller,
                 decoration: InputDecoration(
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12) ,
                       borderSide: BorderSide(width: 2 , color: Colors.greenAccent)
                   ) ,
                   enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(width: 2 ,color: Colors.greenAccent) ,
                       borderRadius: BorderRadius.circular(12)
                   ) ,
                   disabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12) ,
                       borderSide: BorderSide(width: 2 , color: Colors.greenAccent)
                   ) ,
                   label: Text("Player Second" , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold , fontFamily: "myFonts" , color: Colors.deepPurple),)
                 ),
                 style: TextStyle(fontSize: 30 , fontFamily: "myBoxNew" ),
               
               ),
             ),
         
             SizedBox(height: 30,) ,
         
             Container(
               width: 300,
                 height: 70,
                 child: FloatingActionButton(onPressed: (){
                   Navigator.of(context).push(_createRoute(HomeScreen(player1Controller.text.toString() , player2Controller.text.toString()
                   )
                   )
                   ) ;
                 } , child: Text("Start Game" , style: TextStyle(fontSize: 30 , color: Colors.pink , fontFamily: "myBoxNew"),),))
           ],
         ),
       ),
     ),
   ) ;
  }

}

Route _createRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}