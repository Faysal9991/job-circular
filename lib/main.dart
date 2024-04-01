import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:job_circuler/firebase_options.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/admin/provider/admin_provider.dart';
import 'package:job_circuler/screens/pick_image/widget/provider/pick_image_provider.dart';
import 'package:job_circuler/splash_screen.dart';
import 'package:provider/provider.dart';

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MultiProvider(providers: [
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => AdminProvider()),
            ChangeNotifierProvider(create: (context) => DashBoardProvider()),
            ChangeNotifierProvider(create: (context) => ImagePickProvider()),
          ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      // provider.getTheme();
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          theme: provider.isdark
              ? AppTheme.getDarkModeTheme()
              : AppTheme.getLightModeTheme(),
          home: const SplashScreen());
    });
  }
}

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static ThemeData getLightModeTheme() {
    return ThemeData(
      primaryColor: Colors.blue, // #f7f7f7
      disabledColor: const Color(0xFFA4A4A4), // #a4a4a4
      scaffoldBackgroundColor: const Color(0xffF4F2F3),
      datePickerTheme: DatePickerThemeData(
        elevation: 05,
        backgroundColor: Colors.white,
        headerBackgroundColor: Colors.blue,
        yearBackgroundColor:
            MaterialStateProperty.all(Colors.white.withOpacity(0.2)),
        headerForegroundColor: Colors.white,
        dayOverlayColor: MaterialStateProperty.all(Colors.blue),
        dayBackgroundColor:
            MaterialStateProperty.all(Colors.blue.withOpacity(0.3)),
        cancelButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        confirmButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),

      textTheme: TextTheme(
          // Define your text styles here
          displayLarge: GoogleFonts.lato(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          displayMedium: GoogleFonts.lato(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: GoogleFonts.lato(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: GoogleFonts.lato(fontSize: 14.0, color: Colors.black),
          bodySmall:
              GoogleFonts.lato(fontSize: 12.0, color: const Color(0xFFA4A4A4))),
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
          .copyWith(background: const Color(0xFFF7F7F7)),
    );
  }

  static ThemeData getDarkModeTheme() {
    return ThemeData(
      primaryColor: Colors.blue, // #f7f7f7
      disabledColor: const Color(0xFFA4A4A4), // #a4a4a4
      scaffoldBackgroundColor: Colors.black,
      datePickerTheme: DatePickerThemeData(
        elevation: 05,
        backgroundColor: Colors.white,
        headerBackgroundColor: Colors.blue,
        yearBackgroundColor:
            MaterialStateProperty.all(Colors.white.withOpacity(0.2)),
        headerForegroundColor: Colors.white,
        dayOverlayColor: MaterialStateProperty.all(Colors.blue),
        dayBackgroundColor:
            MaterialStateProperty.all(Colors.blue.withOpacity(0.3)),
        cancelButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        confirmButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
      textTheme: TextTheme(
          // Define your text styles here
          displayLarge: GoogleFonts.lato(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: GoogleFonts.lato(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: GoogleFonts.lato(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: GoogleFonts.lato(fontSize: 14.0, color: Colors.white),
          bodySmall:
              GoogleFonts.lato(fontSize: 12.0, color: const Color(0xFFA4A4A4))),
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
          .copyWith(background: const Color(0xFFF7F7F7)),
    );
  }
}
