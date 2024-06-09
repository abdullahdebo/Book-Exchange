import 'package:book_exchage2/Modules/SnackBar.dart';
import 'package:book_exchage2/DashBoard/Dashboard.dart';
import 'package:book_exchage2/Modules/SendNotification.dart';
import 'package:book_exchage2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:book_exchage2/DashBoard/Dashboard.dart';
import 'package:book_exchage2/Modules/SendNotification.dart';
import 'package:book_exchage2/main.dart';



class SaveOrder extends StatefulWidget {
  const SaveOrder({super.key, required this.userData,required this.order});
  final DocumentSnapshot<Map<String, dynamic>> userData;
  final Map<String, dynamic> order;
  @override
  State<SaveOrder> createState() => _SaveOrderState();

}

class _SaveOrderState extends State<SaveOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String loaderText='Placing your order 😊';
  bool orderFinish=false;

  @override
  void initState() {
    saveOrder();
    super.initState();
  }

  saveOrder()async{
    try{
      //throw Exception();
      Future.delayed(Duration(seconds: 3),()async{
        await FirebaseFirestore.instance.collection('Orders').add(widget.order).then((orderDoc) async{
          for(int i=0;i<cartItems.length;i++){
            await orderDoc.collection('Items').add(cartItems[i]);
          }
          if(!mounted)return;
          setState(() {
            loaderText='Yep, one touch remaining 🤭';
          });
          Future.delayed(Duration(seconds: 3),()async{
            for(int i=0;i<cartItems.length;i++){
              await FirebaseFirestore.instance.collection('Books')
                  .where('BookName',isEqualTo: cartItems[i]['BookName'])
                  .where('UserId',isEqualTo: cartItems[i]['UserId']).get().then((bookDoc) async{
                await FirebaseFirestore.instance.collection('Books').doc(bookDoc.docs[0].id).update({
                  'Sold':true,
                }).then((value) async{
                  // await SendNotification(
                  //   title: 'New Order Placed !',
                  //   body: 'Your book (${cartItems[i]['BookName']}) has sold, Make your shipment ASAP 😊',
                  //   userID: cartItems[i]['UserId'],
                  // ).getTokens(context);
                });
              });
            }
            if(!mounted)return;
            setState(() {
              loaderText='Order Placed 👍';
              orderFinish=true;
            });
            Future.delayed(Duration(seconds: 3),()async{
              if(!mounted)return;
              setState(() {
                cartItems.clear();
                var showCartBadge =false;
                cartBadgeCount=0;
              });
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => Dashboard(
                userData: widget.userData,
              )));
            });
          });
        });
      });
    }catch(e){
      Future.delayed(Duration(seconds: 3),()async{
        if(!mounted)return;
        redSnak(context, 'Order Cannot be placed due to an error occur');
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => Dashboard(
          userData: widget.userData,
        )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff13223D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              loaderText,
              style: GoogleFonts.andadaPro(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 30,),
            Visibility(
              visible: orderFinish,
              replacement: LoadingAnimationWidget.fallingDot(
                  color: Color(0xffFD8200),
                  size: 150
              ),
              child: Icon(
                LineIcons.checkCircleAlt,
                color: Colors.green,
                size: 150,
              ),
            ),
            SizedBox(height: 30,),
            Text(
              'Please wait......',
              style: GoogleFonts.andadaPro(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
