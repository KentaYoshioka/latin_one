import 'package:flutter/material.dart';

class Topic2Page extends StatelessWidget {
  const Topic2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topic2'),
      ),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('To be continued...'),
            ],
          ),
        ),
      ),
    );
  }
}