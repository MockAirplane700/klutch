import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klutch/Modals/dataObject.dart';


/*  This class doesn't need a database connection because if all the photos
    and information regarding them is in models we use that to display home and
    only need to send an object here to achieve what we want to achieve
 */
class ModelDisplay extends StatefulWidget {

  static const routeName = '/ModelDisplay';

  @override
  _ModelDisplayState createState() => _ModelDisplayState();
}

class _ModelDisplayState extends State<ModelDisplay> {

  Color _color = Colors.transparent;
  Color _textColor = Colors.black;
  String url;
  List clothesArray = new List();
  List priceList = new List();


  initDB() async{
    return await Firebase.initializeApp();
  }//end initDB

  obtainClothingArray(){
    //TODO: the price list keeps incrementing for some reason must fix
    for(int k=0; k<clothesArray.length; k++){
      DocumentReference documentReference = FirebaseFirestore.instance.collection('Clothes').doc(clothesArray[k]);
      Future<DocumentSnapshot> documentSnapshot = documentReference.get();
      documentSnapshot.then((value) =>
        value.data().forEach((key, value) {
          setState(() {
            if(key == 'price'){
              priceList.add(value);
            }
          });
        })
      );

    }//end for loop

    //the order of clothes worn will be top down so will be the pricing.
    //TODO: Consider labelling the clothes according to type and implementing general type for coordinate system, or having specific lables

  }//end obtain clothing array

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final Data args = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
      builder: (context , snapshot) {
        if(snapshot.hasError){
          return Center(
            child: Text(snapshot.error),
          );
        }//end if

        if(snapshot.hasData){
            //obtain the required information, images,price,price tag coordinates
            DocumentReference documentReference = FirebaseFirestore.instance.collection('Models').doc(args.documentID);
            Future<DocumentSnapshot> documentSnapshot = documentReference.get();
            if (documentSnapshot != null) {
              documentSnapshot.then((value) => value.data().forEach((key, value) {
                if (key == 'logo'){
                  setState(() {
                    url = value;
                  });
                }
              }));
            }//end if
//            getData(documentSnapshot);

            if(url == null){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    )
                ),
                child: GestureDetector(
                  //wrapped in Gesture Detector to ensure choice over seeing the button
                  child: Stack(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
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
                      //Transparent button at the bottom to view clothing list
                      Positioned(
                          child: RaisedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context,
                                    '/clothesItem',
                                    arguments: Data(
                                        documentID: args.documentID,
                                        amount: '90'
                                    )
                                );
                              },
                            child: Text("View Clothes" , style: TextStyle(
                              color: Colors.black,
                            ),),
                            color: _color
                          ),

                        top: height/1.1,
                        left: width/4,
                        right: width/4,
                        bottom: height/100,
                      ),


                    ],
                  ),
                  onTap:  () {
                    print("hello");
                    setState(() {
                      if (_color == Colors.transparent){
                        _color = Colors.pinkAccent;
                      } else{
                        _color = Colors.transparent;
                      }//end if-else

                    });
                  },
                ),
              );
            }
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }//end if-else
      },
      future: FirebaseFirestore.instance.collection('Models').doc(args.documentID).get(),
    );



  }

  void getData(Future<DocumentSnapshot> documentSnapshot) {
    documentSnapshot.then((value) => value.data().forEach((key, value) {
      if (key == 'logo'){
        setState(() {
          url = value;
        });
      }
    }));
  }
}
