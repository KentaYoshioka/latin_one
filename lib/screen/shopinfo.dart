import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ShopInfoPage extends StatefulWidget {
  @override
  State<ShopInfoPage> createState() => _ShopInfoPageState();
}

class _ShopInfoPageState extends State<ShopInfoPage> with TickerProviderStateMixin  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JAVANICA latin coffee'),
      ),
      body: Container(
        // padding: EdgeInsets.all(32.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                  child: Text(
                      'JAVANICA latin coffee',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black
                      )
                  ),
                  alignment: Alignment.center
              ),
              Container(
                  child: Text(
                      '〒781-5101\n 高知県高知市布師田3061\n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black
                      )
                  ),
                  alignment: Alignment.center
              ),
              ElevatedButton(
                onPressed: () {
                  final urlLauncher = UrlLauncher();
                  urlLauncher.makePhoneCall(dotenv.get('PHONE_NUMBER'));
                },
                child: Text('電話番号：${dotenv.get('PHONE_NUMBER')}'),
              ),
              Container(
                  margin: EdgeInsets.all(10), width: 350, height:200 ,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/IMG_8834.jpg'),
                        fit: BoxFit.cover,
                      )
                  ),
                  alignment: Alignment.center
              ),
              Container(
                  margin: EdgeInsets.all(10), width: 350, height:200 ,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/IMG_8835.jpg'),
                        fit: BoxFit.cover,
                      )
                  ),
                  alignment: Alignment.center
              ),
              Container(
                  margin: EdgeInsets.all(10), width: 350, height:200 ,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/IMG_8836.jpg'),
                        fit: BoxFit.cover,
                      )
                  ),
                  alignment: Alignment.center
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UrlLauncher {
  Future makePhoneCall(String phoneNumber) async {
    final Uri getPhoneNumber = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(getPhoneNumber);
  }
}