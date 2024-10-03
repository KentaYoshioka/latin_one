import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderShopsPage extends StatefulWidget {
  const OrderShopsPage({super.key});

  @override
  State<OrderShopsPage> createState() => _OrderShopsPageState();
}

class _OrderShopsPageState extends State<OrderShopsPage> with TickerProviderStateMixin {
  String shops = "";
  late final _animatedMapController = AnimatedMapController(vsync: this);

  List<dynamic> shopPlaces = [];
  final supabase = Supabase.instance.client;

  Future<void> fetchShop() async {
    final response = await supabase
        .from('shops')
        .select('id, name, address, long, lat, phone');

    setState(() {
      shopPlaces = response as List<dynamic>;
    });
  }
  Future<String?> _showAlert(int index) async {
  return await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(shopPlaces[index]['name']),
      content: Text(
        shopPlaces[index]['address'], // 住所を表示
        style: const TextStyle(fontSize: 20.0),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('選択'),
          onPressed: () {
            shops = '${shopPlaces[index]['name']}\n ${shopPlaces[index]['address']}';
            Navigator.of(context).pop(shops); // ダイアログを閉じるとともにshopsを返す
          },
        ),
        TextButton(
          child: const Text('閉じる'),
          onPressed: () => Navigator.of(context).pop(), // ダイアログを閉じる
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('店舗情報',
          style: TextStyle(fontSize: 16.0),),
      ),
      body: FlutterMap(
        // mapControllerをFlutterMapに指定
        mapController: _animatedMapController.mapController,
        options: const MapOptions(
          // Latin coffeeの緯度経度です。
          initialCenter: LatLng(33.57453, 133.57860),
          initialZoom: 15,
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
              ]),
          MarkerLayer(
            markers: shopPlaces.asMap().entries.map((entry) {
              int index = entry.key;
              var shop = entry.value;
              return Marker(
                width: 30.0,
                height: 30.0,
                point: LatLng(shop['lat'], shop['long']), // 緯度経度を使用してマーカーを配置
                child: GestureDetector(
                  onTapDown: (tapPosition) async {
                    String? shopsAlert = await _showAlert(index);
                    if (shopsAlert != null && shopsAlert.isNotEmpty) {
                      Navigator.of(context).pop(shopsAlert);
                    }
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30,
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
