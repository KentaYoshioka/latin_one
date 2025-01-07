import 'package:flutter/material.dart';
import '../style.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InboxPage extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;
  final String deviceToken;
  final String initialTab;

  const InboxPage({
    super.key,
    required this.notifications,
    required this.deviceToken,
    this.initialTab = 'news',
  });

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> news = [];
  List<Map<String, dynamic>> messages = [];
  final supabase = Supabase.instance.client;

  Future<void> fetchMenu() async {
    try {
      final response = await supabase.from('inboxs').select();
      setState(() {
        news = response.cast<Map<String, dynamic>>().reversed.take(10).toList();
      });
        } catch (e) {
      debugPrint('Error fetching menu: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    // 初期タブを設定
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab == 'message' ? 1 : 0,
    );

    messages = widget.notifications;
    fetchMenu();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56 * (SizeConfig.screenHeightRatio ?? 1.0)),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'News'),
              Tab(text: 'Message'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // News Tab
          news.isEmpty
              ? const Center(
            child: Text('Newsはまだありません'),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: news.length,
            itemBuilder: (context, index) {
              final item = news[index];
              final title = item['title'] ?? 'No Title';
              final description = item['description'] ?? 'No Description';

              return Card(
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(description),
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
          // Message Tab
          messages.isEmpty
              ? const Center(
            child: Text('通知はありません'),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final notification = messages[index];
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
                      fontWeight: isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(body),
                  trailing: isRead
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
