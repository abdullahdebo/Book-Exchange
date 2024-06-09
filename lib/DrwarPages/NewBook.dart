import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'as path;
import 'package:book_exchage2/Modules/SnackBar.dart';
import 'dart:io';

class NewBook extends StatefulWidget {
  const NewBook({super.key, required this.userData});
  final DocumentSnapshot<Map<String,dynamic>> userData;
  @override
  State<NewBook> createState() => _NewBookState();
}
class _NewBookState extends State<NewBook> {
  XFile ? selectedImage;
  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookWriterNameController = TextEditingController();
  TextEditingController numberOfPagesController = TextEditingController();
  TextEditingController worldRatingController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController publishYearController = TextEditingController();
  TextEditingController iSBNCController = TextEditingController();
  TextEditingController bookDescriptionController = TextEditingController();
  var bookCondition;
  var bookType;
Future getProductImage() async {
  try {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
     setState((){
       selectedImage = image;
       });
    }
}catch(e){
    print(e);
    redSnak(context, 'Book image Invalid');
  }
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
          'New Book',
          style: GoogleFonts.elMessiri(
            color: Colors.white,
            fontSize: 27,
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
                    Icons.clear,
                    size: 30,
                    color: Colors.red,
                  ),
                  onTap: () {
                    setState(() {
                      bookNameController.clear();
                      bookWriterNameController.clear();
                      numberOfPagesController.clear();
                      worldRatingController.clear();
                      priceController.clear();
                      publishYearController.clear();
                      iSBNCController.clear();
                      bookDescriptionController.clear();
                    });
                  },
                ),
                Text(
                  'Clear',
                  style: GoogleFonts.elMessiri(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: ListView(
          children: [
            Text(
              '* Please Make Sure That all Information Is Correct',
              style: GoogleFonts.elMessiri(
                color: Colors.red,
                fontSize: 19,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: selectedImage == null
                  ? Container(
                      height: 230,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Text(
                          'Choose Book Picture',
                          style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 19),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container(
                      height: 230,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.3),
                          image: DecorationImage(
                              image: FileImage(File(selectedImage!.path)),
                              fit: BoxFit.fill)),
                    ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: InkWell(
                child: Icon(
                  LineIcons.photoVideo,
                  size: 50,
                  color: Colors.orange[800],
                ),
                onTap: (){
                  getProductImage();
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              color: Color(0xff1a1927),
              elevation: 12,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                      ),
                    )
                  ),
                  child: TextField(
                    controller: bookNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Book Name',
                      hintStyle: GoogleFonts.elMessiri(
                        color:Colors.grey,
                        fontSize:20
                      ),
                    ),
                    style: GoogleFonts.elMessiri(
                      color:Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xff1a1927),
              elevation: 12,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                        ),
                      )
                  ),
                  child: TextField(
                    controller: bookWriterNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Book Writer Name',
                      hintStyle: GoogleFonts.elMessiri(
                        color:Colors.grey,
                          fontSize:20
                      ),
                    ),
                    style: GoogleFonts.elMessiri(
                        color:Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xff1a1927),
              elevation: 12,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                        ),
                      )
                  ),
                  child: TextField(
                    controller: numberOfPagesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Number Of Pages',
                      hintStyle: GoogleFonts.elMessiri(
                        color:Colors.grey,
                          fontSize:20
                      ),
                    ),
                    style: GoogleFonts.elMessiri(
                        color:Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xff1a1927),
              elevation: 12,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                        ),
                      )
                  ),
                  child: TextField(
                    controller: worldRatingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'World Rating',
                      hintStyle: GoogleFonts.elMessiri(
                        color:Colors.grey,
                          fontSize:20
                      ),
                    ),
                    style: GoogleFonts.elMessiri(
                        color:Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xff1a1927),
              elevation: 12,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                        ),
                      )
                  ),
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Price',
                      hintStyle: GoogleFonts.elMessiri(
                        color:Colors.grey,
                          fontSize:20
                      ),
                    ),
                    style: GoogleFonts.elMessiri(
                        color:Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xff1a1927),
              elevation: 12,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                        ),
                      )
                  ),
                  child: TextField(
                    controller: publishYearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Publish Year',
                      hintStyle: GoogleFonts.elMessiri(
                        color:Colors.grey,
                          fontSize:20
                      ),
                    ),
                    style: GoogleFonts.elMessiri(
                        color:Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xff1a1927),
              elevation: 12,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                        ),
                      )
                  ),
                  child: TextField(
                    controller: iSBNCController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ISBN',
                      hintStyle: GoogleFonts.elMessiri(
                        color:Colors.grey,
                          fontSize:20
                      ),
                    ),
                    style: GoogleFonts.elMessiri(
                        color:Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xff1a1927),
              elevation: 12,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                        ),
                      )
                  ),
                  child: TextField(
                    controller: bookDescriptionController,
                    maxLength: 400,
                    maxLines: 9,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Book Description',
                      hintStyle: GoogleFonts.elMessiri(
                        color:Colors.grey,
                          fontSize:20
                      ),
                    ),
                    style: GoogleFonts.elMessiri(
                        color:Colors.white
                    ),
                  ),
                ),
              ),
            ),
            //DropDownMenu (Choose Book Condition )
            Card(
                color: Color(0xff1a1927),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Color(0xff1a1927),
                  ),
                  child: DropdownButton<String>(
                    iconEnabledColor: Colors.transparent,
                    iconDisabledColor: Colors.transparent,
                    iconSize: 8,
                    autofocus: false,
                    borderRadius: BorderRadius.circular(12.0),
                    value: bookCondition,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          bookCondition = value;
                        });
                      }
                    },
                    hint: Padding(
                      padding:EdgeInsets.all(8.0),
                      child: Text(
                        'Choose Book Condition',
                        style: GoogleFonts.elMessiri(color:Colors.white,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    items: <String>[
                      'Good',
                      'Medium',
                      'Low',
                    ].map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            value,
                            style: GoogleFonts.elMessiri(color : Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ),
            //DropDownMenu (Choose Book type )
            Card(
              color: Color(0xff1a1927),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Color(0xff1a1927),
                ),
                child: DropdownButton<String>(
                  iconEnabledColor: Colors.transparent,
                  iconDisabledColor: Colors.transparent,
                  iconSize: 8,
                  autofocus: false,
                  borderRadius: BorderRadius.circular(12.0),
                  value: bookType,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        bookType = value;
                      });
                    }
                  },
                  hint: Padding(
                    padding:EdgeInsets.all(8.0),
                    child: Text(
                      'Choose Book Type',
                      style: GoogleFonts.elMessiri(color:Colors.white,),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  items: <String>[
                    'Adventure',
                    'Horror',
                    'Romantic',
                    'Comedy',
                    'Drama',
                    'Royal',
                    'Crime',
                    'Action',
                    'Science',
                    'Children',
                  ].map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          style: GoogleFonts.elMessiri(color : Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 40,),
            //Save Book Button
            Center(
              child: InkWell(
                onTap: (){
                  validateBookForm(context);
                },
                child: Container(
                  height:45,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffFD8200),
                  ),
                  child: Center(
                    child: Text(
                        'Save Book',
                      style: GoogleFonts.elMessiri(
                        color : Colors.black,
                        fontSize:20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  validateBookForm(context)async{
    if (selectedImage==null){
      redSnak(context, 'Book Image Cannot Be Empty');
    }else if (bookNameController.text.isEmpty){
      redSnak(context, 'Book Name Cannot Be Empty');
    }else if (bookWriterNameController.text.isEmpty){
      redSnak(context, 'Book Writer Cannot Be Empty');
    }else if (numberOfPagesController.text.isEmpty){
      redSnak(context, 'Number Of Page Cannot Be Empty');
    }else if (worldRatingController.text.isEmpty){
      redSnak(context, 'World Rating Cannot Be Empty');
    }else if (priceController.text.isEmpty){
      redSnak(context, 'Price Cannot Be Empty');
    }else if(publishYearController.text.isEmpty){
      redSnak(context, 'Published Year Cannot Be Empty');
    }else if (iSBNCController.text.isEmpty){
      redSnak(context, 'ISBN Cannot Be Empty');
    }else if (bookDescriptionController.text.isEmpty){
      redSnak(context, 'Book Description Year Cannot Be Empty');
    }else if (bookCondition.isEmpty){
      redSnak(context, 'Book Condition Cannot Be Empty');
    }else if (bookType.isEmpty){
      redSnak(context, 'Book Type Cannot Be Empty');
    }else{
      greenSnak(context, 'Saving Your Book , Please Wait...🤗');
      Future.delayed(Duration(seconds: 2),()async{
        await saveUserBook().then((value){
          if (value){
            Navigator.pop(context);
          }else{
            redSnak(context, 'Error');
          }
        });
      });
    }
  }

  Future <bool> saveUserBook()async{
  bool finished=false;
    try{
      String fileName = path.basename(selectedImage!.path);
      await FirebaseStorage.instance.ref('Books/${widget.userData.id}')
          .child(fileName).putFile(File(selectedImage!.path)).then((value)async{
        await value.ref.getDownloadURL().then((imageUrl)async{
          await FirebaseFirestore.instance.collection('Books').add({
            'BookImage':imageUrl.toString(),
            'BookName': bookNameController.text,
            'BookWriter': bookWriterNameController.text,
            'NumberOfPages': numberOfPagesController.text,
            'WorldRating': int.tryParse(worldRatingController.text),
            'BookPrice': priceController.text,
            'PublishedYear': publishYearController.text,
            'BookISBN': iSBNCController.text,
            'BookDescription': bookDescriptionController.text,
            'BookCondition': bookCondition,
            'BookType': bookType,
            'Sold': false,
            'CreatAt': DateTime.now(),
            'UserId':widget.userData.id,
          }).then((value){
            finished=true;
            return finished;
          });
        });
      });
    }catch(e){
      orangeSnak(context, e.toString());
      finished=false;
      return finished;
    }
    return finished;
  }

}