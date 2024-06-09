import 'dart:async';
import 'package:book_exchage2/DashBoard/Dashboard.dart';
import 'package:book_exchage2/Modules/SnackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../DashBoard/Dashboard.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePasswordText = true;
  bool isLoginActivated = true;
  TextEditingController signUpFirstLastNameController = TextEditingController();
  TextEditingController signUpPhoneNumberController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();

  get userDoc => null;

  Object? get userData => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1a1927),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Visibility(
          visible: isLoginActivated,
          //SignUp Design
          replacement: signUpScreenDesign(context),
          //Login Design
          child: loginScreenDesign(context),
        ),
      ),
    );
  }

  Widget loginScreenDesign(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
            height: 250,
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage('https://i.pinimg.com/736x/dd/64/da/dd64da585bc57cb05e5fd4d8ce873f57.jpg'), fit: BoxFit.fill
                    // image: AssetImage('assets/images/BookExchangeLogo.png')
                    )),
          ),
        ),
        Center(
          child: Text(
            'Login',
            style: GoogleFonts.elMessiri(
              color: Colors.white,
              fontSize: 35,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(8), boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 5.0,
                offset: Offset(0, 3),
              )
            ]),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: GoogleFonts.elMessiri(
                          color: Colors.grey[600],
                          fontSize: 23,
                        )),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscurePasswordText,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: GoogleFonts.elMessiri(
                          color: Colors.grey[600],
                          fontSize: 23,
                        ),
                        suffixIcon: IconButton(
                          icon: obscurePasswordText == true
                              ? Icon(
                                  Icons.remove_red_eye,
                                )
                              : Icon(
                                  Icons.remove_red_eye_outlined,
                                ),
                          color: Color(0xff1a1927),
                          onPressed: () {
                            if (obscurePasswordText == true) {
                              setState(() {
                                obscurePasswordText = false;
                              });
                            } else {
                              setState(() {
                                obscurePasswordText = true;
                              });
                            }
                          },
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
        Center(
          child: GestureDetector(
            onTap: () async {
              blueSnak(context, 'working on it');
              Future.delayed(Duration(seconds: 2), () {
                sendRecoveryPass();
              });
            },
            child: Text(
              'ForgetPassword?',
              style: GoogleFonts.elMessiri(
                color: Colors.white.withOpacity(0.5),
                fontSize: 15,
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Center(
          child: InkWell(
            onTap: () {
              print('Login Button Pressed');
              userLogInInputValidation(context);
            },
            child: Container(
              height: 45,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff3DA925),
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: GoogleFonts.elMessiri(
                    color: Colors.white,
                    fontSize: 27,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isLoginActivated = false;
              });
              clearControllers();
            },
            child: Text(
              'Don\'t have an account?',
              style: GoogleFonts.elMessiri(
                color: Colors.white.withOpacity(0.5),
                fontSize: 15,
              ),
            ),
          ),
        )

        //   SizedBox(
        //   height: MediaQuery.of(context).size.height / 2.5,
        // ),
      ],
    );
  }

  Widget signUpScreenDesign(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
            height: 250,
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage('https://i.pinimg.com/736x/dd/64/da/dd64da585bc57cb05e5fd4d8ce873f57.jpg'), fit: BoxFit.fill
                    // image: AssetImage('assets/images/BookExchangeLogo.png')
                    )),
          ),
        ),
        Center(
          child: Text(
            'SignUp',
            style: GoogleFonts.elMessiri(
              color: Colors.white,
              fontSize: 35,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(8), boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 5.0,
                offset: Offset(0, 3),
              )
            ]),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  child: TextField(
                    controller: signUpFirstLastNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'First & Last Name',
                      hintStyle: GoogleFonts.elMessiri(
                        fontSize:23,
                        color:Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  child: TextField(
                    controller: signUpPhoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Phone Number',
                      hintStyle: GoogleFonts.elMessiri(
                        fontSize:23,
                        color:Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  child: TextField(
                    controller: signUpEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: GoogleFonts.elMessiri(
                        fontSize:23,
                        color:Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  )),
                  child: TextField(
                    controller: signUpPasswordController,
                    obscureText: obscurePasswordText,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'PassWord',
                        hintStyle: GoogleFonts.elMessiri(
                          fontSize:23,
                          color:Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          icon: obscurePasswordText == true
                              ? Icon(
                                  Icons.remove_red_eye,
                                )
                              : Icon(
                                  Icons.remove_red_eye_outlined,
                                ),
                          color: Color(0xff1a1927),
                          onPressed: () {
                            if (obscurePasswordText == true) {
                              setState(() {
                                obscurePasswordText = false;
                              });
                            } else {
                              setState(() {
                                obscurePasswordText = true;
                              });
                            }
                          },
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 40),
        Center(
          child: InkWell(
            onTap: () {
              print('Login Button Pressed');
              userSignUpInputValidation(context);
            },
            child: Container(
              height: 45,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff3DA925),
              ),
              child: Center(
                child: Text(
                  'Create Account',
                  style: GoogleFonts.elMessiri(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isLoginActivated = true;
              });
              clearControllers();
            },
            child: Text(
              'Have an account?',
              style: GoogleFonts.elMessiri(
                color: Colors.white.withOpacity(0.5),
                fontSize: 15,
              ),
            ),
          ),
        )

        //   SizedBox(
        //   height: MediaQuery.of(context).size.height / 2.5,
        // ),
      ],
    );
  }

  sendRecoveryPass() async {
    if (emailController.text.isEmpty || emailController.text.contains('@') == false || emailController.text.contains('.com') == false) {
      orangeSnak(context, 'Invalid Email');
    } else {
      await FirebaseFirestore.instance.collection('UsersAccount').where('UserEmail', isEqualTo: emailController.text).get().then((whereResult) async {
        if (whereResult.docs.isEmpty) {
          redSnak(context, 'there is no record for this email');
        } else {
          try {
            await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text).then((metaData) {
              greenSnak(context, 'Reset password email sent👍');
              passwordController.clear();
            });
          } catch (e) {
            redSnak(context, 'there is no record for this email');
          }
        }
      });
    }
  }

  clearControllers() {
    signUpFirstLastNameController.clear();
    signUpPhoneNumberController.clear();
    signUpEmailController.clear();
    signUpPasswordController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void userLogInInputValidation(BuildContext context) {
    if (emailController.text.isEmpty || emailController.text.contains('@') == false || emailController.text.contains('.com') == false) {
      redSnak(context, 'Invalid Email');
    } else if (passwordController.text.isEmpty || passwordController.text.length < 9) {
      redSnak(context, 'PassWord too short');
    } else {
      orangeSnak(context, 'Validation Completed😍');
      Future.delayed(Duration(seconds: 2), () {
        loginuser();
      });
    }
  }

  void userSignUpInputValidation(BuildContext context) {
    print(signUpPasswordController.text.length);
    if (signUpFirstLastNameController.text.isEmpty || signUpFirstLastNameController.text.length < 6) {
      redSnak(context, 'invalid First And Last Name');
    } else if (signUpPhoneNumberController.text.isEmpty || signUpPhoneNumberController.text.contains('05') == false || signUpPhoneNumberController.text.length < 10) {
      redSnak(context, 'invalid Phone Number');
    } else if (signUpEmailController.text.isEmpty || signUpEmailController.text.contains('@') == false || signUpEmailController.text.contains('.com') == false) {
      redSnak(context, 'invalid Email');
    } else if (signUpPasswordController.text.isEmpty || signUpPasswordController.text.length < 9) {
      redSnak(context, 'invalid PassWord');
    } else {
      signupAndCreateUserAccount(context);
    }
  }

  Future loginuser() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).then((userCredentials) async {
        if (userCredentials.user?.uid != null) {
          print('UserId ${userCredentials.user!.uid}');
          if (userCredentials.user?.emailVerified == false) {
            clearControllers();
            await userCredentials.user?.sendEmailVerification();
            await FirebaseAuth.instance.signOut().then((value) {
              orangeSnak(context, 'Please verify your email');
            });
          } else {
            print('email verified');
            // Here we get the user data from the Firebase Firestore after we sign in the user.
            await FirebaseFirestore.instance.collection('UsersAccount').doc(userCredentials.user?.uid).get().then((userDoc) async{
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder:(BuildContext context )=>Dashboard(userData:userDoc)));
            });
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signupAndCreateUserAccount(BuildContext context) async {
    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the overlay
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    Future.delayed(Duration(seconds: 3), () async {
      DocumentSnapshot<Map<String, dynamic>> userData;
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: signUpEmailController.text,
          password: signUpPasswordController.text,
        )
            .then((userCredentials) async {
          final user = userCredentials.user;
          if (user != null) {
            await userCredentials.user?.sendEmailVerification().then((metaData) async {
              try {
                await FirebaseFirestore.instance.collection('UsersAccount').doc(user.uid).set({
                  'UserId': user.uid,
                  'UserEmail': user.email,
                  'UserName': signUpFirstLastNameController.text,
                  'UserPhoneNumber': signUpPhoneNumberController.text,
                  'AccountCreatedDateTime': DateTime.now(),
                }).then((value) async {
                  await FirebaseFirestore.instance.collection('UsersAccount').doc(user.uid).get().then((userDBData) {
                    setState(() {
                      userData = userDBData;
                    });
                  }).then((value) async {
                    clearControllers();
                    await FirebaseAuth.instance.signOut();
                    greenSnak(context, 'Verification Email Sent✌️');
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        isLoginActivated = true;
                      });
                    });
                    Navigator.of(context).pop(); // Hide loading overlay
                    // greenSnak(context, 'Account created successfully 👍');
                  });
                });
              } catch (e) {
                await FirebaseAuth.instance.currentUser?.delete().then((value) async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pop(); // Hide loading overlay
                    redSnak(context, 'Error');
                  });
                });
              }
            });
          }
        });
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop(); // Hide loading overlay
        if (!mounted) return; // Check the sync is done before show UI components
        redSnak(context, e.message!.trim());
      }
    });
  }
}

// Column, Row, ListView, ListView.Builder, Grid, Grid.Builder, Wrap => Multiple widgets
