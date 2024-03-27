import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:job_circuler/provider/auth_provider.dart';
import 'package:job_circuler/screens/home/bookmark_screen.dart';
import 'package:job_circuler/screens/home/calculator.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:job_circuler/screens/profile/profile.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
 
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BookMarkPage(),
    CalculatorScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(builder: (context, provider, child) {
          return Center(
            child: _widgetOptions.elementAt(provider.selectedIndex),
          );
        }
      ),
      bottomNavigationBar: Consumer<AuthProvider>(builder: (context, provider, child) {
        return GNav(
          backgroundColor: Colors.grey.withOpacity(0.1),
          // tab button hover color
          haptic: true, // haptic feedback
          tabBorderRadius: 10, // tab button border
          style: GnavStyle.google,
          curve: Curves.easeOutExpo, // tab animation curves
          duration: const Duration(milliseconds: 900), // tab animation duration
          gap: 5, // the tab button gap between icon and text
          color: provider.isdark?Colors.white:Colors.black, // unselected icon color
          activeColor:Colors.white, // selected icon and text color
          iconSize: 15, // tab button icon size
          tabBackgroundColor: Colors.blue, // selected tab background color
          textSize: 10,
          
          textStyle:Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
          // navigation bar padding
          tabs: const [
            GButton(
              icon: LineIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: LineIcons.bookmark,
              text: 'BookMark',
            ),
             GButton(
              icon: LineIcons.calculator,
              text: 'Calculator',
            ),
            GButton(
              icon: LineIcons.user,
              text: 'Profile',
            )
          ],
          selectedIndex: provider.selectedIndex,
          onTabChange: (index) {
          
             provider.changeselectedIndex(index);
            
          },
        );
      }),
    );
  }
}
