import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './page.dart' as page;
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_KEY'),
  );
  await Firebase.initializeApp();
  final String? fcmToken = await FirebaseMessaging.instance.getToken();

  _initNotification(fcmToken);
  final message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    _handleInitialMessage(message, fcmToken);
  }

  runApp(MaterialApp(
    title: 'LatinOne',
    navigatorKey: navigatorKey,
    home: page.Page(title: 'LatinOne', fcmToken: fcmToken ?? ''),
  ));
}

void _handleInitialMessage(RemoteMessage message, String? fcmToken) {
  final data = message.data;
  if (data['type'] == 'news') {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => page.Page(title: 'News Page', fcmToken: fcmToken ?? ''),
      ),
    );
  } else {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => page.Page(title: 'Message Page', fcmToken: fcmToken ?? ''),
      ),
    );
  }
}

Future<void> _initNotification(String? fcmToken) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleInitialMessage(message, fcmToken);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (Platform.isAndroid && notification != null) {
      await flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_notification_channel',
            'プッシュ通知のチャンネル名',
            importance: Importance.max,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: json.encode(message.data),
      );

        await _saveNotificationLocally({
          'title': notification.title,
          'body': notification.body,
          'data': data,
        });
    }
  });

  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (details) {
      if (details.payload != null) {
        final payloadMap =
        json.decode(details.payload!) as Map<String, dynamic>;
        if (payloadMap['type'] == 'news') {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) =>
                  page.Page(title: 'News Page', fcmToken: fcmToken ?? ''),
            ),
          );
        } else {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) =>
                  page.Page(title: 'Message Page', fcmToken: fcmToken ?? ''),
            ),
          );
        }
      }
    },
  );
}

Future<void> _saveNotificationLocally(Map<String, dynamic> notification) async {
  if (!notification['title'].contains('情報')) {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('notifications') ?? [];
    notifications.add(json.encode(notification));
    await prefs.setStringList('notifications', notifications);
    debugPrint('通知を保存しました（情報を含む）');
  } else {
    debugPrint('通知を保存しませんでした（情報を含まない）');
  }
}
