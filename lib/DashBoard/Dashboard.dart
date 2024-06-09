// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'package:book_exchage2/CartPages/CartPage.dart';
import 'package:book_exchage2/Modules/CartModule.dart';
import 'package:book_exchage2/Modules/SnackBar.dart';
import 'package:book_exchage2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../DrwarPages/MyBooks.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:badges/badges.dart' as badges; // This import has been imported using (Prefix) so you need to use the prefix
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Dashboard extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> userData;
  const Dashboard({super.key, required this.userData});

  @override
  State<Dashboard> createState() => _DashboardState();
}

final _advancedDrawerController = AdvancedDrawerController();
QuerySnapshot<Map<String, dynamic>>? latestBooks;
QuerySnapshot<Map<String, dynamic>>? worldBestBooks;

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    initiateFirebaseNotification();
    getLatestBooks();
    getWorldBestBooks();
    getCartBadgeValue();
  }

  Future <bool> initiateFirebaseNotification()async{
    bool insureInit;
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      insureInit =true;
      messaging.getToken().then((token) async{
        await updateUserNotificationToken(token!);
      });
      print('User granted permission ✅');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      insureInit =true;
      messaging.getToken().then((token) async{
        await updateUserNotificationToken(token!);
      });
      print('User granted provisional permission ✅');
    } else {
      insureInit =false;
      print('User declined or has not accepted permission ❌');
    }
    return insureInit;
  }

  updateUserNotificationToken(String token)async {
  await FirebaseFirestore.instance.collection('UsersAccounts').doc(widget.userData.id).update({
    'FBNotificationToken':token,
  });
}

  getWorldBestBooks() async {
    Future.delayed(Duration(seconds: 2));
    FirebaseFirestore.instance.collection('Books').where('WorldRating', isGreaterThanOrEqualTo: 2).orderBy('CreatAt', descending: true).limit(20).snapshots().listen((value) {
      if (!mounted) return;
      setState(() {
        worldBestBooks = value;
      });
    });
  }

  getLatestBooks() async {
    Future.delayed(Duration(seconds: 2));
    FirebaseFirestore.instance.collection('Books').where('Sold', isEqualTo: false).orderBy('CreatAt', descending: true).limit(20).snapshots().listen((value) {
      if (!mounted) return;
      setState(() {
        latestBooks = value;
      });
    });
  }

  getCartBadgeValue() {
    if (CartModule().getCartItemsQTY() > 0) {
      if (!mounted) return;
      setState(() {
        showCartBadges = true;
        cartBadgeCount = CartModule().getCartItemsQTY();
      });
    } else {
      if (!mounted) return;
      setState(() {
        showCartBadges = false;
        cartBadgeCount = 0;
      });
    }
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Color(0xff1a1927),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: EdgeInsets.only(
                  top: 24,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[800],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://cdn-icons-png.flaticon.com/512/219/219988.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                widget.userData.data()?['UserName'],
                style: GoogleFonts.elMessiri(
                  color: Colors.white,
                  fontSize: 21,
                ),
              ),
              SizedBox(
                height: 55,
              ),
              ListTile(
                onTap: () {},
                leading: Icon(LineIcons.bell),
                title: Text(
                  'notifications',
                  style: GoogleFonts.elMessiri(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(LineIcons.neutralFace),
                title: Text(
                  'Profile',
                  style: GoogleFonts.elMessiri(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => MyBooks(userData: widget.userData)));
                },
                leading: Icon(LineIcons.book),
                title: Text(
                  'My Books',
                  style: GoogleFonts.elMessiri(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(LineIcons.fileInvoiceWithUsDollar),
                title: Text(
                  'My Orders',
                  style: GoogleFonts.elMessiri(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Material(
                    color: Color(0xffFD8200),
                    type: MaterialType.card,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SignOut',
                            style: GoogleFonts.elMessiri(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0xff1a1927),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 50),
            children: [
              headerSection(context),
              fastController(context),
              worldBestBooksSection(context),
              latestSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerSection(BuildContext context) {
    return Column(
      children: [
        //THE HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: _handleMenuButtonPressed,
                    child: Material(
                      color: Colors.orange[800],
                      type: MaterialType.card,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ValueListenableBuilder<AdvancedDrawerValue>(
                          valueListenable: _advancedDrawerController,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: Duration(milliseconds: 250),
                              child: Icon(
                                value.visible ? Icons.clear : Icons.toc_outlined,
                                color: Colors.white,
                                size: 25,
                                key: ValueKey<bool>(value.visible),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hava a Nice Day',
                        style: GoogleFonts.elMessiri(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 15,
                        )),
                    Text(
                      widget.userData.data()?['UserName'],
                      style: GoogleFonts.elMessiri(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Material(
                      color: Colors.orange[800],
                      type: MaterialType.circle,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    child: badges.Badge(
                      badgeColor: Colors.white,
                      showBadge: showCartBadges,
                      badgeContent: Text(
                        cartBadgeCount.toString(),
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Material(
                        color: Colors.orange[800],
                        type: MaterialType.circle,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => CartPage(userData: widget.userData)));
                    },
                  ),
                ),
                if (showCartBadges)
                  SizedBox(
                    width: 10,
                  ),
              ],
            ),
          ],
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget fastController(BuildContext context) {
    return Column(
      children: [
        //Fast Controls
        Padding(
          padding: EdgeInsets.only(right: 25, left: 25),
          child: Material(
            color: Colors.white10,
            type: MaterialType.card,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.api,
                        color: Colors.orange[800],
                        size: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Redeem',
                          style: GoogleFonts.elMessiri(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 3,
                    height: 25,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.wallet,
                        color: Colors.orange[800],
                        size: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Wallet',
                          style: GoogleFonts.elMessiri(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 27),
      ],
    );
  }

  Widget worldBestBooksSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //World Best
        Text(
          'World Best🔥',
          style: GoogleFonts.elMessiri(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        //List_View_Builder
        bookFlowList(context),
        SizedBox(height: 15),
      ],
    );
  }

  Widget bookFlowList(BuildContext context) {
    if (worldBestBooks != null) {
      return SizedBox(
        height: 236,
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          scrollDirection: Axis.horizontal,
          itemCount: worldBestBooks?.docs.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                itemDetailBottomSheet(context, worldBestBooks!.docs[index]);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 17),
                child: SizedBox(
                  height: 236,
                  width: 145,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 210,
                        width: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                          image: DecorationImage(image: NetworkImage(worldBestBooks?.docs[index].data()['BookImage']), fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Text(
                                  timeago.format(worldBestBooks?.docs[index].data()['CreatAt'].toDate(), locale: 'en_short'),
                                  style: GoogleFonts.elMessiri(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_half,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Text(
                                  worldBestBooks!.docs[index].data()['WorldRating'].toString(),
                                  style: GoogleFonts.elMessiri(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return SizedBox(
        height: 1,
      );
    }
  }

  Widget latestSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Latest Section
        Text(
          'Latest 📚',
          style: GoogleFonts.elMessiri(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Sorted Best World Rank',
          style: GoogleFonts.elMessiri(
            fontSize: 16,
            color: Colors.white.withOpacity(0.2),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 25),
        //List_View_Builder
        latestFlowList(context),
      ],
    );
  }

  Widget latestFlowList(BuildContext context) {
    if (latestBooks != null) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: latestBooks!.docs.length,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              itemDetailBottomSheet(context, worldBestBooks!.docs[index]);
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: SizedBox(
                height: 200,
                width: double.maxFinite,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160,
                      width: 105,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: NetworkImage(latestBooks?.docs[index].data()['BookImage']),
                            fit: BoxFit.fill,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 253,
                                child: Text(
                                  latestBooks!.docs[index].data()['BookName'].toString(),
                                  style: GoogleFonts.elMessiri(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                width: 253,
                                child: Text(
                                  latestBooks?.docs[index].data()['BookWriter'],
                                  style: GoogleFonts.elMessiri(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '📃',
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        latestBooks?.docs[index].data()['NumberOfPages'],
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '⭐',
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        latestBooks!.docs[index].data()['WorldRating'].toString(),
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '💵',
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        latestBooks?.docs[index].data()['BookPrice'],
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        ' SAR',
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Condition :',
                                    style: GoogleFonts.elMessiri(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    latestBooks?.docs[index].data()['BookCondition'],
                                    style: GoogleFonts.elMessiri(
                                      color: switchConditionColor(latestBooks?.docs[index].data()['BookCondition']),
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Published :',
                                    style: GoogleFonts.elMessiri(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    latestBooks?.docs[index].data()['PublishedYear'],
                                    style: GoogleFonts.elMessiri(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: Material(
                                      color: Colors.deepPurpleAccent[100]?.withOpacity(0.17),
                                      borderRadius: BorderRadius.circular(1),
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 1),
                                        child: Text(
                                          latestBooks?.docs[index].data()['BookType'],
                                          style: GoogleFonts.elMessiri(
                                            color: Colors.deepPurpleAccent[100],
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return SizedBox(
        height: 1,
      );
    }
  }

  Color switchConditionColor(String condition) {
    Color returnValue;
    switch (condition) {
      case 'Good':
        {
          returnValue = Colors.greenAccent;
        }
        break;
      case 'Medium':
        {
          returnValue = Colors.orangeAccent;
        }
        break;
      case 'Low':
        {
          returnValue = Colors.redAccent;
        }
        break;
      default:
        {
          returnValue = Colors.white;
        } // default color
    }
    return returnValue;
  }

  itemDetailBottomSheet(BuildContext context, DocumentSnapshot<Map<String, dynamic>> item) {
    return showMaterialModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
            child: SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color(0xff1a1927),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 275,
                        width: 175,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: NetworkImage(item.data()!['BookImage'].toString()),
                              fit: BoxFit.fill,
                            )),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        item.data()!['BookName'],
                        style: GoogleFonts.elMessiri(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        item.data()!['BookWriter'],
                        style: GoogleFonts.elMessiri(
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                '📖',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '${item.data()!['NumberOfPages']}p',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '⭐',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                ' ${item.data()!['WorldRating']}',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '🕛',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                ' ${item.data()!['PublishedYear']}',
                                style: GoogleFonts.elMessiri(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Material(
                        color: Colors.orangeAccent.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(1),
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text(
                            item.data()!['BookType'],
                            style: GoogleFonts.elMessiri(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          item.data()!['BookDescription'],
                          style: GoogleFonts.elMessiri(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '💵',
                            style: GoogleFonts.elMessiri(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' ${double.tryParse(item.data()!['BookPrice'].toString())!.toStringAsFixed(2)}',
                            style: GoogleFonts.elMessiri(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'SAR',
                            style: GoogleFonts.elMessiri(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      //CANCEL & ADD TO CART BUTTON
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Container(
                                width: 125,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Cancel',
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        LineIcons.stopCircle,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            if(item.data()?['Sold']==false)
                            InkWell(
                              child: Container(
                                width: 170,
                                decoration: BoxDecoration(
                                  color: Colors.orange[800],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add to Cart',
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        LineIcons.shoppingCart,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (item.data() != null) {
                                  await CartModule().addToCart(item.data()!).then((value) async {
                                    print(CartModule().getCartItemsQTY());
                                    if (value == 'items Added Successfully' || value == 'items Already In Your Cart') {
                                      if (!mounted) return;
                                      setState(() {
                                        showCartBadges = true;
                                        cartBadgeCount = CartModule().getCartItemsQTY();
                                        greenSnak(context, value);
                                      });
                                    } else {
                                      if (!mounted) return;
                                      setState(() {
                                        showCartBadges = true;
                                        cartBadgeCount = CartModule().getCartItemsQTY();
                                        greenSnak(context, value);
                                      });
                                    }
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
