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
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  var mainPageState = context.findAncestorStateOfType<Pages>();
                  mainPageState?.onItemTapped(2);
                },
                child: Container(
                    margin: EdgeInsets.all(10), width: 350, height:200 ,
                    decoration: background_image('assets/images/coffee.jpg'),
                    child: Text(
                        'order',
                        style: Default_title_Style
                    ),
                    alignment: Alignment.center
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ProductPage(isFromHomePage: true)));
                },
                child: Container(
                    margin: EdgeInsets.all(10), width: 350, height:200 ,
                    decoration: background_image('assets/images/IMG_8836.jpg'),
                    child: Text(
                        'menu',
                        style: Default_title_Style
                    ),
                    alignment: Alignment.center
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Topic2Page()));
                },
                child: Container(
                    margin: EdgeInsets.all(10), width: 350, height:200 ,
                    decoration: background_image('assets/images/IMG_8837.jpg'),
                    child: Text(
                        'Topic2',
                        style: Default_title_Style
                    ),
                    alignment: Alignment.center
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}