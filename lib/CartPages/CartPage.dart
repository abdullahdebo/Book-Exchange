import 'package:book_exchage2/DashBoard/Dashboard.dart';
import 'package:book_exchage2/Modules/CartModule.dart';
import 'package:book_exchage2/Modules/SnackBar.dart';
import 'package:book_exchage2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../DrwarPages/MyBooks.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:badges/badges.dart' as badges; // This import has been imported using (Prefix) so you need to use the prefix
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'DeilveryDetails.dart';

class CartPage extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> userData;
  const CartPage({key,required this.userData}):super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}


class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState>_ScaffoldKey=GlobalKey();
  double cartTotal= 0.0;

  @override
  void initState(){
    getCartTotal();
    super.initState();
  }

  getCartTotal(){
    CartModule().getCartTotalExcludeVat().then((value){
      setState(() {
        cartTotal = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ScaffoldKey,
      backgroundColor: Color(0xff1a1927),
      appBar: AppBar(
        toolbarHeight: 57.0,
        backgroundColor: Color(0xff1a1927),
        elevation: 10,
        title: Center(
          child: Text(
              'Cart',
            style: GoogleFonts.elMessiri(
              color: Colors.white,
              fontSize: 27,
            ),
          ),
        ),
        leading: InkWell(
          child: Icon(
              Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onTap: (){
            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder:(BuildContext context )=>Dashboard(userData:widget.userData)));
          },
        ),
        actions: [
          Padding(
              padding: EdgeInsets.all(8.0),
            child: InkWell(
              child: Icon(
                  Icons.remove_shopping_cart,
                size: 30,
                color: Colors.white,
              ),
              onTap: ()async{
                setState(() {
                  cartItems.clear();
                  getCartTotal();
                  showCartBadges = false;
                  cartBadgeCount=0;
                });
                Navigator.of(context).pushReplacement(CupertinoPageRoute(builder:(BuildContext context )=>Dashboard(userData:widget.userData)));
              },
            ),
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            if(cartItems!=null)
              Expanded(
                flex: 1,
                  child: ListView.builder(
                    shrinkWrap: true,
                      itemCount: cartItems.length,
                      itemBuilder: (context , index){
                      return Padding(
                          padding: EdgeInsets.only(bottom: 18.0),
                        child: Container(
                          height: 185,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: Color(0xffFD8200),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 110,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: NetworkImage(cartItems[index]['BookImage']),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 12),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 253,
                                            child: Text(
                                                cartItems[index]['BookName'].toString(),
                                              style: GoogleFonts.elMessiri(
                                                color: Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          SizedBox(height: 3,),
                                          SizedBox(
                                            width: 253,
                                            child: Text(
                                              cartItems[index]['BookWriter'].toString(),
                                              style: GoogleFonts.elMessiri(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 145,
                                    right: 5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '💵',
                                          style: GoogleFonts.elMessiri(
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Text(
                                        ' ${double.tryParse(cartItems[index]['BookPrice'].toString())!.toStringAsFixed(2)}',
                                          style: GoogleFonts.elMessiri(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'SAR',
                                          style: GoogleFonts.elMessiri(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    child: Material(
                                      color: Colors.red,
                                      elevation: 10,
                                      type: MaterialType.circle,
                                      child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          LineIcons.minusCircle,
                                          color: Colors.white,
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      CartModule().removeFromCart(index).then((value){
                                        if (value==true){
                                          getCartTotal();
                                        }else{
                                          redSnak(context, 'Items Cannot be removed');
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      }
                  ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0,bottom: 28.0,left: 8.0,right: 8.0, ),
                child: InkWell(
                  child: Container(
                    height: 60,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Color(0xffFD8200),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Check Out',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: 15,),
                              Icon(
                                LineIcons.checkCircle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Total :',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                               cartTotal.toStringAsFixed(2),
                                style: GoogleFonts.elMessiri(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'SAR',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 7,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    if(cartItems.isNotEmpty){
                      Navigator.of(context).push(CupertinoPageRoute(builder:(BuildContext context )=>DeilveryDetails(userData:widget.userData)));
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
