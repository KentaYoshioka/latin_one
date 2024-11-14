import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './screen/home.dart';
import './screen/order.dart';
import './screen/shops.dart';
import './screen/inbox.dart';
import './screen/product.dart';
import './style.dart';

class Page extends StatefulWidget {
  const Page({super.key, required this.title});
  final String title;

  @override
  Pages createState() => Pages();
}

class Pages extends State<Page> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _notifications = [];
  final _pageWidgets = <Widget>[];

  late Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  Timer? _timer;
  bool _isConnected = true;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _startConnectivityMonitoring();
    _startPeriodicCheck();

    _initializeFirebaseMessaging();

    _pageWidgets.addAll([
      const HomePage(),
      const ShopsPage(),
      const OrderPage(),
    ]);
  }

  void _initializeFirebaseMessaging() {
    // FirebaseMessagingリスナーの登録
    _messageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          _notifications.add({
            'title': message.notification!.title ?? 'No Title',
            'body': message.notification!.body ?? 'No Body',
          });
        });
      }
    });
  }

  void _startConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _isConnected = results.any((result) => result != ConnectivityResult.none);
      });

      if (!_isConnected && !_isDialogShowing) {
        _showNoConnectionDialog();
      }
    });
  }

  void _startPeriodicCheck() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      var result = await _connectivity.checkConnectivity();
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });

      if (!_isConnected && !_isDialogShowing) {
        _showNoConnectionDialog();
      }
    });
  }

  void _showNoConnectionDialog() {
    _isDialogShowing = true;
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
                _isDialogShowing = false;
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
    _connectivitySubscription?.cancel();
    _messageSubscription?.cancel(); // FirebaseMessagingリスナーの解除
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
      home: WillPopScope(
        onWillPop: () async {
          _handlePopInvoked();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('LatinOne', style: Default_title_Style),
            backgroundColor: Colors.brown,
            leading: IconButton(
          icon: const Icon(Icons.inbox),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InboxPage(notifications: _notifications),
              ),
            );

            if (result == 'shops') {
              setState(() {
                _selectedIndex = 1;
              });
            } else if (result == 'products') {
              Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductPage(isFromHomePage: true),
                          ),
                        );
            }
          },
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