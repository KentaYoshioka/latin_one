import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './page.dart' as page;

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MaterialApp(
          title: 'LatinOne',
          home: const page.Page(title: 'LatinOne'),
      ));
}
