import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:job_circuler/screens/home/bookmark_screen.dart';
import 'package:job_circuler/screens/home/home_screen.dart';
import 'package:job_circuler/screens/profile/profile.dart';
import 'package:line_icons/line_icons.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
   int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BookMarkPage(),
    ProfileScreen()

   ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
         bottomNavigationBar: GNav(
          backgroundColor: Colors.white,
          // tab button hover color
          haptic: true, // haptic feedback
          tabBorderRadius: 10, // tab button border

          // curve: Curves.easeOutExpo, // tab animation curves
          duration: const Duration(milliseconds: 900), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.grey[800], // unselected icon color
          activeColor: Colors.blue, // selected icon and text color
          iconSize: 24, // tab button icon size
          tabBackgroundColor: Colors.blue.withOpacity(0.1), // selected tab background color
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // navigation bar padding
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
              icon: LineIcons.user,
              text: 'Profile',
            )
          ],
           selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },),
   
     );
 
  }
}