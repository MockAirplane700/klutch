import 'package:flutter/material.dart';
import 'package:klutch/home/home.dart';
import 'package:klutch/scanner/scannerPage.dart';
import 'package:klutch/storeBrowser/browser.dart';
import 'package:klutch/user_profile/user_profile.dart';


class NavigationBar extends StatefulWidget {
  int index;

  NavigationBar({this.index});
  @override
  _NavigationBarState createState() => _NavigationBarState(selectedIndex: index);
}

class _NavigationBarState extends State<NavigationBar> {
  int selectedIndex;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: browse',
      style: optionStyle,
    ),
    Text(
      'Index 2: scanner',
      style: optionStyle,
    ),
    Text('Index 3 : profile')
  ];

  _NavigationBarState({this.selectedIndex});

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if(selectedIndex == 0) {
      //home page
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }else if(selectedIndex == 1) {
      //Browser page
      Navigator.push(context, MaterialPageRoute(builder: (context) => Browser()));
    }else if(selectedIndex == 2){
      //scanner page
      Navigator.push(context, MaterialPageRoute(builder: (context) => Scanner()));
    }else{
      // profile page
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
    }//end if-else
  }

  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Scanner',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.pinkAccent,
      onTap: _onItemTapped,
    );
  }
}
