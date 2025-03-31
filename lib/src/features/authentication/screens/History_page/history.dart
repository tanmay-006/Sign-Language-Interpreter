import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HistoryScreen(),
  ));
}

class HistoryScreen extends StatefulWidget {
  static List<String> recentItems = [];
  static List<String> savedItems = [];

  static void addRecentItem(String item) {
    recentItems.insert(0, item);
  }

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Color(0xFF2E7D32)),
            onPressed: () => _clearAllHistory(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2E7D32),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF2E7D32),
          tabs: const [
            Tab(text: "Recent"),
            Tab(text: "Saved"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(HistoryScreen.recentItems, isSavedTab: false),
          _buildList(HistoryScreen.savedItems, isSavedTab: true),
        ],
      ),
    );
  }

  Widget _buildList(List<String> items, {required bool isSavedTab}) {
    return items.isEmpty
        ? const Center(
      child: Text(
        "No history found",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        String item = items[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Slidable(
            key: ValueKey(item),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _toggleSave(item),
                  backgroundColor: HistoryScreen.savedItems.contains(item) ? Colors.red : Colors.green,
                  icon: HistoryScreen.savedItems.contains(item) ? Icons.favorite : Icons.favorite_border,
                  label: HistoryScreen.savedItems.contains(item) ? "Unsave" : "Save",
                ),
                SlidableAction(
                  onPressed: (_) => _removeItem(item, isSavedTab),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: "Delete",
                ),
              ],
            ),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(
                  Icons.history,
                  color: isSavedTab ? Colors.red : const Color(0xFF2E7D32),
                ),
                title: Text(
                  item,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow, color: Color(0xFF2E7D32)),
                  onPressed: () {
                    // Navigate back to Chat3DPage with the selected sign
                    Navigator.pop(context, item);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleSave(String text) {
    setState(() {
      if (HistoryScreen.savedItems.contains(text)) {
        HistoryScreen.savedItems.remove(text);
      } else {
        HistoryScreen.savedItems.add(text);
      }
    });
  }

  void _removeItem(String text, bool isSavedTab) {
    setState(() {
      if (isSavedTab) {
        HistoryScreen.savedItems.remove(text);
      } else {
        HistoryScreen.recentItems.remove(text);
      }
    });
  }

  void _clearAllHistory() {
    setState(() {
      HistoryScreen.recentItems.clear();
      HistoryScreen.savedItems.clear();
    });
  }
}
