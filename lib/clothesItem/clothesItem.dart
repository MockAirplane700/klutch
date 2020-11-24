import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klutch/Modals/dataObject.dart';
import 'package:klutch/storeBrowser/storeClothesListing.dart';

class ClothesItem extends StatefulWidget {
  static const routeName2 = '/clothesItem';

  @override
  _ClothesItemState createState() => _ClothesItemState();
}

class _ClothesItemState extends State<ClothesItem> {


  Color buttonColorSmall = Colors.white;
  Color buttonColorMedium = Colors.white;
  Color buttonColorLarge = Colors.white;
  Color buttonColorExtraLarge = Colors.white;
  List cartList;
  String amount;


  Widget selectedWidget = CircleAvatar(
    backgroundColor: Colors.pink,
    radius: 10,
  );

  List clothes = new List();
  List objects = new List();
  List list = new List();

  String selectedString = "M";
  String selectedStore = "Forever 21";
  String selectedColor = "";

  String buyerProtection, category, currentBid, logo, manufacturer, name,
      price, productDescription, stock, storeId;

  String docId;

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
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text("Store", style: TextStyle(
                            color: Colors.black
                        ),),
//                        Text("Forever 21" , style: TextStyle(
//                            color: Colors.black
//                        ),),
//                        DropdownButton<String>(
//                            hint: Text(selectedStore),
//                            items: [
//                              'Foever21',
//                              'Marks shop',
//                              'BMO bank',
//                              'Xtra large bank'
//                            ].map((String value) {
//                              return DropdownMenuItem<String>(
//                                  value: value,
//                                  child: Text(value)
//                              );
//                            }).toList(),
//                            onChanged: (String val) {
//                              setState(() {
//                                selectedStore = val;
//                              });
//                            }
//                        ),
                        FlatButton(
                          onPressed: () {
                            //Navigate to store clothes listing page
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> Store_ClothesListing())
                            );
                          },
                          child: Text("View stores and their clothes" , style: GoogleFonts.roboto(
                            color: Colors.white
                          ),),
                          color: Colors.pink,
                        )
                      ],
                    ),
                  ),
//                          SizedBox(width: screenWidth/4,),
                  Expanded(child: Column(
                    children: <Widget>[
                      Text("Color", style: TextStyle(
                          color: Colors.black
                      ),),
                      DropdownButton<Widget>(
                          hint: selectedWidget,
                          elevation: 0,
                          items: [
                            CircleAvatar(
                              backgroundColor: Colors.pink,
                              radius: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 10,
                            ),
                          ].map((Widget value) {
                            return DropdownMenuItem<Widget>(
                                value: value,
                                child: value
                            );
                          }).toList(),
                          onChanged: (Widget val) {
                            setState(() {
                              selectedWidget = val;
                              CircleAvatar avatar = selectedWidget;
                              selectedColor = avatar.backgroundColor.toString();
                            });
                          }
                      ),

                    ],
                  )),
//                          SizedBox(width: screenWidth/4,),
                  Expanded(child: Column(
                    children: <Widget>[
                      Text("Size", style: TextStyle(
                          color: Colors.black
                      ),),
                      DropdownButton<String>(
                          hint: Text(selectedString),
                          elevation: 0,
                          items: [
                            'M',
                            'L',
                            'XL',
                            'XXL'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value)
                            );
                          }).toList(),
                          onChanged: (String val) {
                            setState(() {
                              selectedString = val;
                            });
                          }
                      ),

                    ],
                  )),
                ],
              ),
              SizedBox(height: screenHeight / 50,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            _showMyDialogue("Place bid", "Bid");
                          },
                          child: Text("Place a bid" , style: GoogleFonts.roboto(
                            color: Colors.white
                          ),),
                          color: Colors.pink,
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth / 20,),
                  Expanded(child: FlatButton(
                      onPressed: () {
                        //add to bag
                        print(selectedColor);
                        print(selectedString);
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
  } //end show card


  Future getData() async {
    //Initializes the database via the new integration as of Aug 17th
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance.collection('Models')
        .doc(docId)
        .get();
  } //end get data

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Data args = ModalRoute
        .of(context)
        .settings
        .arguments;
    docId = args.documentID;

    print ("array objects " + objects.length.toString());
    int length = objects.length;

    setState(() {
      list.clear();
      for (int k = 0; k<objects.length; k++) {
        list.add(objects[k]);
      }
    });

    print(list.length);
    return Scaffold(
      appBar:AppBar(
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
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error),
            );
          } //end if

          if (snapshot.connectionState == ConnectionState.done) {
           DocumentSnapshot documentSnapshot =  snapshot.data;
           documentSnapshot.data().forEach((key, value) { 
             if(key == 'clothes'){
               clothes = value;
             }
           });
            return Container(
              child: ListView.builder(
                itemCount: clothes.length,
                itemBuilder: (context , index) {
                  return StreamBuilder(
                    builder: (context , snapshot) {
                      if(snapshot.hasData) {
                        DocumentSnapshot documentSnapshot = snapshot.data;
                        documentSnapshot.data().forEach((key, value) {
                          if(key == 'logo'){
                            logo = value;
                          } else if (key == 'name'){
                            name = value;
                          }else if(key == 'price'){
                            price = value.toString();
                          }else if (key == 'current_bid'){
                            currentBid = value.toString();
                          }else{
                            //dummy
                          }
                        });
                        return showCard(context, logo, name, price, currentBid);
                      }else{
                        return Center(child: CircularProgressIndicator(),);
                      }//end if-else
                    },
                    stream: FirebaseFirestore.instance.collection('Clothes').doc(clothes[index]).snapshots(),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Clothing item not yet found. This notifcaton will be removed if the item is found" ,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 18
                  ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/3,),
                  CircularProgressIndicator()
                ],
              ),
            );
          } //end if-else
        },
        future: getData(),
      ) ,
    );
  }

  processArray(DocumentSnapshot documentSnapshot) {
    //TODO: Obtain the array of clothing required and place it in a list
    clothes.clear();
    List array;

    documentSnapshot.data().forEach((key, value) {
      if (key == 'clothes') {
        if (value is String) {
          //do nothing
        } else {
          array = value;
        } //end if else
      } //end if
    });

    for (int k = 0; k < array.length; k++) {
      clothes.add(array[k]);
    } //end for loop

    //place each clothing object in a list

     return _placeClothingObjects();

  } //end method

  _placeClothingObjects() async {
    objects.clear();
   for (int k= 0; k< clothes.length; k++) {

     DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Clothes').doc(clothes[k]).get();
     if (snapshot.exists) {
       //print("snapshot exists");
       snapshot.data().forEach((key, value) {

         if (key == 'buyer_protection') {
          // print(key + " : " + value);
           buyerProtection = value;
         } else if (key == 'category') {
           //print(key + " : " + value);
           category = value;
         }else if (key == 'current_bid') {
          // print(key + " : " + value.toString());
           currentBid = value.toString();
         }else if (key == 'logo') {
          // print(key + " : " + value);
           logo = value;
         }else if (key == 'manufacturer') {
         //  print(key + " : " + value);
           manufacturer = value;
         }else if (key == 'name') {
         //  print(key + " : " + value);
           name = value;
         }else if (key == 'price') {
         //  print(key + " : " + value.toString());
           price = value.toString();
         }else if (key == 'product_description') {
         //  print(key + " : " + value);
           productDescription = value;
         }else if (key == 'stock'){
          // print(key + " : " + value.toString());
           stock = value.toString();
         }else{
           //storeid
          // print(key + " : " + value);
           storeId = value;
         }//end if-else
       });

       objects.add(
           new ClothesModalObject(
               buyerProtection: buyerProtection,
               category: category,
               currentBid: currentBid,
               logo: logo,
               manufacturer: manufacturer,
               name: name,
               price: price,
               productDescription: productDescription,
               stock: stock,
               storeId: storeId
           )
       );
     }else{
       print("no snapshot");
     }//end if-else
   }//end for loop
    return objects;

  }//end method

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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


class ClothesModalObject {
  String buyerProtection , category , currentBid , logo , manufacturer , name ,
          price, productDescription ,stock , storeId;

  ClothesModalObject ({
    this.logo , this.price , this.name , this.stock, this.manufacturer,
    this.category , this.storeId, this.buyerProtection, this.currentBid,
    this.productDescription

  });
}
