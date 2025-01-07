import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../style.dart';
import '../network.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> with TickerProviderStateMixin {
  late final _animatedMapController = AnimatedMapController(vsync: this);
  List<Map<String, dynamic>> shopPlaces = [];
  final supabase = Supabase.instance.client;
  final NetworkHandler _networkHandler = NetworkHandler();

  Future<void> fetchShop() async {
    final response = await supabase
        .from('shops')
        .select('id, name, address, long, lat, phone');

    setState(() {
      shopPlaces = (response as List).cast<Map<String, dynamic>>();
    });
  }

  void _showAlert(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(shopPlaces[index]['name']), // 店舗名を表示
        content: Text(
          shopPlaces[index]['address'], // 住所を表示
          style: TextStyle(fontSize: 20.0 * (SizeConfig.screenHeightRatio ?? 1.0)),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('詳細'),
            onPressed: () async{
              if(await _networkHandler.checkConnectivity(context)) {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopInfoPage(shop: shopPlaces[index]),
                  ),
                );
              }
            },
          ),
          TextButton(
            child: const Text('閉じる'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchShop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "店舗情報",
            style: TextStyle(fontSize: 20.0 * (SizeConfig.screenWidthRatio ?? 1.0)),
        ),
      ),
      body: FlutterMap(
        mapController: _animatedMapController.mapController,
        options: const MapOptions(
          initialCenter: LatLng(33.57453, 133.57860),
          initialZoom: 5,
          maxZoom: 20,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
              TextSourceAttribution(
                'Google Map で開く',
                onTap: () => launchUrl(Uri.parse('https://maps.app.goo.gl/BqszzYwkEwk8UYrc8')),
              ),
            ],
          ),
          MarkerLayer(
            markers: shopPlaces.map((shop) {
              return Marker(
                width: 30.0 * (SizeConfig.screenHeightRatio ?? 1.0),
                height: 30.0 * (SizeConfig.screenWidthRatio ?? 1.0),
                point: LatLng(shop['lat'], shop['long']),
                child: GestureDetector(
                  onTapDown: (tapPosition) {
                    int index = shopPlaces.indexOf(shop);
                    _showAlert(index);
                  },
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30 * (SizeConfig.screenWidthRatio ?? 1.0),
                  ),
                ),
                rotate: true,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ShopInfoPage extends StatelessWidget {
  final Map<String, dynamic> shop;

  const ShopInfoPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            shop['name'],
            style: TextStyle(fontSize: 20.0 * (SizeConfig.screenWidthRatio ?? 1.0)),
        ), // 店舗名を表示
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                shop['name'], // 店舗名を表示
                style: Shopinfo_title(context),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                shop['address'], // 住所を表示
                style: Shopinfo(context),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final phoneLauncher = PhoneLauncher();
                phoneLauncher.makePhoneCall(shop['phone']); // 電話番号を使用
              },
              child: Text('電話番号：${shop['phone']}'), // 電話番号を表示
            ),
            ElevatedButton(
              onPressed: () {
                final mapLauncher = MapLauncher();
                mapLauncher.makeMap(); // マップを開く
              },
              child: const Text('Google Mapで開く'),
            ),
            // 画像などのコンテンツ
            Container(
              margin: const EdgeInsets.all(10),
              width: 350 * (SizeConfig.screenWidthRatio ?? 1.0),
              height: 200 * (SizeConfig.screenHeightRatio ?? 1.0),
              decoration: background_image('assets/images/IMG_8834.jpg'),
              alignment: Alignment.center,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: 350 * (SizeConfig.screenWidthRatio ?? 1.0),
              height: 200 * (SizeConfig.screenHeightRatio ?? 1.0),
              decoration: background_image('assets/images/IMG_8835.jpg'),
              alignment: Alignment.center,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: 350 * (SizeConfig.screenWidthRatio ?? 1.0),
              height: 200 * (SizeConfig.screenHeightRatio ?? 1.0),
              decoration: background_image('assets/images/IMG_8836.jpg'),
              alignment: Alignment.center,
            ),
          ],
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
