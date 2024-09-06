import 'package:flutter/material.dart';
import 'package:latin_one/screen/order_shops.dart';
import 'package:latin_one/screen/product.dart';
import '../style.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                      context, MaterialPageRoute(builder: (context){
                        return OrderShopsPage();
                        },
                  ),
                  );
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ProductPage()));
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
            ],
          ),
        ),
      ),
    );
  }
}