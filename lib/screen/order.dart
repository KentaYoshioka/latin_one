import 'package:flutter/material.dart';
import 'package:latin_one/screen/order_shops.dart';
import 'package:latin_one/screen/product.dart';
import '../style.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}
class _OrderPageState extends State<OrderPage> {
  String shops = '';  // 文字列用の変数
  List<Map<String, dynamic>> products = [];
  
  @override
  Widget build(BuildContext context) {
    // double totalAmount = products.fold(0, (sum, product) {
    //   return sum + (product['totalPrice'] as double);
    // });
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
                  final shopinfo = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return OrderShopsPage();
                    }),
                  );
                  print(shopinfo);
                  if (shopinfo != null) {
                    setState(() {
                      shops = shopinfo;
                    });
                    final product = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ProductPage();
                      }),
                    );
                    print(product);
                    if (product != null) {
                      setState(() {
                        products = product;
                      });
                      print(products);
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store, size: 40, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text(
                        'Select Shops',
                        style: Order_Style,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                ),
              ),
              GestureDetector(
                onTap: shops.isNotEmpty ? () async {
                  final product = await Navigator.push(
                    context, MaterialPageRoute(builder: (context) {
                      return ProductPage();
                    }),
                  );
                  print(product);
                  if (product != null) {
                    setState(() {
                      products = product;
                    });
                    print(products);
                  }
                }
                : null,
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                    color: shops.isNotEmpty ? Colors.white : Colors.grey[300],
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: 40,
                        color: shops.isNotEmpty ? Colors.green : Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Select Product',
                        style: Order_Style.copyWith(
                          color: shops.isNotEmpty ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                ),
              ),
              shops.isNotEmpty
                  ? Container(
                      // margin: EdgeInsets.all(10),
                      height: 100,
                      // alignment: Alignment.center,
                      child: Text(
                        '$shops',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : SizedBox.shrink(),
              products.isNotEmpty ? Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Column(
                  children: products.map((product) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // タイトルと価格を左右に分けて表示
                      children: [
                        Text(
                          product['title'],  // 各productのtitleを表示
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${product['quantity']}g',  // 各productのtotalPriceを表示
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '¥${product['totalPrice']}',  // 各productのtotalPriceを表示
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
