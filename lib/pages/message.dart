import 'package:flutter/material.dart';
import 'bargain.dart';
import 'auction.dart';
import 'home.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color(0xFF1A56DB),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Chat screen'),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.local_offer_outlined, 'label': 'Bargain'},
      {'icon': Icons.add, 'label': ''},
      {'icon': Icons.gavel, 'label': 'Auction'},
      {'icon': Icons.chat_bubble_outline, 'label': 'Chat'},
    ];

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          if (i == 2) return const SizedBox(width: 56);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (i == 0) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const Homepage()),
                    (route) => false,
                  );
                } else if (i == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => BargainPage()),
                  );
                } else if (i == 3) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AuctionPage()),
                  );
                } else if (i == 4) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MessagePage()),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i]['icon'] as IconData,
                    size: 22,
                    color: i == 4
                        ? const Color(0xFF1A56DB)
                        : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    items[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: i == 4
                          ? const Color(0xFF1A56DB)
                          : const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
