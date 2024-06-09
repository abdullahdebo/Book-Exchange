import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Authentication/SplashScreen.dart';
import 'firebase_options.dart';

bool showCartBadges = false;
int cartBadgeCount = 0 ;
List <Map<String , dynamic>> cartItems = [];


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book Exchange App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
  // Test Git Commit
}

