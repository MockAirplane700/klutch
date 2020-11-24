/*  Home screen ,

 */


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klutch/Modals/dataObject.dart';
import 'package:klutch/Modals/models.dart';
import 'package:klutch/navigation/navigationBar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}//end class

class _HomeState extends State<Home> {

  List models = new List();
  static const routeName2 = '/home';

  dynamic name , logo , email;

  Future getData() async {
    //Initializes the database via the new integration as of Aug 17th
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance.collection('Models').get();
  }//end get data

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
        }else if(key == 'logo' && logo !=value){
          logo = value;
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
              logo: logo,
              email: email,
              id: id
          )
      );
    });

  }//end build grid

  Future<void> _onRefresh(List<QueryDocumentSnapshot> documents) async {
    buildGrid(documents);
  }//end on refresh

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Home" , style:GoogleFonts.roboto(
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
      body: Padding(padding: EdgeInsets.all(10), child: FutureBuilder(
          builder: (context , snapshot) {
            if(snapshot.connectionState == ConnectionState.done){

              //access the required data and make the use of the modal objects
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              buildGrid(documents);
              return RefreshIndicator(
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
                            Navigator.pushNamed(
                                context,
                                '/modelDisplay',
                                arguments: Data(
                                    documentID: models[index].id,
                                    amount: '90'
                                )
                            );
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
                  onRefresh: () {
                    setState(() {
                      buildGrid(documents);
                    });
                  },
              );

//              return StaggeredGridView.count(
//                crossAxisCount: 2,
//                physics: BouncingScrollPhysics(),
//                children: buildGrid(documents),
//                staggeredTiles: generateRandomTiles(count),
//              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }//end if-else
          },
        future: getData(),
      ),),
      bottomNavigationBar: NavigationBar(index: 0,),
      
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}//end class
