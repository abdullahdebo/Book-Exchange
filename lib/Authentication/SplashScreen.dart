import 'package:book_exchage2/DashBoard/Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AuthPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateAfterDuration();
    super.initState();
  }

  void navigateAfterDuration() async {
    User? user = await FirebaseAuth.instance.currentUser;
    if (user != null && user.uid.isNotEmpty == true) {
      Future.delayed(Duration(seconds: 4), () async {
        await FirebaseFirestore.instance.collection('UsersAccount').doc(user.uid).get().then((userDoc) async {
          if (userDoc.id.isNotEmpty == true && userDoc.data()?.isNotEmpty == true) {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => Dashboard(userData: userDoc)));
          } else {
            await FirebaseAuth.instance.signOut().then((value) {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => AuthenticationPage()));
            });
          }
        });
      });
    } else {
      Future.delayed(Duration(seconds: 4), () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => AuthenticationPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1a1927),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://i.pinimg.com/736x/dd/64/da/dd64da585bc57cb05e5fd4d8ce873f57.jpg'), fit: BoxFit.fill
                      // image: AssetImage('assets/images/BookExchangeLogo.png')
                      )),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
          ),
          Text(
            'BookExchange',
            style:GoogleFonts.elMessiri(
              color:Colors.white,
              fontSize:26,
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
