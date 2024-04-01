import 'package:flutter/material.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/provider/dashboard_provider.dart';
import 'package:job_circuler/screens/home/dashboard_Screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
  var provider = Provider.of<AuthProvider>(context, listen: false); // <==== Service from Provider, which contains data for _isEmailVerified
      var dashboard_provider = Provider.of<DashBoardProvider>(context, listen: false);
      provider.getTheme();
      dashboard_provider.configureFirebaseMessaging();
   dashboard_provider.configureLocalNotifications();
    Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DashboardScreen()));

    
   
});
    super.initState();
  }
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: LottieBuilder.asset("assets/svg/loading.json",)),
          Text("Welcome to JobFinder",style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blue),)
        ],
      ),
    );
  }
}