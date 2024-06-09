import 'package:book_exchage2/Modules/SnackBar.dart';
import 'package:book_exchage2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:line_icons/line_icons.dart';
import 'package:book_exchage2/CartPages/InvoiceInfo.dart';

class DeilveryDetails extends StatefulWidget {
  const DeilveryDetails({super.key, required this.userData});
  final DocumentSnapshot<Map<String, dynamic>> userData;
  @override
  State<DeilveryDetails> createState() => _DeilveryDetailsState();
}

class _DeilveryDetailsState extends State<DeilveryDetails> {
  String googleMapURL = 'https://www.google.com/maps/search/?api=1&query=<lat>,<lng>';
  String userAddress = 'Locating........';
  late Position userLatLong;
  String paymentType = 'Cash On Delivery';
  TextEditingController promoCodeController = TextEditingController();
  double promoCode = 0.0;

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  getLocation() async {
    print('Location ....');
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    debugPrint('Location: ${position.latitude} - ${position.longitude}');
    setState(() {
      userAddress = '${position.latitude} - ${position.longitude}';
      userLatLong = position;
    });
    print('https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1a1927),
      appBar: AppBar(
        backgroundColor: Color(0xff1a1927),
        foregroundColor: Colors.white,
        toolbarHeight: 57.0,
        centerTitle: true,
        elevation: 10,
        title: Text(
          'Delivery Details',
          style: GoogleFonts.elMessiri(
            color: Colors.white,
            fontSize: 27,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    'Delivery Info :',
                    style: GoogleFonts.elMessiri(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffFD8200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location : ',
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          //Text From geocoder library
                          Text(
                            userAddress.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.andadaPro(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Contact Number : ',
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.userData.data()?['UserPhoneNumber'],
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Payment : ${paymentType.toString()}',
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Text(
                    'Payment Type :',
                    style: GoogleFonts.elMessiri(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffFD8200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(
                            LineIcons.moneyBill,
                            size: 35,
                            color: Colors.green[800],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Cash On Delivery',
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      leading: Radio<String>(
                        value: 'Cash On Delivery',
                        groupValue: paymentType,
                        activeColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            paymentType = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffFD8200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(
                            LineIcons.visaCreditCard,
                            size: 35,
                            color: Colors.blue[900],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'ATM Machine',
                            style: GoogleFonts.elMessiri(
                              fontSize: 23,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      leading: Radio<String>(
                        value: 'ATM Machine',
                        groupValue: paymentType,
                        activeColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            paymentType = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Promo Code ?',
                    style: GoogleFonts.elMessiri(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffFD8200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: TextField(
                        controller: promoCodeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter The Code Here ',
                            hintStyle: GoogleFonts.elMessiri(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                            )),
                        style: GoogleFonts.elMessiri(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          promoCode > 0
                              ? Icon(
                                  LineIcons.checkCircle,
                                  color: Colors.greenAccent,
                                )
                              : SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            promoCode > 0 ? 'Code applied (${promoCode.toStringAsFixed(0)}%)' : '',
                            style: GoogleFonts.elMessiri(
                              fontSize: 18,
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFD8200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0, bottom: 3.0),
                            child: Center(
                              child: Text(
                                'Apply Code',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.grey[900],
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          getLocation();
                          try {
                            await FirebaseFirestore.instance.collection('PromoCodes').where('Code', isEqualTo: promoCodeController.text).get().then((promoCodeValue) {
                              if (promoCodeValue.docs.isNotEmpty) {
                                if (DateTime.tryParse(promoCodeValue.docs.first.data()['ExpiryDate'].toDate().toString())?.isAfter(DateTime.now()) == true &&
                                    promoCodeValue.docs.first.data()['Valid'] == true) {
                                  setState(() {
                                    promoCode = double.tryParse(promoCodeValue.docs.first.data()['DiscountRate'].toString())!;
                                  });
                                  greenSnak(context, 'Promotion Code Applied');
                                } else {
                                  redSnak(context, 'Promotion Code is expired');
                                }
                              } else {
                                redSnak(context, 'Promotion Code not found');
                              }
                            });
                          } catch (e) {
                            print(e);
                            redSnak(context, 'Invalid Promotion Code');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffFD8200),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: GoogleFonts.elMessiri(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          LineIcons.arrowCircleRight,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  // print(userLatLong);
                  FocusManager.instance.primaryFocus?.unfocus(); // This to hide the Keyboard
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => InvoiceInfo(
                            userData: widget.userData,
                            userLatLong: userLatLong,
                            paymentType: paymentType,
                            promoCodeValue: promoCode,
                            promoCode: promoCodeController.text.isEmpty ? 'No Code':promoCodeController.text,
                          )));
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
