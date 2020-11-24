import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Authenticate {

  FirebaseAuth _auth;
  FirebaseFirestore _firebaseFirestore;
  FirebaseStorage _storage;
  bool _success;
  String uid;

  Authenticate() {
    Future<FirebaseApp> firebaseapp = Firebase.initializeApp();
    firebaseapp.whenComplete(() {
      _auth = FirebaseAuth.instance;
      _firebaseFirestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
    });

  }//end constructor


  void _register(String email, String password) async {
    final User user = (await
    _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
    ).user;
    if (user != null) {
        _success = true;

    } else {
        _success = false;

    }
    uid = user.uid;
    print(uid);
  }

  bool checkIfSignedIn() {
    if(FirebaseAuth.instance.currentUser!= null){
      return true;
    }else{
      return false;
    }//end if-else
  }

  _loginwithEmailandPassword(String email, String password) async {
    String string;
    try {
      Future<UserCredential> user = _auth.signInWithEmailAndPassword(email: email, password: password);
      print(user.hashCode);
    }catch (ioe) {
      print(ioe.toString());
      string = ioe.toString();
    }
    return string;
  }//end method

  String signIn(String email, String password){
    String result = _loginwithEmailandPassword(email, password);
    return result;
  }
  String registerWithEmailandPassword (String fname, String lname, String email, String phone, String addy,String password) {
    String result = "Error in registeration";
    _register(email, password);
    _uploadData(fname, lname, email, phone, addy);
//    _auth.createUserWithEmailAndPassword(email: email, password: password)
//        .whenComplete(() {
//          result = "";
//          uid = _auth.currentUser.uid;
//          result = _uploadData(uid, fname, lname, email, phone, addy);
//    });
    //return null on success
    return result;
  }//end register with email and password

  _uploadData(String fname, String lname, String email, String phone, String addy)async {
    //have the document name be the uid of the user
    String result = "failed";
    await _firebaseFirestore.collection('Users').add({
      'fname': fname,
      'lname':lname,
      'email':email,
      'phone':phone,
      'addy':addy
    });
//    await _firebaseFirestore.collection('Users').doc(uid)
//        .set({
//      'fname': fname,
//      'lname':lname,
//      'email':email,
//      'phone':phone,
//      'addy':addy
//    }).whenComplete(() => result = "");
    //returns null on success
    return result;
  }//end upload data
}//end class