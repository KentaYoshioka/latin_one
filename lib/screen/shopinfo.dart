import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../style.dart';


class ShopInfoPage extends StatefulWidget {
  @override
  State<ShopInfoPage> createState() => _ShopInfoPageState();
}

class _ShopInfoPageState extends State<ShopInfoPage> with TickerProviderStateMixin  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JAVANICAN latin coffee'),
      ),
      body: Container(
        // padding: EdgeInsets.all(32.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                  child: Text(
                      'JAVANICAN latin coffee',
                      style: Shopinfo_title
                  ),
                  alignment: Alignment.center
              ),
              Container(
                  child: Text(
                      '〒781-5101\n 高知県高知市布師田3061\n',
                      style: Shopinfo
                  ),
                  alignment: Alignment.center
              ),
              ElevatedButton(
                onPressed: () {
                  final phoneLauncher = PhoneLauncher();
                  phoneLauncher.makePhoneCall(dotenv.get('PHONE_NUMBER'));
                },
                child: Text('電話番号：${dotenv.get('PHONE_NUMBER')}'),
              ),
              ElevatedButton(
                onPressed: () {
                  final mapLauncher = MapLauncher();
                  mapLauncher.makeMap();
                },
                child: Text('Google Mapで開く'),
              ),
              Container(
                  margin: EdgeInsets.all(10), width: 350, height:200 ,
                  decoration: background_image('assets/images/IMG_8834.jpg'),
                  alignment: Alignment.center
              ),
              Container(
                  margin: EdgeInsets.all(10), width: 350, height:200 ,
                  decoration: background_image('assets/images/IMG_8835.jpg'),
                  alignment: Alignment.center
              ),
              Container(
                  margin: EdgeInsets.all(10), width: 350, height:200 ,
                  decoration: background_image('assets/images/IMG_8836.jpg'),
                  alignment: Alignment.center
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneLauncher {
  Future makePhoneCall(String phoneNumber) async {
    final Uri getPhoneNumber = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(getPhoneNumber);
  }
}

class MapLauncher {
  Future makeMap() async {
    final getMap = Uri.parse('https://maps.app.goo.gl/BqszzYwkEwk8UYrc8');
    await launchUrl(getMap);
  }
}