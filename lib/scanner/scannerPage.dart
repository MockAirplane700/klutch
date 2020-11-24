
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:klutch/navigation/navigationBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';



class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  final Permission _permission = Permission.camera;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrTxt = "";
  QRViewController controller;

  String url , name, price, currBid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listenForPermissionStatus();

    if (_permissionStatus == PermissionStatus.undetermined){
      requestPermission(_permission);
    }//end if
    if(_permissionStatus.isPermanentlyDenied){
      requestPermission(_permission);
    }//end if

  }//end init state

  void _listenForPermissionStatus() async{
    final status = await _permission.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() {
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }//end request permission

  @override
  Widget build(BuildContext context) {

    print(qrTxt);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  flex: 1,
                ),
                Text("Scan results: $qrTxt"),
//                Expanded(
//                    child: StreamBuilder(
//                      builder: (context , snapshot) {
//                        if(snapshot.hasData){
//                          DocumentSnapshot documentSnapshot = snapshot.data;
//                          documentSnapshot.data().forEach((key, value) {
//                            if(key =='name'){
//                              name = value;
//                            }else if(key == 'logo'){
//                              url = value;
//                            }else if(key == 'current_bid'){
//                              currBid = value.toString();
//                            }else if(key == 'price'){
//                              price = value.toString();
//                            }else{
//                              //dummy
//                            }
//                          });
//                          return showCard(context, url, name, price, currBid);
//                        }else{
//                          return Center(child: CircularProgressIndicator(),);
//                        }
//                      },
//                      stream: initilizeFirebaseApp(),
//                    ),
//                  flex: 2,
//                )
              ],
            ),
            height: MediaQuery.of(context).size.height,
          ),
        )
      ),
      bottomNavigationBar: NavigationBar(index: 2,),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrTxt = scanData;
      });
    });
  }//end method

  @override
  void dispose() {
    // TODO: implement dispose
    controller ?.dispose();
    super.dispose();
  }

  initilizeFirebaseApp() {
    Firebase.initializeApp();
    return FirebaseFirestore.instance.collection('Clothes').doc(qrTxt).snapshots();
  }

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
          padding: EdgeInsets.all(50), child: SingleChildScrollView(
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
}

