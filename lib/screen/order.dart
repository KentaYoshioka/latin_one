import 'package:flutter/material.dart';
import 'package:latin_one/screen/order_shops.dart';
import 'package:latin_one/screen/product.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String shops = '';
  List<Map<String, dynamic>> products = [];

  @override
  Widget build(BuildContext context) {
    double totalAmount = products.fold(0, (sum, product) {
      double price = (product['totalPrice'] is String)
          ? double.parse(product['totalPrice'])
          : product['totalPrice'] as double;
      return sum + price;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.brown[700],
        elevation: 0,
      ),
      body: Container(
        color: Colors.brown[50], // 背景を柔らかい色に変更
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // ショップ選択
            GestureDetector(
              onTap: () async {
                final shopinfo = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return OrderShopsPage();
                  }),
                );
                if (shopinfo != null) {
                  setState(() {
                    shops = shopinfo;
                  });
                  final product = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ProductPage(isFromHomePage: false);
                    }),
                  );
                  if (product != null) {
                    setState(() {
                      products = product;
                    });
                  }
                }
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store, size: 40, color: Colors.green[600]),
                      SizedBox(width: 10),
                      Text(
                        'Select Shops',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // プロダクト選択
            GestureDetector(
              onTap: shops.isNotEmpty
                  ? () async {
                final product = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ProductPage(isFromHomePage: false);
                  }),
                );
                if (product != null) {
                  setState(() {
                    products = product;
                  });
                }
              }
                  : null,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: shops.isNotEmpty ? Colors.white : Colors.grey[300],
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: shops.isNotEmpty
                              ? Colors.brown[700]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 選択されたショップの表示
            shops.isNotEmpty ? Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  shops,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
                : SizedBox.shrink(),

            // 選択された商品のリスト
            products.isNotEmpty ? Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // 各商品のtitleとtotalPriceを表示
                    ...products.map((product) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product['title'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.brown[700],
                              ),
                            ),
                            Text(
                              '${product['quantity']}g',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.brown[700],
                              ),
                            ),
                            Text(
                              '¥${product['totalPrice']}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    Divider(),

                    // totalPriceの合計を表示
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700],
                          ),
                        ),
                        Text(
                          '¥$totalAmount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
