import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tak_toe/colors.dart';

class HomeScreen extends StatefulWidget{

  var playerFirstResiver ;
  var playerSecondResiver ;

  HomeScreen(this.playerFirstResiver , this.playerSecondResiver) ;

  @override
  State<StatefulWidget> createState() => _HomeScreenState() ;
}

class _HomeScreenState extends State<HomeScreen> {

  bool oTurn = true ;
  List<String> displayOX = ['','' ,'','','','','','',''] ;
  String resultDeclaration = "" ;
  int oScore = 0 ;
  int xScore = 0 ;
  int filledBoxes = 0 ;
  bool winnerFound = false ;


  List<int> matchColor = [];
  Color first = Colors.yellow ;
  Color second = Colors.greenAccent ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
          height: double.infinity,
          color: spColorTTT,

        child: Column(
          children: [
///////////////////////////// PART 1 ////////////////////// DIVIDE ///////////

          SizedBox(height: 15,),
            Expanded(
              flex: 1,
                child:Row(
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Container(
                            height: 50 ,
                            width: 50 ,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.greenAccent
                            ),
                            child: Center(
                                child: Text("O", style: TextStyle(fontWeight: FontWeight.bold , fontSize: 30 , fontFamily: "myBoxNew"),
                                )
                            )
                        ),


                        Container(
                           height: 50 ,
                          width: 220 ,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.greenAccent , width: 1),
                            boxShadow: [BoxShadow(color:  Colors.greenAccent , blurRadius: 10)],
                            color: Colors.white
                          ),
                            child: Center(
                                child: Text(widget.playerFirstResiver , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 30 , fontFamily: "myBox"),
                                )
                            )
                        ),

                        Container(
                            height: 50 ,
                            width: 50 ,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.greenAccent , width: 1),
                                boxShadow: [BoxShadow(color:  spBox , blurRadius: 10)],
                                color: Colors.white
                            ),
                            child: Center(
                                child: Text(oScore.toString()  , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 30 , fontFamily: "myBox"),
                                )
                            )
                        )


                      ],
                    )) ,
                  ],
                )
        ) ,

      ///////////////////  Box //////////////////  PART 2 ///////////////////////////
            Expanded(
              flex: 3,
                child:GridView.builder(
                  padding:EdgeInsets.symmetric(horizontal:10 , vertical: 10 ) ,
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3 ,
                      crossAxisSpacing: 10 ,
                    mainAxisSpacing: 10
                  ),
                  itemBuilder: (BuildContext context, int index) {

                    //////////// ON TAP ///////////
                    return GestureDetector(onTap: () {
                      _tapped(index);

                    },


                    child: Container(
                      decoration: BoxDecoration(
                        color: matchColor.contains(index) ? first  : second,

                      borderRadius: BorderRadius.circular(12) ,
                    ),
                      child: Center(
                        child: Text(displayOX[index],
                          style: TextStyle(fontSize: 60 ,

                              fontWeight: FontWeight.w800 , )

                        ),
                      ),


                    ),
                    ) ;
                  },
                )
            ),


            ////////////////////////// PART 3 ///////////////// DIVIDE /////////////////////

            Expanded(
              flex: 2,
                child: Column(
                  children: [


                    Expanded(
                        flex: 1,
                        child: Container(
                          width: 250,
                            height: 50,
                            decoration: BoxDecoration(
                              color: appResult ,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(child: Text(resultDeclaration , style: TextStyle( color: Colors.white , fontSize: 20 , fontFamily: "myBoxNew"),)))),

                    Expanded(
                      flex:2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            child: FloatingActionButton(onPressed: (){
                              setState(() {
                               _clearBoard() ;
                              });
                            } , child: Text("Clear" , style: TextStyle(fontFamily: "myBox" , fontSize: 20),),),
                          ) ,
                          Container(
                            height: 70,
                            width: 70,
                            child: FloatingActionButton(onPressed: (){

                            } , child: Text("Start ", style: TextStyle(fontFamily: "myBox" , fontSize: 20),),),
                          ) ,
                          Container(
                            height: 70,
                            width: 70,
                            child: FloatingActionButton(onPressed: (){
                              setState(() {
                                _reStart() ;
                              });

                            } , child:Icon(Icons.restart_alt_outlined , size: 30, ),),
                          ) ,

                        ],


                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child:Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 50 ,
                                  width: 50 ,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.greenAccent , width: 1),
                                      boxShadow: [BoxShadow(color:  spBox , blurRadius: 10)],
                                      color: Colors.white
                                  ),
                                  child: Center(
                                      child: Text(xScore.toString()  , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 30 , fontFamily: "myBox"),
                                      )
                                  )
                              ) ,



                              Container(
                                  height: 50 ,
                                  width: 220 ,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.greenAccent , width: 1),
                                      boxShadow: [BoxShadow(color:  Colors.greenAccent , blurRadius: 10)],
                                      color: Colors.white
                                  ),
                                  child: Center(
                                      child: Text(widget.playerSecondResiver , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 30 , fontFamily: "myBox"),
                                      )
                                  )
                              ),



                              Container(
                                  height: 50 ,
                                  width: 50 ,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.greenAccent
                                  ),
                                  child: Center(
                                      child: Text("X", style: TextStyle( fontSize: 30 , fontFamily: "myBoxNew"),
                                      )
                                  )
                              ),



                            ],
                          )
                      )
                    ),

                    SizedBox(height: 40,)
                  ],
                )
            )

          ]
        ),


      ),
    ) ;
  }




  ///////////////////// Function ///////////////////////////////////
void _tapped(int index) {
  setState(() {
    if (oTurn && displayOX[index] == "") {
      displayOX[index] = "O";
      filledBoxes++ ;

    } else if (!oTurn && displayOX[index] == "") {
      displayOX[index] = "X";
      filledBoxes++;
    }
    oTurn = !oTurn; // here condition is false
    _checkWinner();

  });
}

    // here we create function to check the winner

  void _checkWinner(){

    // row 1 check
    if(displayOX[0] == displayOX[1]  &&
        displayOX[0] == displayOX[2] &&
        displayOX[1] == displayOX[2] &&
        displayOX[0] != "" ){setState(() {
          resultDeclaration = "Player " + displayOX[0] + " Wins" ;
          matchColor.addAll([0,1,2]);
          _updateScore(displayOX[0]) ;

        });

    Future.delayed(Duration(seconds:1), () {
      setState(() {
        _clearBoard();
        // first = Colors.greenAccent ;
      });
    });




    }



    // row 2 check
    if(displayOX[3] == displayOX[4]  &&
        displayOX[3] == displayOX[5] &&
        displayOX[4] == displayOX[5] &&
        displayOX[3] != "" ){setState(() {
      resultDeclaration = "Player " + displayOX[3] + " Wins" ;
      matchColor.addAll([3,4,5]);
      _updateScore(displayOX[3]) ;

    });

    Future.delayed(Duration(seconds:1), () {
      setState(() {
        _clearBoard();
        first = Colors.greenAccent ;
      });
    });


    }


    // row 3 check
    if(displayOX[6] == displayOX[7]  &&
        displayOX[6] == displayOX[8] &&
        displayOX[7] == displayOX[8] &&
        displayOX[6] != "" ){setState(() {
      resultDeclaration = "Player " + displayOX[6] + " Wins" ;
      matchColor.addAll([6,7,8]);
      _updateScore(displayOX[6]) ;

    });

    Future.delayed(Duration(seconds:1), () {
      setState(() {
        _clearBoard();
      });
    });

    }


    // col 1 check
    if(displayOX[0] == displayOX[3]  &&
        displayOX[0] == displayOX[6] &&
        displayOX[3] == displayOX[6] &&
        displayOX[0] != "" )
     {setState(() {
      resultDeclaration = "Player " + displayOX[0] + " Wins" ;
      matchColor.addAll([0,3,6]);
      _updateScore(displayOX[0]) ;

    });

     Future.delayed(Duration(seconds:1), () {
       setState(() {
         _clearBoard();

       });
     });

     }



    // col 2 check
    if(displayOX[1] == displayOX[4]  &&
        displayOX[1] == displayOX[7] &&
        displayOX[4] == displayOX[7] &&
        displayOX[1] != "" ){setState(() {
      resultDeclaration = "Player " + displayOX[1] + " Wins" ;
      matchColor.addAll([1,4,7]);
      _updateScore(displayOX[1]) ;

    });

    Future.delayed(Duration(seconds:1), () {
      setState(() {
        _clearBoard();

      });
    });

    }

    // col 3 check
    if(displayOX[2] == displayOX[5]  &&
        displayOX[2] == displayOX[8] &&
        displayOX[5] == displayOX[8] &&
        displayOX[2] != "" ){setState(() {
      resultDeclaration = "Player " + displayOX[2] + " Wins" ;
      matchColor.addAll([5,8,2]);
      _updateScore(displayOX[2]) ;

    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _clearBoard();
      });
    });

    }

    // dig 1 check
    if (displayOX[0] == displayOX[4] &&
        displayOX[0] == displayOX[8] &&
        displayOX[4] == displayOX[8] &&
        displayOX[0] != "") {
      setState(() {
        resultDeclaration = "Player " + displayOX[0] + " Wins";
        matchColor.addAll([0, 4, 8]);
        _updateScore(displayOX[0]);
      });

      Future.delayed(Duration(seconds:1), () {
        setState(() {
          _clearBoard();

        });
      });

    }

    // dig 2 check
    if (displayOX[2] == displayOX[4] &&
        displayOX[2] == displayOX[6] &&
        displayOX[4] == displayOX[6] &&
        displayOX[2] != "") {
      setState(() {
        resultDeclaration = "Player " + displayOX[2] + " Wins";
        matchColor.addAll([6, 2, 4]);
        _updateScore(displayOX[2]);
      });

      // Delay the board clearing after a win
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
      first = Colors.yellow ;
    } else if (!winnerFound && filledBoxes == 9) {
      setState(() {
        resultDeclaration = "Game Draw";
      });

      // Delay the board clearing after a draw
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }


  }

  ////  Mark Update Function
 void _updateScore(String winner){
    if(winner == "O"){
      oScore++ ;
    }else if(winner == "X"){
      xScore++;
    }
    winnerFound= true ;
 }

 // Here we create function for clear

void _clearBoard(){
    setState(() {
      for(int i = 0 ; i < 9 ; i++ ){
        displayOX[i] = "" ;
      }
      resultDeclaration ="" ;
    });
    filledBoxes = 0 ;
}

// here we create function for clear only board

void _reStart(){
  setState(() {
    for(int i = 0 ; i < 9 ; i++ ){
      displayOX[i] = "" ;
    }
    resultDeclaration ="" ;
    oScore = 0 ;
    xScore = 0 ;
  });

}

///////// Color change Function ///////
void _colorChange(){


}


}





