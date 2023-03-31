import 'package:camera/camera.dart';
import 'package:first_app/Reminder.dart';
import 'package:first_app/screens/calendar_widget.dart';
import 'package:first_app/screens/nearbyplaces.dart';
import 'package:first_app/screens/scannerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../utils/app_style.dart';
import 'calender_page.dart';
import 'chatai.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading=true;
  var cameras;
  var firstCamera;
  getCameras()async{
    setState(() {
      isLoading=true;
    });
    cameras = await availableCameras();
    firstCamera = cameras.first;

    setState(() {
      isLoading=false;
    });
  }
  @override
  void initState()
  {
    super.initState();
    getCameras();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: SpinKitPumpingHeart(size: 50,color: Colors.red,),):Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(205, 88, 88, 10),
        onPressed: () async {

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>const ChatAI(),
              ));
        },
        child: Icon(Icons.chat_bubble_outline),
      ),
      backgroundColor: Styles.bgColor,
      body: ListView(
        children: [
          Container(
            padding:const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children :[
                        Text(
                            "Good Morning",style: Styles.headlineStyle3,
                        ),
                        const Gap(10),
                        Text(
                            "Check on your health",style: Styles.headlineStyle1,
                        ),
                      ],
                    ),
                    Container(
                      height:50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assests/images/logo.png"
                              )
                          )
                      ),
                      //child: Image.asset("assests/images/logo.png"),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                InkWell(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Reminder()));},
                  child: Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width/2-20,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.alarm),
                        SizedBox(height: 10,),
                        Text(
                          "Reminders",style: Styles.headlineStyle3.copyWith(color: Colors.black),
                        ),
                      ],
                    ),),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CalendarPage()));},
                  child: Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width/2-20,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water_drop,color: Colors.red,),
                        SizedBox(height: 10,),
                        Text(
                          "Period Tracker",style: Styles.headlineStyle3.copyWith(color: Colors.black),
                        ),
                      ],
                    ),),
                  ),
                ),
              ],
            ),
          ),
          Padding(
           padding: const EdgeInsets.all(16.0),
            child: InkWell(
               onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>NearbyPlacesScreen(initialPosition: const LatLng(26.732311,50.890541), Latlng: null,)));},
               child: Container(
                 height: 170,
                 width: MediaQuery.of(context).size.width/2-20,
                 decoration: BoxDecoration(
                     color: Colors.redAccent,
                     borderRadius: BorderRadius.circular(30)
                 ),
                 child: Center(child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.add_location),
                     SizedBox(height: 10,),
                     Text(
                       "Check your Nearby Stores",style: Styles.headlineStyle3.copyWith(color: Colors.black),
                     ),
                   ],
                 ),),
               ),
             ),
           ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>TakePictureScreen(camera: firstCamera)));},
              child: Container(
                height: 170,
                width: MediaQuery.of(context).size.width/2-20,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload),
                    SizedBox(height: 10,),
                    Text(
                      "Upload your Prescription",style: Styles.headlineStyle3.copyWith(color: Colors.black),
                    ),
                  ],
                ),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

