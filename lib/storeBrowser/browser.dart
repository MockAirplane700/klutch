/*  Store browser

 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klutch/Modals/stores.dart';
import 'package:klutch/about/about.dart';
import 'package:klutch/navigation/navigationBar.dart';

class Browser extends StatefulWidget {
  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {

 final _formkey = GlobalKey<FormState>();
 String searchQuery;
 String error;
 double height , width;

 dynamic country , city , contact , description ,hours , logo ,
          name , postal ,province , street , website;

 List stores = new List();

  Future getFutureData() async {
   await Firebase.initializeApp();
   return await FirebaseFirestore.instance.collection('Stores').get();
 }//end method

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //TODO: Process data and place it in a list to be displayed

 processData (List<QueryDocumentSnapshot> documents){
    stores.clear();
    documents.forEach((element) {
      element.data().forEach((key, value) {
        if (key == 'logo') {
          logo = value;
        } else if (key == 'name'){
          name = value;
        }else{
          //dummy
        }
      });
      stores.add(
        new Stores(
          logo: logo,
          name: name,
          id: element.id
        )
      );
    });

    return stores;
 }//end process data
  //TODO: The goal is to place the search bar above the results consider using a stream builder within a future builder
  @override
  Widget build(BuildContext context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Stores" , style:GoogleFonts.roboto(
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
      body: Container(
        height: height,
        child: Padding(padding: EdgeInsets.all(10) , child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //search bar
              Form(
                child: TextFormField(
                  decoration: InputDecoration(
                       hintText: "Search, note all store names start with CAPS",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black , width: 1.0 ,)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black , width: 0.5)
                      )
                  ),
                  onChanged: (val) {
                    setState(() {
                      searchQuery = val;
                    });
                    },
                ),
                key: _formkey,
              ),
              FutureBuilder(
                builder: (context , snapshot) {

                  if(snapshot.hasData){
                    QuerySnapshot qs = snapshot.data;
                    dynamic documents = qs.docs;
                    processData(documents);
                    //check for the search value
                    if(searchQuery == null || searchQuery == "") {
                      //just list the available stores
                      return Container(
                        child: ListView.builder(
                            itemBuilder: (context , index) {
                              String url = stores[index].logo;
                              if(url != null){
                                return displayCard(stores[index].name, "", stores[index].logo,context,stores[index].id);
                              }else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }//end if
                            },
                          itemCount: stores.length,
                        ),
                        height: height/1.3,
                      );
                    } else {
                      //show the search results
                      return StreamBuilder(
                        builder: (context , snapshot) {
                          if(snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }//end if

                          if (snapshot.hasData) {
                            QuerySnapshot querysnapshot =  snapshot.data;
                            List<QueryDocumentSnapshot> documents = querysnapshot.docs;
                            processData(documents);

                            if (stores.length == 0 || stores.isEmpty) {
                              return Container(
                                child: Center(
                                  child: Text("Eror 404 not found"),
                                ),
                                height: height/2,
                              );
                            }else {
                              return Container(
                                child: ListView.builder(
                                  itemBuilder: (context , index) {
                                    return Center(
                                      child: displayCard(name, "", stores[index].logo,context,stores[index].id),
                                    );
                                  },
                                  itemCount: stores.length,
                                ),
                                height: height,
                              );
                            }//end if-else

                          } else {
                            return Container(
                              child: Center(
                                child: Text("Snapshot has no data"),
                              ),
                            );
                          }//end if-else
                        },
                        stream: FirebaseFirestore.instance.collection('Stores').where('name' , isEqualTo: searchQuery).snapshots(),
                      );
                    }

                  }else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                future: getFutureData(),
              )
            ],
          ),
        ),),
      ),
      bottomNavigationBar: NavigationBar(index: 1,),

    );
  }

  Widget displayCard (String name, String street , String url, BuildContext context, String id) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: NetworkImage(url)),
            SizedBox(height: height / 89,),
            Text(name, style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),),
            SizedBox(height: height / 89,),
            Text(street, style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),),
            SizedBox(height: height / 89,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 1.0,
                width: width,
                color: Colors.black,),),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => About(docId: id,)));
      },
    );
  }//end method

  void search (String string) {
    String result = "";
    List returnList = new List();

    for (int k=0; k<stores.length; k++) {
      String temporary = stores[k].name;
      temporary.toLowerCase();
      string.toLowerCase();

      if(string == temporary){
        //found what we are looking for!

      }
    }//end for loop

  }//end search

 @override
 void dispose() {
   // TODO: implement dispose
   super.dispose();
 }
}//end class








//ListView.builder(
//itemBuilder: (context , index){
//DocumentSnapshot ds = documents[index];
//ds.data().forEach((key, value) {
//if(key == 'Country'){
//country = value;
//}else if(key == 'city'){
//city = value;
//}else if(key == 'contact'){
//contact = value;
//}else if(key == 'description'){
//description = value;
//}else if(key == 'hours'){
//hours = value;
//}else if(key == 'logo'){
//logo = value;
//}else if(key =='name' ){
//name = value;
//}else if(key == 'postal code'){
//postal = value;
//}else if(key == 'province'){
//province = value;
//}else if(key == 'street'){
//street = value;
//}else{
////key == website
//website = value;
//}
//});
//
//String string = name;
//print(string);
//if(string.contains(searchQuery) && searchQuery!=""){
//
//}
//},
//itemCount: qs.size,
//),
















//StreamBuilder(
//stream: FirebaseFirestore.instance.collection('Stores').snapshots(),
//builder: (context , snapshot) {
//
//if(snapshot.hasError){
//return Center(
//child: Text("An error has occuered" + snapshot.error.toString()),
//);
//}//end if
//
//if(snapshot.hasData) {
//
//QuerySnapshot qs = snapshot.data;
//List<QueryDocumentSnapshot> ds = qs.docs;
//int size = qs.size;
//
////check the search parameters
//if(searchQuery == null || searchQuery == ""){
//return Container();
//}else{
////search for the object
//return ListView.builder(
//itemBuilder: (context , index) {
////set data variables
//ds[index].data().forEach((key, value) {
//if (key == 'Country') {
//country = value;
//} else if (key == 'city') {
//city = value;
//} else if (key == 'contact') {
//contact = value;
//} else if (key == 'description') {
//description = value;
//} else if (key == 'hours') {
//hours = value;
//} else if (key == 'logo') {
//logo = value;
//} else if (key == 'name') {
//name = value;
//} else if (key == 'postal code') {
//postal = value;
//} else if (key == 'province') {
//province = value;
//} else if (key == 'street') {
//street = value;
//} else {
////key == website
//website = value;
//}
//});
//
//print(logo);
//
//String string = name;
////run search
//if (string.contains(searchQuery)){
////item found
//return GestureDetector(
//child: Card(
//elevation: 0,
//child: Column(
//crossAxisAlignment: CrossAxisAlignment.center,
//mainAxisAlignment: MainAxisAlignment.center,
//children: [
//Image(image: NetworkImage(logo)),
//SizedBox(height: height/89,),
//Text(name , style: GoogleFonts.roboto(
//color: Colors.black,
//fontWeight: FontWeight.bold,
//fontSize: 20
//),),
//SizedBox(height: height/89,),
//Text(street , style: GoogleFonts.roboto(
//color: Colors.black,
//fontSize: 18
//),),
//SizedBox(height: height/89,),
//Padding(
//padding: EdgeInsets.symmetric(horizontal: 10.0),
//child: Container(
//height: 1.0,
//width: width,
//color: Colors.black,
//),
//)
//],
//),
//),
//);
//}else{
////no item found
//return Center(
//child: Text("Not found: " + searchQuery),
//);
//}//end if-else
//},
//itemCount: size,
//);
//}
//}else{
//return Center(
//child: CircularProgressIndicator(),
//);
//}//end if-else
//}//end builder
