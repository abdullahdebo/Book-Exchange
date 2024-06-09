import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

redSnak(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: 3),
    elevation: 0,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.elMessiri(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  ));
}


greenSnak(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: 3),
    elevation: 0,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.elMessiri(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  ));
}


orangeSnak(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: 3),
    elevation: 0,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange[700],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.elMessiri(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  ));
}


blueSnak(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: 3),
    elevation: 0,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.elMessiri(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  ));
}

