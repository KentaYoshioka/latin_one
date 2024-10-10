import 'package:flutter/material.dart';
import 'package:latin_one/screen/order_shops.dart';
import 'package:latin_one/screen/product.dart';
import 'package:latin_one/screen/personal_info_form.dart';
import '../style.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

List<Map<String, dynamic>> products = [];

class _OrderPageState extends State<OrderPage> {
  String shops = '';


  @override
  Widget build(BuildContext context) {
    int totalAmount = products.fold(0, (sum, product) {
      int price = (product['totalPrice'] is String)
          ? int.parse(product['totalPrice'])
          : product['totalPrice'] as int;
      return sum + price;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
        color: Colors.brown[50],
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () async {
                final shopinfo = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const OrderShopsPage();
                  }),
                );
                if (shopinfo != null) {
                  setState(() {
                    shops = shopinfo;
                  });
                  final product = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const ProductPage(isFromHomePage: false);
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
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store, size: 40, color: Colors.green[600]),
                      const SizedBox(width: 10),
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

            GestureDetector(
              onTap: shops.isNotEmpty ? () async {
                final product = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const ProductPage(isFromHomePage: false);
                  }),
                );
                if (product != null) {
                  setState(() {
                    addOrUpdateProducts(products, product);
                  });
                }
              }
                  : null,
              child: Card(
                margin:  const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                      const SizedBox(width: 10),
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

            shops.isNotEmpty ? Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
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
                : const SizedBox.shrink(),

            products.isNotEmpty ? Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ...products.map((product) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.brown[700],
                                  ),
                                ),
                                Text(
                                  '${product['quantity']}g',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.brown[700],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '¥${product['totalPrice']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green[700],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: Colors.red[700]),
                                  onPressed: () {
                                    setState(() {
                                      products.remove(product);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    const Divider(),

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
                : const SizedBox.shrink(),

            shops.isNotEmpty && products.isNotEmpty ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonalInfoForm(
                          products: products,
                          totalAmount: totalAmount,
                        ),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.brown,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '個人情報入力フォームへ',
                    style: Order_Style,
                  ),
                ),
              ),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

void addOrUpdateProducts(List<Map<String, dynamic>> existingProducts, List<Map<String, dynamic>> newProducts) {
  for (var newProduct in newProducts) {
    var existingProduct = existingProducts.firstWhere(
          (existingProduct) => existingProduct['title'] == newProduct['title'],
      orElse: () => {},
    );

    if (existingProduct.isNotEmpty) {
      existingProduct['quantity'] += newProduct['quantity'];
      existingProduct['totalPrice'] += newProduct['totalPrice'];
    } else {
      existingProducts.add(newProduct);
    }
  }
}



