import 'package:flutter/material.dart';
import './product.dart';
import './topic2.dart';
import '../page.dart';
import '../style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              // Order section
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 350 * (SizeConfig.screenWidthRatio ?? 1.0),
                    height: 200 * (SizeConfig.screenHeightRatio ?? 1.0),
                    decoration: background_image('assets/images/coffee.jpg'),
                    alignment: Alignment.center,
                      child: Text(
                          'MOBILE ORDER & PAY',
                          style: Default_title_Style(context)
                      )
                  ),
                  Positioned(
                    left: 20 * (SizeConfig.screenWidthRatio ?? 1.0),
                    bottom: 20 * (SizeConfig.screenHeightRatio ?? 1.0),
                    child: ElevatedButton(
                      onPressed: () {
                        var mainPageState = context.findAncestorStateOfType<Pages>();
                        mainPageState?.onItemTapped(2);
                      },
                      child: Text('Order をする',
                        style: TextStyle(
                          fontSize: 20 * (SizeConfig.screenHeightRatio ?? 1.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Menu section
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 350 * (SizeConfig.screenWidthRatio ?? 1.0),
                    height: 200 * (SizeConfig.screenHeightRatio ?? 1.0),
                    decoration: background_image('assets/images/IMG_8836.jpg'),
                    alignment: Alignment.center,
                      child: Text(
                          'COFFEE LIST',
                          style: Default_title_Style(context)
                      )
                  ),
                  Positioned(
                    left: 20 * (SizeConfig.screenWidthRatio ?? 1.0),
                    bottom: 20 * (SizeConfig.screenHeightRatio ?? 1.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductPage(isFromHomePage: true),
                          ),
                        );
                      },
                      child: Text('Menu を見る',
                        style: TextStyle(
                          fontSize: 20 * (SizeConfig.screenHeightRatio ?? 1.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Topic2 section
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 350 * (SizeConfig.screenWidthRatio ?? 1.0),
                    height: 200 * (SizeConfig.screenHeightRatio ?? 1.0),
                    decoration: background_image('assets/images/IMG_8837.jpg'),
                    alignment: Alignment.center,
                      child: Text(
                          'SHOP LIST',
                          style: Default_title_Style(context)
                      )
                  ),
                  Positioned(
                    left: 20 * (SizeConfig.screenWidthRatio ?? 1.0),
                    bottom: 20 * (SizeConfig.screenHeightRatio ?? 1.0),
                    child: ElevatedButton(
                      onPressed: () {
                        var mainPageState = context.findAncestorStateOfType<Pages>();
                        mainPageState?.onItemTapped(1);
                      },
                      child: Text('Shop を見る',
                        style: TextStyle(
                          fontSize: 20 * (SizeConfig.screenHeightRatio ?? 1.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
