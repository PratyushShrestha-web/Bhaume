import 'package:flutter/material.dart';

class BargainPage extends StatefulWidget {
  final Map<String, dynamic>? item;

  const BargainPage({super.key, this.item});

  @override
  State<BargainPage> createState() => _BargainPageState();
}

class _BargainPageState extends State<BargainPage> {
  int _bottomNavIndex = 1;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Map<String, dynamic> get _product => widget.item ?? {
        'title': 'IKEA Standing Desk (White)',
        'price': 'Rs.12,000',
        'tag': 'Bargain',
        'imageColor': const Color(0xFFE5E7EB),
        'icon': Icons.desktop_windows,
      };

  @override
  void dispose() {
    _messageController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            _buildSearchBar(),
            Expanded(
              child: Column(
                children: [
                  _buildProductCard(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildChatArea()),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildInputRow(),
            const SizedBox(height: 12),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          ),
          const SizedBox(width: 12),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'BHAU',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
                TextSpan(
                  text: 'ME',
                  style: TextStyle(
                    color: Color(0xFFF97316),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              const Icon(Icons.notifications_outlined, size: 26, color: Color(0xFF374151)),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF6B7280),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Search chat, offers... ',
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              ),
            ),
            const Icon(Icons.tune, color: Color(0xFF9CA3AF), size: 20),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _product['imageColor'] as Color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_product['icon'] as IconData, color: const Color(0xFF111827)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _product['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Listed at ${_product['price']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _product['tag'] as String,
                  style: const TextStyle(
                    color: Color(0xFFB45309),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Bargain chat',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView(
        children: [
          _buildChatBubble(
            text: 'Hi! I\'m interested in the MacBook. Is the price flexible?',
            time: '10:22 AM',
            isSent: false,
          ),
          const SizedBox(height: 10),
          _buildChatBubble(
            text: 'Hey Ravi! Yes, willing to negotiate a bit. What did you have in mind?',
            time: '10:25 AM',
            isSent: true,
          ),
          const SizedBox(height: 10),
          _buildOfferBubble(
            amount: '₹65,000',
            status: 'Declined',
            color: const Color(0xFFFEE2E2),
            borderColor: const Color(0xFFEF4444),
            icon: Icons.close,
            time: '10:27 AM',
          ),
          const SizedBox(height: 10),
          _buildChatBubble(
            text: 'That\'s a bit low. Best I can do is ₹70,000 — it\'s in excellent condition with original box.',
            time: '10:30 AM',
            isSent: true,
          ),
          const SizedBox(height: 10),
          _buildOfferBubble(
            amount: '₹70,000',
            status: 'Accepted',
            color: const Color(0xFFE6F4EA),
            borderColor: const Color(0xFF16A34A),
            icon: Icons.check,
            time: '10:33 AM',
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Make Offer',
                  style: TextStyle(
                    color: Color(0xFF1A56DB),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  final amount = _amountController.text.trim();
                  if (amount.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Offer sent: ₹$amount')),
                    );
                    _amountController.clear();
                  }
                },
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A56DB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A56DB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({
    required String text,
    required String time,
    required bool isSent,
  }) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSent ? const Color(0xFF1A56DB) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isSent ? 16 : 4),
                bottomRight: Radius.circular(isSent ? 4 : 16),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSent ? Colors.white : const Color(0xFF111827),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferBubble({
    required String amount,
    required String status,
    required Color color,
    required Color borderColor,
    required IconData icon,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 142,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'COUNTER OFFER',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                amount,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: borderColor),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(icon, color: borderColor, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
        ),
      ],
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
          final selected = _bottomNavIndex == (i > 2 ? i - 1 : i);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (i == 0) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else {
                  setState(() => _bottomNavIndex = i > 2 ? i - 1 : i);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i]['icon'] as IconData,
                    size: 22,
                    color: selected ? const Color(0xFF1A56DB) : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    items[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: selected ? const Color(0xFF1A56DB) : const Color(0xFF9CA3AF),
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
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
