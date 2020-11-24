import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPreferences extends StatefulWidget {
  @override
  _UserPreferencesState createState() => _UserPreferencesState();
}

class _UserPreferencesState extends State<UserPreferences> {
  String uid = "nu8A8DDY8dVFsWVmhdsBkKmunSf1";
  String  size , name, shoeSize , preferedClothing, preferedShoeBrand, heelSize,
          favColor , favBrand;

  initilizeFireBase() async {
    Firebase.initializeApp();
    return await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Center(
          child: Text("User Preferences" , style:GoogleFonts.roboto(
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
      body: Padding(padding: EdgeInsets.all(10), child: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
            builder: (context , snapshot) {
              if(snapshot.hasError){
                return Center(
                  child: Text("Error occurd: " + snapshot.error.toString() ,style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 30
                  ), ),
                );
              }//end if

              if(snapshot.connectionState == ConnectionState.done){
                DocumentSnapshot documentSnapshot = snapshot.data;
                documentSnapshot.data().forEach((key, value) {
                  if(key == 'favBrand'){
                    favBrand = value;
                  }else if(key == 'favColor'){
                    favColor = value;
                  }else if(key == 'heelSize'){
                    heelSize = value;
                  }else if(key == 'name'){
                    name = value;
                  }else if(key =='preferedShoeBrand'){
                    preferedShoeBrand = value;
                  }else if(key == 'preferredClothing'){
                    preferedClothing = value;
                  }else if(key == 'shoeSize'){
                    shoeSize = value;
                  }else if(key == 'size'){
                    size = value;
                  }else{
                    //dummy
                  }
                });
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text("Name: " , style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 20
                          ),),
                        ),
                        Expanded(
                          child: Text(name , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Size: " , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        ),
                        Expanded(
                          child: Text(size , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                    Row(
                      children: [
                        Expanded(
                          child: Text("ShoeSize: " , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        ),
                        Expanded(
                          child: Text(shoeSize , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                    Row(
                      children: [
                        Expanded(
                          child: Text("What you like to wear most: " , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        ),
                        Expanded(
                          child: Text(preferedClothing , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Your favorite shoe brand: " , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        ),
                        Expanded(
                          child: Text(preferedShoeBrand , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Your size in heels: " , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        ),
                        Expanded(
                          child: Text(heelSize , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Favorite color: " , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        ),
                        Expanded(
                          child: Text(favColor , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Favorite brand: " , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        ),
                        Expanded(
                          child: Text(favBrand , style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        )
                      ],
                    ),
                  ],
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }//end if-else
            },
            future: initilizeFireBase(),
          ),
        ),
      ),),
    );
  }
}
