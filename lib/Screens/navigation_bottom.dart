import 'package:arefapp/Screens/account_screen.dart';
import 'package:arefapp/Screens/course_list_screen.dart';
import 'package:arefapp/Screens/home_screen.dart';
import 'package:arefapp/Screens/ranking.dart';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavigationBottom extends StatefulWidget {
  const NavigationBottom({Key? key}) : super(key: key);

  @override
  _NavigationBottomState createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom>
    with WidgetsBindingObserver {
  int _selectedIndex = 2;
  bool _isKeyboardVisible = false;

  final List<Widget> _screens = [
    AccountScreen(),
    SearchScreen(),
    HomeScreen(),
    //ChallangeObtions(),
    LeaderboardScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final isKeyboardVisible =
        WidgetsBinding.instance.window.viewInsets.bottom > 0.0;
    if (isKeyboardVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isKeyboardVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[50],
        body: _screens[_selectedIndex], // Use the selected index here
        bottomNavigationBar:
            _isKeyboardVisible ? SizedBox.shrink() : buildBottomNavigationBar(),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return Container(
      color: Color.fromRGBO(255, 255, 255, 1),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: GNav(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          color: Colors.grey[500],
          activeColor: Colors.purple[500],
          tabBackgroundColor: Color.fromRGBO(255, 255, 255, 1),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          gap: 7,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          tabs: [
            GButton(
              onPressed: () {
                _onItemTapped(0);
              },
              icon: Icons.person,
              text: 'حسابي',
              textStyle: TextStyle(
                fontFamily: "mid",
                color: const Color.fromARGB(255, 176, 39, 158),
              ),
            ),
            GButton(
              onPressed: () {
                _onItemTapped(1);
              },
              icon: Icons.book,
              text: 'المواد',
              textStyle: TextStyle(
                fontFamily: "mid",
                color: Colors.purple,
              ),
            ),
            GButton(
              onPressed: () {
                _onItemTapped(2);
              },
              icon: Icons.home,
              text: 'الرئيسية',
              textStyle: TextStyle(
                fontFamily: "mid",
                color: Colors.purple,
              ),
            ),
            // GButton(
            //   onPressed: () {
            //     _onItemTapped(3);
            //   },
            //   icon: Icons.trending_up_outlined,
            //   text: ' التحديات',
            //   textStyle: TextStyle(
            //     fontFamily: "mid",
            //     color: Colors.purple,
            //   ),
            // ),
            GButton(
              icon: Icons.bolt_outlined,
              onPressed: () {
                _onItemTapped(3);
              },
              text: 'الترتيب ',
              textStyle: TextStyle(
                fontFamily: "mid",
                color: Colors.purple,
              ),
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            _onItemTapped(index);
          },
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
