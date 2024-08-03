import 'package:flutter/material.dart';

import './screen/home.dart';
import './screen/order.dart';
import './screen/shops.dart';
import './screen/inbox.dart';


class Page extends StatefulWidget {
  const Page({super.key, required this.title});
  final String title;
  @override
  Pages createState() => Pages();
}


class Pages extends State<Page> {
  int _selectedIndex = 0;
  final _pageWidgets = [
    HomePage(),
    ShopsPage(),
    OrderPage(),
  ];
  void onItemTapped(int index) => setState(() => _selectedIndex = index );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Standard AppBar',
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'LatinOne',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.brown,
            leading: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => InboxPage())
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/inbox_icon.png',
                    fit: BoxFit.contain,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
          body: _pageWidgets.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: onItemTapped,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem> [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'shops',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'order',
              ),
            ],
          ),
        )
    );
  }
}