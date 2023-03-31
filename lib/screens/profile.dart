import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/screens/prescriptionScreen.dart';
import 'package:first_app/screens/showPres.dart';
import 'package:first_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'fire_auth.dart';
import 'loginpage.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  bool isLoading = true;
  DocumentSnapshot? userDetails;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    userDetails = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .get();
    _currentUser = (await FireAuth.refreshUser(_currentUser))!;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: isLoading
            ?  Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              SpinKitPumpingHeart(size: 50,color: Colors.red,),
              SizedBox(
                height: 20,
              ),
              Center(child: Text("Fetching your Profile",style: Styles.headlineStyle3,)),
            ],
          ),
        )
            : SingleChildScrollView(
              child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              !_currentUser.emailVerified
                                  ? _isSendingVerification
                                      ? CircularProgressIndicator()
                                      : TextButton(
                                          onPressed: () async {
                                            setState(() {
                                              _isSendingVerification = true;
                                            });
                                            await _currentUser
                                                .sendEmailVerification();
                                            setState(() {
                                              _isSendingVerification = false;
                                            });
                                          },
                                          child: Text(
                                            'Verify email',
                                            style: TextStyle(
                                                color: Colors.blue.shade700),
                                          ),
                                        )
                                  : Container(),
                              Spacer(),
                              _isSigningOut
                                  ? CircularProgressIndicator()
                                  : TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isSigningOut = true;
                                        });
                                        await FirebaseAuth.instance.signOut();
                                        setState(() {
                                          _isSigningOut = false;
                                        });
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Sign out',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(205, 88, 88, 10)),
                                      ),
                                    ),
                            ],
                          ),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.orange,
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Name: ${_currentUser.displayName}",
                                    style: Styles.headlineStyle3
                                        .copyWith(color: Colors.black54),
                                  ),
                                  Text(
                                    "Age : ${userDetails!['age']}",
                                    style: Styles.textStyle,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Sex : ${userDetails!['sex']}",
                                    style: Styles.textStyle,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white.withOpacity(0.8))),
                                      onPressed: () {},
                                      child: Text(
                                        "Edit Profile",
                                        style: TextStyle(color: Colors.black),
                                      ))
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            height: 30,
                          ),
                          Text(
                            "Your Prescriptions:",
                            style: Styles.headlineStyle2,
                          ),
                          Container(
                              height: 380,
                              margin: EdgeInsets.only(top: 15),
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      (userDetails!['prescriptions'] as List)
                                          .length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        padding: EdgeInsets.all(8),
                                        child: ListTile(
                                          onTap: () {
                                            List meds = [];
                                            for (int i = 0;
                                                i <
                                                    userDetails!['prescriptions']
                                                            [index]['meds']
                                                        .length;
                                                i++) {
                                              meds.add(MyExcelTable(
                                                  name: userDetails!['prescriptions']
                                                      [index]['meds'][i]['name'],
                                                  price: userDetails!['prescriptions']
                                                      [index]['meds'][i]['price'],
                                                  manufacturer:
                                                      userDetails!['prescriptions']
                                                              [index]['meds'][i]
                                                          ['manufacturer'],
                                                  composition:
                                                      userDetails!['prescriptions']
                                                              [index]['meds'][i]
                                                          ['composition'],
                                                  size: "0"));
                                            }
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Prescription(image: userDetails!['prescriptions'][index]['img'],excelList: meds,)));
                                          },
                                          leading: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Image.network(
                                                userDetails!['prescriptions']
                                                    [index]['img'],
                                                fit: BoxFit.cover,
                                              )),
                                          title: Text(
                                            "Prescription ${index + 1}",
                                            style: Styles.headlineStyle2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }))
                        ],
                      ),
                    ),
                  ],
                ),
            ),
      ),
    );
  }
}
