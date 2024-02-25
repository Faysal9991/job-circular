import 'package:flutter/material.dart';
import 'package:job_circuler/screens/auth/login.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
   Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));

  setState(() {});
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