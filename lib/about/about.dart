import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klutch/storeBrowser/storeClothesListing.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  final String docId;

  About ({this.docId});
  @override
  _AboutState createState() => _AboutState(docId: docId);
}

class _AboutState extends State<About> {
  final String docId;

  String url , name, street , description , hours, contact , website, country, postal,city,province;

  _AboutState({this.docId});

  double screenHeight , screenWidth;
  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("About" , style:GoogleFonts.roboto(
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
      body: FutureBuilder(
        builder: (context , snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text("snapshot error: " + snapshot.error.toString()),
            );
          }//end if

          if(snapshot.hasData) {
            DocumentSnapshot querySnapshot = snapshot.data;
            processData(querySnapshot);
            print(website);
            return Padding(padding: EdgeInsets.all(10), child: SingleChildScrollView(
              child: createDisplay(context, url, name, street, description, hours, contact, website),
            ),);
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }//end if-else
        },
        future: getData(),
      ),
    );
  }//end build

  _launchURL(String url, BuildContext context) async {
    if(await canLaunch(url)){
      await launch(url);
    }else{
      final snackBar = SnackBar(content: Center(child: Text("Unable to open $url")));
      Scaffold.of(context).showSnackBar(snackBar);
      throw "Could  not launch $url";
    }//end if - else
  }

  Widget createDisplay(BuildContext context , String url ,String name ,String street, String description, String hours, String contact, String website ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(image: NetworkImage(url)),
        SizedBox(height: screenHeight/90,),
        Text(name , style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),),
        Text(street , style: TextStyle(
            color: Colors.black,
            fontSize: 18
        ),),
        SizedBox(height: screenHeight/70,),
        Text( "Hours of Operation       " , style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),),
        Text(hours, style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),),
        SizedBox(height: screenHeight/70,),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(description , maxLines: 10,style: TextStyle(
              color: Colors.black,
              fontSize: 15
          ),),
        ),
        SizedBox(height: screenHeight/70,),
        GestureDetector(
          onTap: () {
            //go to the caller
            String phone = contact;
            _launchURL('tel:$phone', context);
          },
          child: Text(contact+ "             " , style: TextStyle(
            fontSize: 18,

          ),),
        ),
        SizedBox(height: screenHeight/90,),
        GestureDetector(
          onTap: () {
            //go to the site
            String url = website;
            _launchURL(url, context);
          },
          child: Text(website+"       " , style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),),
        ),
        FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Store_ClothesListing()));
          },
          child: Text("View our products" , style: GoogleFonts.roboto(
            color: Colors.white
          ),),
          color: Colors.pink,
        )

      ],
    );
  }//end create display

  Future getData() {
    return FirebaseFirestore.instance.collection('Stores').doc(docId).get();
  }

  void processData(DocumentSnapshot documents) {
    documents.data().forEach((key, value) {
      if(key == 'name') {
        name = value;
      }else if(key == 'logo'){
        url = value;
      }else if(key == 'street'){
        street = value;
      }else if(key == 'description'){
        description = value;
      }else if(key == 'hours'){
        hours = value;
      }else if(key == 'contact'){
        contact = value;
      }else if(key == 'Country'){
        country = value;
      }else if(key == 'postal code'){
        postal = value;
      }else if(key == 'city'){
        city = value;
      }else if(key == 'province'){
        province = value;
      }else{
        website = value;
      }
    });
  }//end get data

  void stringProccessing(String string) {

  }//end string processing
}
