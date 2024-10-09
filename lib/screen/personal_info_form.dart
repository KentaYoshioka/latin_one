import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoForm extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final int totalAmount;

  const PersonalInfoForm({super.key, required this.products, required this.totalAmount});

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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

  Future<void> _searchAddress() async {
    // ここで郵便番号から住所を検索する処理を実装予定
    setState(() {
      _addressController.text = 'ここで郵便番号から住所を検索する処理を実装予定';  // 例として、固定値
    });
  }

  Future<void> _copyToClipboard() async {
    String clipboardText = '【個人情報】\n'
        '名前: ${_nameController.text}\n'
        '郵便番号: ${_postalCodeController.text}\n'
        '住所: ${_addressController.text}\n'
        'メールアドレス: ${_emailController.text}\n\n';

    clipboardText += '【注文商品】\n';
    for (var product in widget.products) {
      clipboardText +=
          '\n${product['title']} - ${product['quantity']}g - ¥${product['totalPrice']}\n';
    }
    clipboardText += '\nTotal: ¥${widget.totalAmount}';

    Clipboard.setData(ClipboardData(text: clipboardText));
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
                  return null;
                },
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
                  if (_formKey.currentState!.validate()) {
                    await _savePersonalInfo();  // 購入時に個人情報を保存
                    await _copyToClipboard();
                    products=[];
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const PurchaseCompletePage()),
                    );
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


