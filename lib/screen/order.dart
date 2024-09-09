import 'package:flutter/material.dart';
import 'package:latin_one/screen/order_shops.dart';
import 'package:latin_one/screen/product.dart';
import '../style.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String shops = '';
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
                  String shopinfo = await Navigator.push(
                      context, MaterialPageRoute(builder: (context){
                        return OrderShopsPage();
                        },
                  ));
                  if (shopinfo != null) {
                    await Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                          return ProductPage();
                          },
                    ));
                  }
                },
                child: Container(
                    margin: EdgeInsets.all(10), height:100 ,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                        'select shops',
                        style: Order_Style
                    ),
                    alignment: Alignment.center
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ProductPage()));
                },
                child: Container(
                    margin: EdgeInsets.all(10), height:100 ,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                        'select product',
                        style: Order_Style
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