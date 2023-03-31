import 'dart:async';

import 'package:first_app/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.orangeAccent.shade100,
      child: Center(
        child: Hero(
          tag:"splash",
          child: Image.asset("assests/images/logo-nobg.png",height: 250,width: 250,)
              .animate()
              .scale(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOutQuart,
                  begin: Offset(0,0))
              .shimmer(
            curve: Curves.easeOutQuad,

            delay: Duration(seconds: 1,milliseconds: 20),
                duration: Duration(milliseconds: 1000),
              ),
        ),
      ),
    );
  }
}
