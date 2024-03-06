import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:job_circuler/firebase_options.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/admin/admin_first_screen.dart';
import 'package:job_circuler/screens/admin/provider/admin_provider.dart';
import 'package:job_circuler/screens/home/dashboard_Screen.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:job_circuler/screens/pick_image/widget/provider/pick_image_provider.dart';
import 'package:job_circuler/splash_screen.dart';
import 'package:provider/provider.dart';
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received");
  }
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(
          primaryColor: const Color(0xffFCD733), // #f7f7f7
          disabledColor: const Color(0xFFA4A4A4), // #a4a4a4
          scaffoldBackgroundColor: const Color(0xffF4F2F3),
          textTheme: TextTheme(
              // Define your text styles here
              displayLarge: GoogleFonts.lato(
                  fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
              displayMedium: GoogleFonts.lato(
                  fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
              bodyLarge: GoogleFonts.lato(
                  fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
              bodyMedium: GoogleFonts.lato(fontSize: 14.0, color: Colors.black),
              bodySmall: GoogleFonts.lato(fontSize: 12.0, color: const Color(0xFFA4A4A4))),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
              .copyWith(background: const Color(0xFFF7F7F7)),
        ),
        home: const AdminFirstScreen());
  }
}

