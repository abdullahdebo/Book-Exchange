import 'dart:math';
import 'package:book_exchage2/CartPages/SaveOrder.dart';
import 'package:book_exchage2/Modules/CartModule.dart';
import 'package:book_exchage2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:book_exchage2/Modules/SnackBar.dart';

class InvoiceInfo extends StatefulWidget {
  const InvoiceInfo({super.key, required this.userData,required this.userLatLong,required this.paymentType,required this.promoCodeValue,required this.promoCode});
  final DocumentSnapshot<Map<String, dynamic>> userData;
  final Position userLatLong;
  final String paymentType;
  final String promoCode;
  final double promoCodeValue;

  @override
  State<InvoiceInfo> createState() => _InvoiceInfoState();

}

class _InvoiceInfoState extends State<InvoiceInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int invoiceNumber=Random.secure().nextInt(9999999);
  double promoCodeDiscountAmount=0.0;
  double cartTotalWithoutVAT=0.0;
  double cartTotalIncludeVAT=0.0;
  double vatAmount=0.0;

  @override
  void initState() {
   calculateInvoiceTotal();
    super.initState();
  }

  calculateInvoiceTotal(){
    CartModule().getCartTotalExcludeVat().then((value) {
      setState(() {
        promoCodeDiscountAmount=(value*widget.promoCodeValue)/100;
        cartTotalWithoutVAT=value-promoCodeDiscountAmount;
        vatAmount=(cartTotalWithoutVAT*0.15);
        cartTotalIncludeVAT=cartTotalWithoutVAT+vatAmount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff13223D),
      appBar: AppBar(
        foregroundColor: Colors.white,
        toolbarHeight: 57.0,
        backgroundColor: Color(0xff13223D),
        elevation: 10,
        centerTitle: true,
        title: Text(
          'Invoice Info',
          style: GoogleFonts.elMessiri(
            color: Colors.white,
            fontSize: 23,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffFD8200),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child:  Text(
                          'Invoice #${invoiceNumber.toString()}',
                          style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Divider(color: Colors.black,),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cartItems.length,
                        itemBuilder: (context,i){
                          return Container(
                            height: 105,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Color(0xffFD8200).withOpacity(0.8),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 75,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(9),
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: NetworkImage(cartItems[i]['BookImage']),
                                                  fit: BoxFit.fill
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:12.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 253,
                                                child: Text(
                                                  cartItems[i]['BookName'].toString(),
                                                  style: GoogleFonts.elMessiri(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
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
                                                  cartItems[i]['BookWriter'].toString(),
                                                  style: GoogleFonts.elMessiri(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 55,
                                      right: 5,
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '💵',
                                            style: GoogleFonts.elMessiri(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                            ),
                                          ),
                                          Text(
                                            '  ${double.tryParse(cartItems[i]['BookPrice'].toString())?.toStringAsFixed(2)}',
                                            style: GoogleFonts.elMessiri(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 23,
                                            ),
                                          ),
                                          Text(
                                            ' SAR',
                                            style: GoogleFonts.elMessiri(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          );
                        },
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        children: [
                          Text(
                            '- Promo Discount:  ',
                            style: GoogleFonts.elMessiri(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            '-${widget.promoCodeValue.toStringAsFixed(0)}%',
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '- Promo Discount Amount:  ',
                            style: GoogleFonts.elMessiri(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            '-${promoCodeDiscountAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '- Total (Without VAT):  ',
                            style: GoogleFonts.elMessiri(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            cartTotalWithoutVAT.toStringAsFixed(2),
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '- Total VAT (15%):  ',
                            style: GoogleFonts.elMessiri(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            vatAmount.toStringAsFixed(2),
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '- Total (Include VAT):  ',
                            style: GoogleFonts.elMessiri(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            cartTotalIncludeVAT.toStringAsFixed(2),
                            style: GoogleFonts.andadaPro(
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.black,),
                      Row(
                        children: [
                          Text(
                            'Payment Type:',
                            style: GoogleFonts.elMessiri(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            '    ${widget.paymentType}',
                            style: GoogleFonts.elMessiri(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: SizedBox()
              ),
              GestureDetector(
                child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xffFD8200),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Place Order',
                            style: GoogleFonts.elMessiri(
                                fontSize: 22,
                                color: Colors.green[900],
                                fontWeight: FontWeight.bold
                            )
                        ),
                        SizedBox(width: 15,),
                        Icon(
                          LineIcons.checkCircleAlt,
                          color: Colors.green[900],
                        )
                      ],
                    )
                ),
                onTap: (){
                  createOrder();
                },
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  createOrder(){
    Map<String, dynamic> orderDoc={};
    setState(() {
      orderDoc={
        'InvoiceNo':invoiceNumber,
        'InvoiceDateTime':DateTime.now(),
        'PromoDiscountRate':widget.promoCodeValue,
        'PromoDiscountAmount':promoCodeDiscountAmount,
        'PromoCode':widget.promoCode,
        'InvoiceTotalExcludeVAT':cartTotalWithoutVAT,
        'InvoiceTotalVATAmount':vatAmount,
        'InvoiceTotalIncludeVAT':cartTotalIncludeVAT,
        'PaymentType':widget.paymentType,
        'OrderLocationLink':'https://www.google.com/maps/search/?api=1&query=${widget.userLatLong.latitude},${widget.userLatLong.longitude}',
        'OrderLocationLat':widget.userLatLong.latitude,
        'OrderLocationLong':widget.userLatLong.longitude,
        'UserName':widget.userData.data()?['UserName'],
        'UserPhoneNumber':widget.userData.data()?['UserPhoneNumber'],
        'UserID':widget.userData.id,
      };
    });
    print(orderDoc);
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => SaveOrder(
      userData: widget.userData,
      order: orderDoc,
    )));
  }

}
