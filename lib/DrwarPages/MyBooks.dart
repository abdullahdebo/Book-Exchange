import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'NewBook.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({super.key, required this.userData});
  final DocumentSnapshot<Map<String, dynamic>> userData;
  @override
  State<MyBooks> createState() => _MyBooksState();
}
class _MyBooksState extends State<MyBooks> {
  QuerySnapshot<Map<String, dynamic>>? myBooks;

  @override
  void initState(){
  getMyBooks();
  super.initState();
}

getMyBooks()async{
     Future.delayed(Duration(seconds: 2));
     FirebaseFirestore.instance.collection('Books')
      .where('UserId', isEqualTo:widget.userData.id)
      .orderBy('CreatAt',descending: true)
      .snapshots().listen((value){
        setState((){
        myBooks=value;
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1a1927),
      appBar: AppBar(
        toolbarHeight: 57.0,
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color(0xff1a1927),
        elevation: 10,
        title: Text(
            'MyBooks',
             style:GoogleFonts.elMessiri(
            color:Colors.white,
            fontSize:27,
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Icon(
                    LineIcons.bookOpen,
                    size: 30,
                    color: Colors.white,
                  ),
                  onTap: (){
                    Navigator.of(context).push(CupertinoPageRoute(builder:(BuildContext context )=>NewBook(userData:widget.userData)));
                  },
                ),
                Text(
                    'New',
                style:GoogleFonts.elMessiri(
                  color:Colors.white,
                   fontSize:17,
                ),
                )
              ],
            ),
          ),
        ],
      ),
      body: flowList(context)
    );
  }


  Widget flowList(BuildContext context ){
    if(myBooks!=null){
      return  Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: myBooks!.docs.length,
          itemBuilder: (context , index){
            return  Padding(
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
                            image: NetworkImage(myBooks?.docs[index].data()['BookImage']),
                            fit: BoxFit.fill,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12,),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 253,
                                child: Text(
                                  myBooks!.docs[index].data()['BookName'].toString(),
                                  style: GoogleFonts.elMessiri(
                                    color: Colors.white,
                                    fontSize: 20,
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
                                  myBooks?.docs[index].data()['BookWriter'],
                                  style: GoogleFonts.elMessiri(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: 5,),
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
                                        myBooks?.docs[index].data()['NumberOfPages'],
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 15,),
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
                                        myBooks!.docs[index].data()['WorldRating'].toString(),
                                        style: GoogleFonts.elMessiri(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 15,),
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
                                        myBooks?.docs[index].data()['BookPrice'],
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
                              SizedBox(height: 5,),
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
                                    myBooks?.docs[index].data()['BookCondition'],
                                    style: GoogleFonts.elMessiri(
                                      color: switchConditionColor( myBooks?.docs[index].data()['BookCondition']),
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7,),
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
                                    myBooks?.docs[index].data()['PublishedYear'],
                                    style: GoogleFonts.elMessiri(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8,),
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
                                          myBooks?.docs[index].data()['BookType'],
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
            );
          },
        ),
      );
    }else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }


  Color switchConditionColor(String condition) {
    Color returnValue;
    switch (condition) {
      case 'Good':{returnValue = Colors.greenAccent;}break;
      case 'Medium':{returnValue = Colors.orangeAccent;}break;
      case 'Low':{returnValue = Colors.redAccent;}break;
      default:
        {returnValue = Colors.white;} // default color
    }
    return returnValue;
  }
}
