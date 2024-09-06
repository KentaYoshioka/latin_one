import 'dart:ffi';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter/material.dart';


class Dialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('JAVANICA latin coffee'),
      content: Text(
        '〒781-5101\n 高知県高知市布師田3061\n',
        style: TextStyle(fontSize: 20.0),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('選択'),
          onPressed: () {
            Navigator.of(context).pop('JAVANICA latin coffee'); // ダイアログを閉じる
          },
        ),
        TextButton(
          child: const Text('閉じる'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class OrderShopsPage extends StatefulWidget {
  @override
  State<OrderShopsPage> createState() => _OrderShopsPageState();
}

class _OrderShopsPageState extends State<OrderShopsPage> with TickerProviderStateMixin {
  late final _animatedMapController = AnimatedMapController(vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('〒781-5101 高知県高知市布師田3061',
          style: TextStyle(fontSize: 16.0),),
      ),
      body: FlutterMap(
        // mapControllerをFlutterMapに指定
        mapController: _animatedMapController.mapController,
        options: MapOptions(
          // Latin coffeeの緯度経度です。
          initialCenter: LatLng(33.57453, 133.57860),
          initialZoom: 15,
          minZoom: 10,
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
            markers: [
              Marker(
                width: 30.0,
                height: 30.0,
                // ピンの位置を設定
                point: LatLng(33.57453, 133.57860),
                child: GestureDetector(
                  onTapDown: (tapPosition) async {
                    await showDialog<void>(
                        context: context,
                        builder: (_) {
                          return Dialog();
                        });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
                // マップを回転させた時にピンも回転するのが rotate: false,
                // マップを回転させた時にピンは常に同じ向きなのが rotate: true,
                rotate: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
