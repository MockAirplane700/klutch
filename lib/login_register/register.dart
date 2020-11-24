import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klutch/databases/authenticate.dart';
import 'package:klutch/login_register/login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  Authenticate _authenticate = Authenticate();
  //text fields input

  String email = "";
  String password = "";
  String error = "";
  String fname , lname, phone , address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Register" , style: GoogleFonts.roboto(
            color: Colors.black
          ),),
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body:Center(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child:  Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 30,),
                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Please enter your First name' : null,
                          onChanged: (val){
                            setState(() {
                              fname = val;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "First Name"
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Please enter your last name' : null,
                          onChanged: (val){
                            setState(() {
                              lname = val;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Last Name"
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
                              hintText: "Password"
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val){
                            setState(() {
                              email = val;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Email"
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Please enter your phone number' : null,
                          onChanged: (val){
                            setState(() {
                              phone = val;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Phone number"
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Please enter your address' : null,
                          onChanged: (val){
                            setState(() {
                              address = val;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Address"
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          child: RaisedButton(
                            onPressed: () async {
//                              Navigator.push(context,
//                                MaterialPageRoute(builder: (context)=>LogIn())

                              if(_formKey.currentState.validate()){
                                setState(() {
                                  print("all good boss");
                                  String result = _authenticate.registerWithEmailandPassword(fname, lname, email, phone, address, password);
                                  if(result == ""){
                                    error = "";
                                    print ("new user created");
                                  }else{
                                    error = result;
                                    print("error occured " + result);
                                  }
                                });
                                //upload the input data to database
                              }//end if
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.pinkAccent)
                            ),
                            color: Colors.pinkAccent[400],
                            child: Text("Register", style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white
                            ),),
                          ),
                          width: MediaQuery.of(context).size.width/2,
                        ),
                        SizedBox(height: 15,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account? " , style: GoogleFonts.roboto(
                              fontSize: 12,
                            ),),
                            FlatButton(onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>LogIn())
                              );
                            }, child: Text("Sign in" , style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.pinkAccent
                            ),))
                          ],
                        ),

                        //Below would be the error text that appears when the user does something they are not meant to do

                        Text(error, style: TextStyle(color: Colors.red),)
                      ],
                    )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
