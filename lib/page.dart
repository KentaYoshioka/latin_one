import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screen/home.dart';
import './screen/order.dart';
import './screen/shops.dart';
import './screen/inbox.dart';
import './screen/product.dart';
import './style.dart';
import 'dart:convert';

class Page extends StatefulWidget {
  const Page({super.key, required this.title, required this.fcmToken,this.type});
  final String title;
  final String fcmToken;
  final String? type;

  @override
  Pages createState() => Pages();
}

class Pages extends State<Page> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _notifications = []; // 通知リスト
  final _pageWidgets = <Widget>[];
  late Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  String? _myToken;
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
    _loadNotifications();

    _pageWidgets.addAll([
      const HomePage(),
      const ShopsPage(),
      OrderPage(fcmToken: widget.fcmToken),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.type != null) {
        _navigateToInbox();
      }
    });
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotifications = prefs.getStringList('notifications') ?? [];
    debugPrint('Saved notifications in SharedPreferences: $savedNotifications'); // デバッグログ
    setState(() {
      try {
        _notifications.addAll(
          savedNotifications.map((e) {
            final decoded = json.decode(e);
            if (decoded is Map<String, dynamic>) {
              // すべての値を文字列に変換
              return decoded.map((key, value) => MapEntry(key, value.toString()));
            } else {
              throw FormatException('通知データが無効な形式です: $decoded');
            }
          }),
        );
      } catch (e) {
        debugPrint('通知データの読み込み中にエラーが発生: $e');
      }
    });
    debugPrint('Loaded notifications in _notifications: $_notifications'); // デバッグログ
  }

  Future<void> _navigateToInbox() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InboxPage(
          notifications: _notifications, // 保存された通知を渡す
          deviceToken: widget.fcmToken,
          initialTab: widget.type ?? '', // type を初期タブとして渡す
        ),
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
  }

  Future<void> _saveNotification(Map<String, String> notification) async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotifications = prefs.getStringList('notifications') ?? [];
    debugPrint('Before saving, existing notifications: $savedNotifications'); // デバッグログ
    savedNotifications.add(json.encode(notification));
    await prefs.setStringList('notifications', savedNotifications);

    // ローカルリストにも追加
    setState(() {
      _notifications.add(notification);
    });
    debugPrint('Notification saved: $notification'); // デバッグログ
  }

  void _initializeFirebaseMessaging() {
    _messageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (message.data['to'] == _myToken) {
          final notification = {
            'title': message.notification?.title ?? 'No Title',
            'body': message.notification?.body ?? 'No Body',
          };
          _saveNotification(notification); // 通知を保存
          debugPrint(
            "Notification Received for my token: ${message.notification!.title}, ${message.notification!.body}",
          ); // デバッグログ
        } else {
          debugPrint("Notification ignored: Not for my token"); // デバッグログ
        }
      }
    });
  }

  void _startConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _isConnected = results.any((result) => result != ConnectivityResult.none);
      });
      debugPrint('Connectivity status changed. Connected: $_isConnected'); // デバッグログ
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
      debugPrint('Periodic connectivity check. Connected: $_isConnected'); // デバッグログ
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
                    builder: (context) => InboxPage(
                      notifications: _notifications, // 保存された通知を渡す
                      deviceToken: widget.fcmToken,
                    ),
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


