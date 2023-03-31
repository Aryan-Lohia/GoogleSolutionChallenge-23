import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/chatai.dart';
import 'package:first_app/screens/home_screen.dart';
import 'package:first_app/screens/profile.dart';
import 'package:first_app/screens/scannerScreen.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'calendar_widget.dart';

// ignore: camel_case_types
class bottom_bar extends StatefulWidget {
  final User user;

  const bottom_bar({Key? key, required this.user}) : super(key: key);

  @override
  State<bottom_bar> createState() => _bottom_barState();
}

class _bottom_barState extends State<bottom_bar> {
  int _selectedindex = 0;
  bool isLoading=true;
  List<Widget> List_widgetOptions=[];
  late final cameras;
  late final firstCamera;
  getCameras()async{
    setState(() {
      isLoading=true;
    });
    cameras = await availableCameras();
    firstCamera = cameras.first;
    List_widgetOptions = <Widget>[
      const HomeScreen(),
      // const Text("Search"),
      TakePictureScreen(
        camera: firstCamera,
      ),
      Profile(
        user: widget.user,
      ),
    ];
    setState(() {
      isLoading=false;
    });
  }
  void initState() {
    super.initState();
    getCameras();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator(),):Scaffold(

      body: Center(
        child: List_widgetOptions[_selectedindex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedindex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.orange,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color.fromRGBO(205, 88, 88, 10),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
              label: "Home"),
          // BottomNavigationBarItem(
          //     icon: Icon(FluentSystemIcons.ic_fluent_search_filled),
          //     activeIcon: Icon(FluentSystemIcons.ic_fluent_search_filled),
          //     label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined,size: 40,),
              activeIcon: Icon(Icons.document_scanner_outlined,size: 40,),
              label: "Scanner"),
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_person_filled),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
