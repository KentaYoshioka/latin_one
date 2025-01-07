import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:email_validator/email_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './order.dart';
import '../network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoForm extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final int totalAmount;
  final Map<String, dynamic> shops;
  final String fcmToken;

  const PersonalInfoForm({super.key, required this.products, required this.shops, required this.totalAmount, required this.fcmToken});

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final NetworkHandler _networkHandler = NetworkHandler();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadPreviousInfo() async {
    final previousInfo = await loadPersonalInfo();
    setState(() {
      _nameController.text = previousInfo['name']!;
      _postalCodeController.text = previousInfo['postalCode']!;
      _addressController.text = previousInfo['address']!;
      _emailController.text = previousInfo['email']!;
    });
  }

  Future<void> _savePersonalInfo() async {
    await savePersonalInfo(
      _nameController.text,
      _postalCodeController.text,
      _addressController.text,
      _emailController.text,
    );
  }

  Future<String?> zipCodeToAddress(String zipCode) async {
    if(zipCode == '700-8530' || zipCode == '7008530'){
      return '岡山県岡山市北区津島中１丁目１−１';
    }
    final response = await get(
      Uri.parse(
        'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipCode',
      ),
    );
    if (response.statusCode != 200) {
      return null;
    }
    final result = jsonDecode(response.body);
    if (result['results'] == null) {
      return null;
    }
    final addressMap = (result['results'] as List).first;
    final address = '${addressMap['address1']} ${addressMap['address2']} ${addressMap['address3']}';
    return address;
  }

  String? _errorMessage;

  Future<void> _searchAddress() async {
    String? address = await zipCodeToAddress(_postalCodeController.text);
    setState(() {
      if (address != null) {
        _addressController.text = address;
        _errorMessage = null;
      } else {
        _addressController.text = '';
        _errorMessage = '郵便番号が正しくありません';
      }
    });
  }

final supabase = Supabase.instance.client;
Future<void> _submitPurchase() async {
  String pur_order = '';
  for (var product in widget.products) {
    pur_order +=
        '${product['title']} - ${product['quantity']}g - ¥${product['totalPrice']}\n';
  }

  final response = await supabase
      .from('order')
      .insert({'name': '${_nameController.text}', 'postalcode': '${_postalCodeController.text}', 'address': '${_addressController.text}', 'email': '${_emailController.text}', 'order': '${pur_order}', 'sum': '${widget.totalAmount}', 'shop': '${widget.shops}', 'fcmtoken': '${widget.fcmToken}'});
      }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('個人情報入力'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '名前'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '名前を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _postalCodeController,
                decoration: InputDecoration(
                  labelText: '郵便番号',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchAddress,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '郵便番号を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: '住所'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '住所を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレスを入力してください';
                  }
                  if (!EmailValidator.validate(value)) {
                    return '有効なメールアドレスを入力してください';
                  }
                  return null;
                },
              ),
              if (_errorMessage != null) // エラーメッセージを表示する条件
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _loadPreviousInfo();
                },
                child: const Text('前回の内容を入力'),
              ),
              const SizedBox(height: 20),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...widget.products.map((product) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(product['title']),
                              Text('${product['quantity']}g'),
                              Text('¥${product['totalPrice']}'),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total'),
                          Text('¥${widget.totalAmount}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if(await _networkHandler.checkConnectivity(context)){
                    if (_formKey.currentState!.validate()) {
                      await _savePersonalInfo(); // 購入時に個人情報を保存
                      await _submitPurchase(); // HTTP POST を実行
                      products = [];
                      shops = {};
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PurchaseCompletePage()),
                      );
                    }
                  }
                },
                child: const Text('購入'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PurchaseCompletePage extends StatelessWidget {
  const PurchaseCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('購入完了'),
      ),
      body: const Center(
        child: Text(
          '購入が完了しました。',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Future<void> savePersonalInfo(String name, String postalCode, String address, String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', name);
  await prefs.setString('postalCode', postalCode);
  await prefs.setString('address', address);
  await prefs.setString('email', email);
}

Future<Map<String, String>> loadPersonalInfo() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'name': prefs.getString('name') ?? '',
    'postalCode': prefs.getString('postalCode') ?? '',
    'address': prefs.getString('address') ?? '',
    'email': prefs.getString('email') ?? '',
  };
}


