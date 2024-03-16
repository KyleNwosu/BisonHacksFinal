import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

import '../services/auth_service.dart';
import 'chatbot.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    ChatBotPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthService().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ExpandablePageView(
          children: _pages,
          controller: _pageController,
          onPageChanged: (value) => setState(() {
            _pageIndex = value;
          }),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        unselectedFontSize: 12,
        selectedFontSize: 13,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) async {
          setState(() {
            _pageIndex = value;
            _pageController.animateToPage(_pageIndex,
                duration: Durations.medium2, curve: Curves.easeIn);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.android,
              // color: Colors.black,
              size: 20,
            ),
            label: 'ChatBot',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              // color: Colors.white,
              size: 20,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
