import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_circuler/firebase_options.dart';
import 'package:job_circuler/screens/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:job_circuler/splash_screen.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:DefaultFirebaseOptions.currentPlatform);
        runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
         primaryColor: const Color(0xffFCD733), // #f7f7f7
        disabledColor: const Color(0xFFA4A4A4), // #a4a4a4
        scaffoldBackgroundColor: const Color(0xffF4F2F3),
        textTheme: TextTheme(
          // Define your text styles here
          displayLarge: GoogleFonts.lato(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          displayMedium: GoogleFonts.lato(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: GoogleFonts.lato(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: GoogleFonts.lato(fontSize: 14.0, color: Colors.black), 
          bodySmall: GoogleFonts.lato(fontSize: 12.0, color: const Color(0xFFA4A4A4))
        ),
        useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(background: const Color(0xFFF7F7F7)),
      ),
      home: const SplashScreen()
    );
  }
}

