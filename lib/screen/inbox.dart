import 'package:flutter/material.dart';

class InboxPage extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;

  const InboxPage({super.key, required this.notifications});

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  void initState() {
    super.initState();
    print('通知リスト: ${widget.notifications}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: widget.notifications.isEmpty
          ? const Center(
              child: Text('通知はありません'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.notifications.length,
              itemBuilder: (context, index) {
                final notification = widget.notifications[index];
                final title = notification['title'] is String
                    ? notification['title']
                    : 'No Title';
                final body = notification['body'] is String
                    ? notification['body']
                    : 'No Body';
                final isRead = notification['isRead'] ?? false;

                return Card(
                  child: ListTile(
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(body),
                    trailing: isRead
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      if (title.contains('店舗')) {
                        Navigator.pop(context, 'shops');
                      } else if (title.contains('商品')) {
                        Navigator.pop(context, 'products');
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
