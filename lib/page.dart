import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Timer? _timer;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _startConnectivityMonitoring();
    _startPeriodicCheck();
  }

  void _startConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });

      if (!_isConnected) {
        _showNoConnectionDialog();
      }
    });
  }

  void _startPeriodicCheck() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
      var result = await _connectivity.checkConnectivity();
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });

      if (!_isConnected) {
        _showNoConnectionDialog();
      }
    });
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ネットワーク接続なし'),
          content: const Text('インターネットに接続されていません。接続を確認してください。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handlePopInvoked() {
    if (_selectedIndex == 0) {
      SystemNavigator.pop();
    } else {
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
          body: IndexedStack(
            index: _selectedIndex,
            children: _pageWidgets,
          ),
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
      ),
    );
  }
}
