import 'package:flutter/material.dart';
import '../style.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<Map<String, String>> menuItems = [
    {'title': 'メニュー1', 'description': 'これはメニュー1の画面です', 'price': '500', 'photo': 'assets/images/coffee.jpg' },
    {'title': 'メニュー2', 'description': 'これはメニュー2の画面です', 'price': '500', 'photo': 'assets/images/coffee.jpg'},
    {'title': 'メニュー3', 'description': 'これはメニュー3の画面です', 'price': '500', 'photo': 'assets/images/coffee.jpg'},
    {'title': 'メニュー4', 'description': 'これはメニュー4の画面です', 'price': '500', 'photo': 'assets/images/coffee.jpg' },
    {'title': 'メニュー5', 'description': 'これはメニュー5の画面です', 'price': '500', 'photo': 'assets/images/coffee.jpg'},
    {'title': 'メニュー6', 'description': 'これはメニュー6の画面です', 'price': '500', 'photo': 'assets/images/coffee.jpg'},
  ];

  List<Map<String, dynamic>> _purchasedItems = [];

  double _calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in _purchasedItems) {
      double pricePer100g = double.parse(item['price']);
      totalPrice += item['quantity'] / 100 * pricePer100g;
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
        _purchasedItems.add({'title': title, 'quantity': quantity, 'price': price});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '100gあたりの価格です．',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.95,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            title: menuItems[index]['title']!,
                            description: menuItems[index]['description']!,
                            price: menuItems[index]['price']!,
                            imagePath: menuItems[index]['photo']!,
                            onOrderConfirmed: (quantity) {
                              _showOrderDetails(menuItems[index]['title']!, quantity, menuItems[index]['price']!);
                            },
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          menuItems[index]['photo']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            menuItems[index]['title']!,
                            style: product_title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '価格: ¥${menuItems[index]['price']}',
                            style: normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _purchasedItems.isNotEmpty
          ? FloatingActionButton(
        onPressed: () async {
          // _showPurchasedItems から戻ってきたデータを受け取る
          final result = await _showPurchasedItems();

          // 戻ってきたデータを使って処理を行う
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
                        subtitle: Text('数量: ${_purchasedItems[index]['quantity']}g'),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _purchasedItems.removeAt(index);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '合計金額: ¥${_calculateTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // 2. JSON形式のデータを Navigator.pop で返す
                        final orderDetails = _purchasedItems.map((item) {
                          return {
                            'title': item['title'],
                            'quantity': item['quantity'],
                            'totalPrice': (item['quantity'] / 100 * double.parse(item['price'])).toStringAsFixed(2),
                          };
                        }).toList();
                        Navigator.pop(context, orderDetails); // データを返す
                      },
                      child: Text('購入'),
                    ),
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
  final String title;
  final String description;
  final String price;
  final String imagePath;
  final void Function(int quantity) onOrderConfirmed;

  ProductScreen({
    required this.title,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.onOrderConfirmed,
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
                    height: 150,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '価格: ¥${widget.price}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              '商品説明',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '数量を選択（100g単位）',
                  style: TextStyle(fontSize: 16),
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
      floatingActionButton: Container(
        width: 150,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            widget.onOrderConfirmed(quantity);
            Navigator.pop(context);
          },
          child: Text(
            '決定する',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;

  QuantitySelector({
    required this.initialQuantity,
    required this.onQuantityChanged,
  });

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
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
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (quantity > 100) quantity -= 100;
              widget.onQuantityChanged(quantity);
            });
          },
        ),
        Text('$quantity g'),
        IconButton(
          icon: Icon(Icons.add),
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
