import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klutch/Modals/models.dart';

class Store_ClothesListing extends StatefulWidget {
  @override
  _Store_ClothesListingState createState() => _Store_ClothesListingState();
}

class _Store_ClothesListingState extends State<Store_ClothesListing> {
  String storeName , url, name,email, storeId;
  String storeUrl;
  List models = List();

  buildGrid(List<QueryDocumentSnapshot> documents) async{
    String id = "";
    models.clear();

    //add the individual values in the object
    documents.forEach((element) {
      element.data().forEach((key, value) {
        id = element.id;
        if(key == 'name' && name != value){
          name = value;
          // print(value);
        }else if(key == 'logo' && url !=value){
          url = value;
          //print(value);
        }else if(key == 'email' && email !=value){
          //key == email
          email = value;

        }else{

        }//end if-else

      });
      //add the respective model info to the list
      models.add(
          new Models(
              name: name,
              logo: url,
              email: email,
              id: id
          )
      );
    });

  }
  //TODO: Start from the drop down button user selects store from there
  @override
  Widget build(BuildContext context) {
    if(storeUrl!=null){

    }else{
      storeUrl = "https://insidesmallbusiness.com.au/wp-content/uploads/2019/09/bigstock-Modern-Show-Room-Selling-Cloth-315195415.jpg";
    }//end if-else
    return Scaffold(
      appBar:AppBar(
        title: Center(
          child: Text("Stores and their products" , style:GoogleFonts.roboto(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: NetworkImage(storeUrl),),
              DropdownButton(
                value: storeName,
                icon: Icon(Icons.arrow_drop_down),
                style: GoogleFonts.roboto(
                  color: Colors.black
                ),
                elevation: 16,
                onChanged: (String newValue) {
                  setState(() {
                    storeName = newValue;
                  });
                },
                items: <String>['Lowes ltd' ,'Haikyu' ].map <DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              FutureBuilder(
                builder: (context , snapshot) {
                  if(snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString(), style: GoogleFonts.roboto(
                        color: Colors.black
                      ),),
                    );
                  }

                  if(snapshot.connectionState == ConnectionState.done){
                    QuerySnapshot querysnapshot = snapshot.data;
                    List<DocumentSnapshot> documents = querysnapshot.docs;
                    documents.forEach((element) {
                      storeId = element.id;
                      element.data().forEach((key, value) {
                        if(key == 'logo'){
                          storeUrl = value;
                        }
                      });
                    });
                    return StreamBuilder(
                      builder: (context , snapshot) {
                        if(snapshot.hasData){
                          QuerySnapshot querySnapshot = snapshot.data;
                          List<DocumentSnapshot> documents = querySnapshot.docs;
                          buildGrid(documents);
                          return RefreshIndicator(
                            child: Container(
                              child: StaggeredGridView.countBuilder(
                                crossAxisCount: 4,
                                itemCount: models.length,
                                itemBuilder: (BuildContext context,int index ) {

                                  return Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(models[index].logo),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        //go to the relevant page

                                      },
                                    ),
                                  );
                                },
                                staggeredTileBuilder:(int index) {
                                  return  StaggeredTile.count(2,  index.isEven ? 3 : 2);
                                },
                                mainAxisSpacing: 6.0,
                                crossAxisSpacing: 4.0,
                              ),
                              height: MediaQuery.of(context).size.height/2,
                            ),
                            onRefresh: () {
                              setState(() {
                                buildGrid(documents);
                              });
                              return;
                            },
                          );
                        }else{
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }//end if-else
                      },
                      stream: FirebaseFirestore.instance.collection('Clothes').where('storeID',isEqualTo: storeId).snapshots(),
                    );
                  }else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }//end if-else
                },
                future: initilizerFireBase(),
              )
            ],
          ),
        ),
      ),),
    );
  }

  initilizerFireBase () async{
    Firebase.initializeApp();
    return await FirebaseFirestore.instance.collection('Stores').where('name',isEqualTo: storeName).get();
  }//end method
}
