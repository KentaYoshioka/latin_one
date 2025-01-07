import 'package:flutter/material.dart';
import '../style.dart';
import '../network.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductPage extends StatefulWidget {
  final bool isFromHomePage;
  const ProductPage({super.key, required this.isFromHomePage});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> menuItems = [];
  final supabase = Supabase.instance.client;
  final NetworkHandler _networkHandler = NetworkHandler();

  Future<void> fetchMenu() async {
    final response = await supabase
        .from('products')
        .select();

    setState(() {
      menuItems = response as List<dynamic>;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  final List<Map<String, dynamic>> _purchasedItems = [];

  double _calculateItemTotalPrice(Map<String, dynamic> item) {
    double pricePer100g = double.parse(item['price']);
    return item['quantity'] / 100 * pricePer100g;
  }

  double _calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in _purchasedItems) {
      totalPrice += _calculateItemTotalPrice(item);
    }
    return totalPrice;
  }

  void _showOrderDetails(String title, int quantity, String price) {
    int index = _purchasedItems.indexWhere((item) => item['title'] == title);
    if (index >= 0) {
      setState(() {
        _purchasedItems[index]['quantity'] += quantity;
      });
    } else {
      setState(() {
        _purchasedItems.add(
            {'title': title, 'quantity': quantity, 'price': price});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> attributeGroupedItems = {};
    for (var item in menuItems) {
      String attribute = item['attribute']; // 属性に基づく
      if (!attributeGroupedItems.containsKey(attribute)) {
        attributeGroupedItems[attribute] = [];
      }
      attributeGroupedItems[attribute]!.add(item);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'メニュー',
          style: TextStyle(fontSize: 24 * (SizeConfig.screenWidthRatio ?? 1.0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: Text(
                    '100gあたりの価格です',
                    style: TextStyle(
                        fontSize: 16 * (SizeConfig.screenWidthRatio ?? 1.0),
                        color: Colors.grey[700]),
                  ),
                )
            ),
            ...attributeGroupedItems.entries.map((entry) {
              String attribute = entry.key;
              List<dynamic> items = entry.value;

              return ExpansionTile(
                title: Text(
                  attribute,
                  style: TextStyle(
                    fontSize: 18 * (SizeConfig.screenHeightRatio ?? 1.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductScreen(
                                      title: items[index]['title']!,
                                      description: items[index]['description']!,
                                      price: items[index]['price']!.toString(),
                                      imagePath: items[index]['image']!,
                                      onOrderConfirmed: (quantity) {
                                        _showOrderDetails(
                                            items[index]['title']!, quantity,
                                            items[index]['price'].toString());
                                      },
                                      isFromHomePage: widget.isFromHomePage,
                                    ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                items[index]['image'],
                                width: 100 *
                                    (SizeConfig.screenWidthRatio ?? 1.0),
                                height: 50 *
                                    (SizeConfig.screenHeightRatio ?? 1.0),
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  items[index]['title']!,
                                  style: product_title(context),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  '価格: ¥${items[index]['price']}',
                                  style: normal(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: _purchasedItems.isNotEmpty
          ? FloatingActionButton(
        onPressed: () async {
          final result = await _showPurchasedItems();
          if (result != null) {
            Navigator.pop(context, result);
          }
        },
        child: Text('${_purchasedItems.length}件'),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Map<String, dynamic>>?> _showPurchasedItems() async {
    return await showModalBottomSheet<List<Map<String, dynamic>>>(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _purchasedItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_purchasedItems[index]['title']),
                        subtitle: Text(
                            '数量: ${_purchasedItems[index]['quantity']}g'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '¥${_calculateItemTotalPrice(
                                  _purchasedItems[index]).toInt()}',
                              style: TextStyle(
                                fontSize: 18 *
                                    (SizeConfig.screenWidthRatio ?? 1.0),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _purchasedItems.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '合計金額: ¥${_calculateTotalPrice().toInt()}',
                        style: TextStyle(fontSize: 18 *
                            (SizeConfig.screenWidthRatio ?? 1.0),
                            fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (await _networkHandler.checkConnectivity(
                              context)) {
                            final orderDetails = _purchasedItems.map((item) {
                              return {
                                'title': item['title'],
                                'quantity': item['quantity'],
                                'totalPrice': (item['quantity'] / 100 *
                                    double.parse(item['price'])).toInt(),
                              };
                            }).toList();
                            Navigator.pop(context, orderDetails);
                          }
                        },
                        child: const Text('購入'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ProductScreen extends StatefulWidget {
  final bool isFromHomePage;
  final String title;
  final String description;
  final String price;
  final String imagePath;
  final void Function(int quantity) onOrderConfirmed;

  const ProductScreen({super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.onOrderConfirmed,
    required this.isFromHomePage,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    height: 150 * (SizeConfig.screenHeightRatio ?? 1.0),
                  ),
                ),
                SizedBox(width: 16 * (SizeConfig.screenWidthRatio ?? 1.0)),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(fontSize: 24 * (SizeConfig.screenHeightRatio ?? 1.0), fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8 * (SizeConfig.screenHeightRatio ?? 1.0)),
                      Text(
                        '価格: ¥${widget.price}',
                        style: TextStyle(fontSize: 20 * (SizeConfig.screenHeightRatio ?? 1.0), fontWeight: FontWeight.bold, color: Colors.green[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * (SizeConfig.screenHeightRatio ?? 1.0)),
            Text(
              '商品説明',
              style: TextStyle(fontSize: 18 * (SizeConfig.screenHeightRatio ?? 1.0), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8 * (SizeConfig.screenHeightRatio ?? 1.0)),
            Text(
              widget.description,
              style: TextStyle(fontSize: 16 * (SizeConfig.screenHeightRatio ?? 1.0)),
            ),
            SizedBox(height: 24 * (SizeConfig.screenHeightRatio ?? 1.0)),
            if (!widget.isFromHomePage)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '数量を選択（100g単位）',
                    style: TextStyle(fontSize: 16 * (SizeConfig.screenHeightRatio ?? 1.0)),
                  ),
                  QuantitySelector(
                    initialQuantity: quantity,
                    onQuantityChanged: (newQuantity) {
                      setState(() {
                        quantity = newQuantity;
                      });
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: !widget.isFromHomePage
          ? SizedBox(
        width: 150 * (SizeConfig.screenWidthRatio ?? 1.0),
        height: 50 * (SizeConfig.screenHeightRatio ?? 1.0),
        child: ElevatedButton(
          onPressed: () {
            widget.onOrderConfirmed(quantity);
            Navigator.pop(context);
          },
          child: Text(
            '決定する',
            style: TextStyle(fontSize: 16 * (SizeConfig.screenHeightRatio ?? 1.0)),
          ),
        ),
      )
          : null,
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelector({super.key,
    required this.initialQuantity,
    required this.onQuantityChanged,
  });

  @override
  _QuantitySelectorState createState() {
    return _QuantitySelectorState();
  }
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (quantity > 100) quantity -= 100;
              widget.onQuantityChanged(quantity);
            });
          },
        ),
        Text('$quantity g'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              quantity += 100;
              widget.onQuantityChanged(quantity);
            });
          },
        ),
      ],
    );
  }
}
