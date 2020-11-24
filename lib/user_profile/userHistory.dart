import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHistory extends StatefulWidget {
  @override
  _UserHistoryState createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  List history = List();
  String uid = "nu8A8DDY8dVFsWVmhdsBkKmunSf1";
  String amount = "";

  initilizeApp ()async {
    Firebase.initializeApp();
    return FirebaseFirestore.instance.collection('Users').doc(uid).get();
  }
  @override
  Widget build(BuildContext context) {
    int count = 0;
    return Scaffold(
      appBar:AppBar(
        title: Center(
          child: Text("History" , style:GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 18
          ),),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        actions: [
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 0, 10) , child: GestureDetector(
            child: Container(
              child:  Image.asset('icons/shoppingBag.png'),
              height: MediaQuery.of(context).size.height/15,
              width: MediaQuery.of(context).size.width/15,
            ),
          ),)
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(padding: EdgeInsets.all(10),child: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
            builder: (context , snapshot) {
              //obtain the history array from the cloud
              if(snapshot.hasData){
                DocumentSnapshot documentSnapshot = snapshot.data;
                documentSnapshot.data().forEach((key, value) {
                  if(key == 'history'){
                    history = value;
                    print(key.toLowerCase());
                    print(history[0]);
                  }
                });
                count = history.length;
                print(count);
                //displaying the clothes!
                return Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: ListView.builder(
                        itemBuilder: (context , index) {
                          String url , name , price , currBid;
//                  Future<DocumentSnapshot> documentSnapshot = ;
//                  documentSnapshot.then((value) {
//                    value.data().forEach((key, value) {
//                      if(key == 'logo'){
//                        url = value;
//                      }else if(key == 'price'){
//                        price = value;
//                      }else if(key == 'name'){
//                        name = value;
//                      }else if(key == 'current_bid'){
//                        currBid = value;
//                      }else{
//                        //dummy
//                      }
//                    });
//                  });
                          return StreamBuilder(
                            builder: (context , snapshot) {
                              if(snapshot.hasData) {
                                DocumentSnapshot documentSnapshot = snapshot.data;
                                documentSnapshot.data().forEach((key, value) {
                                  if(key == 'logo'){
                                    url = value;
                                  }else if(key == 'price'){
                                    price = value.toString();
                                  }else if(key == 'name'){
                                    name = value;
                                  }else if(key == 'current_bid'){
                                    currBid = value.toString();
                                  }else{
                                    //dummy
                                  }
                                });
                                return showCard(context, url, name, price, currBid);
                              }else{
                                return Center(child: CircularProgressIndicator(),);
                              }
                            },
                            stream: FirebaseFirestore.instance.collection('Clothes').doc(history[index]).snapshots(),
                          );
                        },
                        itemCount: count,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height,
                  ),
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }//end if-else
            },
            future: initilizeApp(),
          ),
        ),
      ),),
    );
  }

  Widget showCard(BuildContext context, String url, String name, String price,
      String currBid) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10), child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(
                  image: NetworkImage(url),
                ),

              ),
              SizedBox(height: screenHeight / 90,),
              Text(name, style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: screenHeight / 90,),
              Text(price, style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: screenHeight / 90,),
              SizedBox(height: screenHeight / 50,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            //show dialog box to place bid in
                            _showMyDialogue("Place your bid", "Bid");
                          },
                          child:Text("Place Bid", style: TextStyle(
                              color: Colors.white
                          ),),
                          color: Colors.pink,
                        )
//                        Text("Place Bid", style: TextStyle(
//                            color: Colors.red
//                        ),),
//                        Text(currBid, style: TextStyle(
//                            color: Colors.black
//                        ),)
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth / 20,),
                  Expanded(child: FlatButton(
                      onPressed: () {
                        //display a dialog box asking for the required quantity
                        _showMyDialogue("Purchase item" , "Purchase");

                      },
                      child: Text("Add to bag", style: TextStyle(
                          color: Colors.white
                      ),),
                      color: Colors.pink
                  ))
                ],
              )
            ],
          ),
        ),),
      ),
    );
  }

  Future<void> _showMyDialogue(String title , String textButton) async {
    return showDialog <void> (
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Enter the desired quantity" , style: GoogleFonts.roboto(
                  color: Colors.black
                ),),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      amount = val.toString();
                    });
                  },
                  keyboardType: TextInputType.number,
                )
              ],
            ),
          ),
          actions:<Widget> [
            TextButton(
              child: Text(textButton , style: GoogleFonts.roboto(
                color: Colors.black
              ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }//end show my dialogue
}
