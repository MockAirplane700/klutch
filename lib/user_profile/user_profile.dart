import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klutch/Modals/clothes.dart';
import 'package:klutch/navigation/navigationBar.dart';
import 'package:klutch/user_profile/pastBids.dart';
import 'package:klutch/user_profile/userHistory.dart';
import 'package:klutch/user_profile/userPreferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  List history = new List();
  List currentOrders = new List();
  List pastBids = new List();
  List currentBids = new List();
  double screenHeight , screenWidth;
  String selectedString = "M";
  String selectedStore = "Forever 21";
  String selectedColor = "";
  String clothesId;
  int count =0;


  Widget selectedWidget = CircleAvatar(
    backgroundColor: Colors.pink,
    radius: 10,
  );

  _launchURL(String url, BuildContext context) async {
    if(await canLaunch(url)){
      await launch(url);
    }else{
      final snackBar = SnackBar(content: Center(child: Text("Unable to open $url")));
      Scaffold.of(context).showSnackBar(snackBar);
      throw "Could  not launch $url";
    }//end if - else
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Center(
          child: Text("ACCOUNT" , style: TextStyle(
              color: Colors.black
          ),),
        ),
        actions: <Widget>[
          Padding(padding: EdgeInsets.all(10) , child: GestureDetector(child: Icon(Icons.shopping_cart)),)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10), child: Column(
          children: <Widget>[
            SizedBox(height: screenHeight/10,),
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.person, size:screenWidth/10,),
                radius: screenWidth/10,
              ),
            ),
            SizedBox(height: screenHeight/50,),
            Text("Kaytheren Janeway" , style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
            SizedBox(height: screenHeight/20,),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      goToPreferences();
                    },
                    child: Text("View Preferences" , style: GoogleFonts.roboto(
                      color: Colors.black
                    ),),
                  ),
                ),
                Expanded(child: Icon(Icons.arrow_forward_ios),),
              ],
            ),
            SizedBox(height: screenHeight/50,),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      createOrderHistory();
                    },
                    child: Text("Order history" , style: GoogleFonts.roboto(
                        color: Colors.black
                    ),),
                  ),
                ),
                Expanded(child: Icon(Icons.arrow_forward_ios),),
              ],
            ),
            SizedBox(height: screenHeight/50,),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      createCurrentOrders();
                    },
                    child: Text("Current orders" , style: GoogleFonts.roboto(
                        color: Colors.black
                    ),),
                  ),
                ),
                Expanded(child: Icon(Icons.arrow_forward_ios),),
              ],
            ),
            SizedBox(height: screenHeight/50,),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                     createPastBids();
                    },
                    child: Text("Past bids" , style: GoogleFonts.roboto(
                        color: Colors.black
                    ),),
                  ),
                ),
                Expanded(child: Icon(Icons.arrow_forward_ios),),
              ],
            ),
            SizedBox(height: screenHeight/50,),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      createCurrentBids();
                    },
                    child: Text("Current bids" , style: GoogleFonts.roboto(
                        color: Colors.black
                    ),),
                  ),
                ),
                Expanded(child: Icon(Icons.arrow_forward_ios),),
              ],
            ),
            SizedBox(height: screenHeight/50,),
            ExpandablePanel(
              header: Text("Help & Support" , style: TextStyle(
                  color: Colors.black
              ),),
              expanded: Column(
                children: [
                  FlatButton(onPressed: () {
                    _launchURL('mailto:synthex2020@gmail.com?subject=Customer reaching out&body=Hello', context);
                  }, child: Text("Contact us by email" , style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 14
                  ),)),
                  SizedBox(height: screenHeight/10,),
                  FlatButton(onPressed: () {
                    String phone = "4313883047";
                    _launchURL('tel:$phone', context);
                  }, child: Text("Contact us by phone" , style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 14
                  ),))
                ],
              ),

            ),
            SizedBox(height: screenHeight/50,),
            RaisedButton(
                onPressed: () {
                  print("logout");
                },
              color: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.pink)
              ),
              child: Text("Logout" , style: GoogleFonts.roboto(
                color: Colors.black
              ),),
            )
          ],
        ),),
      ),
      bottomNavigationBar: NavigationBar(index: 3,),
    );
  }
  Widget goToPreferences () {
    Navigator.push(context,
      MaterialPageRoute(builder: (context)=> UserPreferences())
    );
    return Container();
  }
  Widget createOrderHistory() {
    Navigator.push(context,
    MaterialPageRoute(builder: (context)=>UserHistory())
    );
    return Container();
  }//end create order history

  Widget createCurrentOrders () {
    int size = 0;
    List clothesList = new List();
    String logo , price , name , currBid;

  return FutureBuilder(
    builder: (context , snapshot) {
      if(snapshot.connectionState == ConnectionState.done){
        QuerySnapshot querySnapshot = snapshot.data;
        List<DocumentSnapshot> documents = querySnapshot.docs;
        size = documents.length;
        documents.forEach((element) {
          element.data().forEach((key, value) {
            if (key == 'clothesId'){
              clothesId = value;
            }
          });
          clothesList.add(clothesId);
        });
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: ListView.builder(
              itemBuilder: (context , index) {
                return StreamBuilder(
                  builder: (context , snapshot) {
                    if(snapshot.hasData){
                      DocumentSnapshot documentSnapshot = snapshot.data;
                      documentSnapshot.data().forEach((key, value) {
                        if(key == 'logo'){
                          logo= value;
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
                      return showCard(context, logo, name, price, currBid);
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }//end if-else
                  },
                  stream: FirebaseFirestore.instance.collection('Clothes').doc(clothesList[index]).snapshots(),
                );
              },
              itemCount: size,
            ),
          ),
          height: screenHeight/2,
        );
      }else{
        return Center(
          child: CircularProgressIndicator(),
        );
      }//end if-else
    },
    future: FirebaseFirestore.instance.collection('Users').doc('nu8A8DDY8dVFsWVmhdsBkKmunSf1').collection('currentOrders').get(),
  );
  }//end current orders

  Widget createPastBids () {
    Navigator.push(context,
    MaterialPageRoute(builder: (context)=> UserPastBids())
    );
    return Container();
  }

  Widget createCurrentBids () {
    return StreamBuilder(
      builder: (context , snapshot) {
        String currentBid , previousBid , clothesid;
        if(snapshot.hasData) {
          QuerySnapshot querySnapshot = snapshot.data;
          List<QueryDocumentSnapshot> list = querySnapshot.docs;
          list.forEach((element) {
            element.data().forEach((key, value) {
              if(key == 'currentBid'){
                currentBid = value.toString();
              }else if(key == 'clothesId'){
                clothesid = value;
              }else{
                //its total
                previousBid = value.toString();
              }//end if-else
            });

          });
          createcurrentBidsList(currentBid, clothesid, previousBid);

          return Container(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: ListView.builder(
                itemBuilder: (context , index) {
                  return showCard(context, currentBids[index].logo, currentBids[index].name, "90", currentBids[index].bid);
                },
                itemCount: pastBids.length,
              ),
            ),
            height: MediaQuery.of(context).size.height/2,
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
      stream: FirebaseFirestore.instance.collection('Users').doc('nu8A8DDY8dVFsWVmhdsBkKmunSf1').collection('currentOrders').snapshots(),
    );
  }//end create current bids

  createList(String amount , String clothesId , String total) async{
    String name , url , bid;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Clothes').doc(clothesId).get();
    documentSnapshot.data().forEach((key, value) {
      if(key == 'name'){
        name = value;
      } else if(key == 'logo'){
        url = value;
      }else if(key == 'current_bid'){
        bid = value.toString();
      }else{
        //dummmy
      }
    });
    count++;
    print("list count: " + count.toString());
    currentOrders.add(
      new Clothes(name: name , amount: amount , logo: url ,bid: bid )
    );
    return currentOrders;
  }//end create list

  void createpastBidsList(String amount , String clothesId , String total) async{
    String name , url , bid;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Clothes').doc(clothesId).get();
    documentSnapshot.data().forEach((key, value) {
      if(key == 'name'){
        name = value;
      } else if(key == 'logo'){
        url = value;
      }else if(key == 'current_bid'){
        bid = value.toString();
      }else{
        //dummmy
      }
    });
    count++;
    print("list count: " + count.toString());
    pastBids.add(
        new Clothes(name: name , amount: amount , logo: url ,bid: bid )
    );
  }//end create list

  void createcurrentBidsList(String currentBid , String clothesId , String total) async{
    String name , url , bid;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Clothes').doc(clothesId).get();
    documentSnapshot.data().forEach((key, value) {
      if(key == 'name'){
        name = value;
      } else if(key == 'logo'){
        url = value;
      }else if(key == 'current_bid'){
        bid = value.toString();
      }else{
        //dummmy
      }
    });
    count++;
    print("list count: " + count.toString());
    currentBids.add(
        new Clothes(name: name , amount: currentBid , logo: url ,bid: bid )
    );
  }//end create list

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
                        Text("Current bids", style: TextStyle(
                            color: Colors.red
                        ),),
                        Text(currBid, style: TextStyle(
                            color: Colors.black
                        ),)
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
                      color: Colors.orange[700]
                  ))
                ],
              )
            ],
          ),
        ),),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
