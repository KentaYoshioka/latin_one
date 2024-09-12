import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screen/home.dart';
import './screen/order.dart';
import './screen/shops.dart';
import './screen/inbox.dart';
import './style.dart';

class Page extends StatefulWidget {
  const Page({super.key, required this.title});
  final String title;
  @override
  Pages createState() => Pages();
}


class Pages extends State<Page> {
  int _selectedIndex = 0;
  final _pageWidgets = [
    const HomePage(),
    const ShopsPage(),
    const OrderPage(),
  ];
  void onItemTapped(int index) => setState(() => _selectedIndex = index );

  void _handlePopInvoked() {
    if (_selectedIndex == 0) {
      SystemNavigator.pop();
    }
    else {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Standard AppBar',
        home: PopScope(
          canPop: false,
          onPopInvoked: (popDisposition) {
            _handlePopInvoked();
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('LatinOne', style: Default_title_Style),
              backgroundColor: Colors.brown,
              leading: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const InboxPage()));
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
              items: const <BottomNavigationBarItem>[
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
          ),
        ));
  }
}