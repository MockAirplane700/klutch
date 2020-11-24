import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klutch/Modals/dataObject.dart';
import 'package:klutch/databases/authenticate.dart';
import 'package:klutch/login_register/register.dart';

class LogIn extends StatefulWidget {

  final String id;

  LogIn({this.id});
  @override
  _LogInState createState() => _LogInState(docId: id);
}

class _LogInState extends State<LogIn> {

  final GlobalKey _formKey = GlobalKey<FormState>();
  String docId;
  String email , password , error;
  Color errorColor = Colors.white;
  Authenticate _authenticate = new Authenticate();

  _LogInState({this.docId});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(_authenticate.checkIfSignedIn()){
      //this is a check primarily for the route from the scanner
      Navigator.pushNamed(
          context,
          '/clothesItem',
          arguments: Data(
              documentID: docId,
              amount: '90'
          )
      );
    }
  }//end method

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          title: Center(child: Text("Klutch" , style: GoogleFonts.roboto(
            color: Colors.black
          ),)),
        ),

        body:Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2.0,200.0,2.0,1.0),
            child: Container(
              child: Card(
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30,),
                          TextFormField(
                            validator: (val) => val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val){
                              setState(() {
                                email = val;
                              });
                            },
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black , width: 1.0 ,)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black , width: 0.5)
                                ),
                              hintText: "Example@exmp.com"
                            ),
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
                            validator: (val) => val.length < 6 ? 'Enter password 6 + chars long' : null,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black , width: 1.0 ,)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black , width: 0.5)
                                ),
                              hintText: "Password"
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 30,),
                          Container(
                            child: RaisedButton(
                              onPressed: () async {
                                String string = _authenticate.signIn(email, password);
                                if(string!= null) {
                                  //sign in successful
                                  Navigator.pushNamed(
                                      context,
                                      '/clothesItem',
                                      arguments: Data(
                                          documentID: docId,
                                          amount: '90'
                                      )
                                  );
                                }else{
                                  //sign in attempt failed
                                }
                              },//end on pressed
                              color: Colors.pinkAccent[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.pinkAccent)
                              ),
                              child: Text("Sign In", style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                              ),),
                            ),
                            width: MediaQuery.of(context).size.width/2,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? " , style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 12
                              ),),
                              FlatButton(
                                child: Text("Sign up" , style: GoogleFonts.roboto(
                                  color: Colors.pinkAccent,
                                  fontSize: 12
                                ),),
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>Register())
                                  );
                                },
                              )
                            ],
                          )

                          //Below would be the error text that appears when the user does something they are not meant to do

                          //Text(error, style: TextStyle(color: Colors.red),),
                        ],
                      ),
                    )
                ),

              ),
              height: MediaQuery.of(context).size.height/2.1,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/icon1.jpeg"),
          fit: BoxFit.cover
        )
      ),
    );
  }
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        iconTheme: IconThemeData(
//          color: Colors.black
//        ),
//      ),
//      body: Container(
//        height: MediaQuery.of(context).size.height,
//        width: MediaQuery.of(context).size.width,
//        child: Center(
//          child: Card(
//            child: Form(
//                child: Column(
//                  children: [
//                    TextFormField(
//                      decoration: InputDecoration(
//                          hintText: "example@someemail.com",
//                          focusedBorder: OutlineInputBorder(
//                              borderSide: BorderSide(color: Colors.black , width: 1.0 ,)
//                          ),
//                          enabledBorder: OutlineInputBorder(
//                              borderSide: BorderSide(color: Colors.black , width: 0.5)
//                          )
//                      ),
//                      onChanged: (val) {
//                        setState(() {
//                          email = val;
//                        });
//                      },
//                    ),
//                    Text(error , style: GoogleFonts.roboto(
//                      color: errorColor
//                    ),),
//                    TextFormField(
//                      decoration: InputDecoration(
//                          focusedBorder: OutlineInputBorder(
//                              borderSide: BorderSide(color: Colors.black , width: 1.0 ,)
//                          ),
//                          enabledBorder: OutlineInputBorder(
//                              borderSide: BorderSide(color: Colors.black , width: 0.5)
//                          )
//                      ),
//                      onChanged: (val) {
//                        setState(() {
//                          password = val;
//                        });
//                      },
//                    ),
//                    Text(error , style: GoogleFonts.roboto(
//                        color: errorColor
//                    ),),
//                  ],
//                ),
//              key: _key,
//            ),
//          ),
//        ),
//      ),
//    );
//  }
}
