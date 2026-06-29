import 'dart:async';
import 'package:flutter/material.dart';
import 'bargain.dart';
import 'message.dart';
import 'sell.dart';

// ─────────────────────────────────────────────
//  Data models
// ─────────────────────────────────────────────

class BidEntry {
  final String username;
  final double amount;
  final String timeAgo;
  final bool isLeading;

  const BidEntry({
    required this.username,
    required this.amount,
    required this.timeAgo,
    this.isLeading = false,
  });
}

class ActiveAuction {
  final String title;
  final int bids;
  final String timeLeft;
  final double currentBid;
  final IconData icon;

  const ActiveAuction({
    required this.title,
    required this.bids,
    required this.timeLeft,
    required this.currentBid,
    required this.icon,
  });
}

// ─────────────────────────────────────────────
//  Main AuctionPage widget
// ─────────────────────────────────────────────

class AuctionPage extends StatefulWidget {
  /// Pass the shared [PageController] and [ValueNotifier] from your root
  /// scaffold so the bottom-nav stays in sync with home.dart.
  final PageController? pageController;
  final ValueNotifier<int>? selectedIndex;

  const AuctionPage({
    super.key,
    this.pageController,
    this.selectedIndex,
  });

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  // ── Palette ──────────────────────────────────
  static const Color _navy =  Color(0xFF1A56DB);
  static const Color _navyLight = Color(0xFF1E3A8A);
  static const Color _orange = Color(0xFFFF6B00);
  static const Color _white = Colors.white;
  static const Color _bgGrey = Color(0xFFF5F6FA);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textGrey = Color(0xFF8A8FA8);
  static const Color _green = Color(0xFF22C55E);
  static const Color _divider = Color(0xFFE8EAF0);

  // ── State ─────────────────────────────────────
  double _currentBid = 47500;
  int _totalBids = 3;
  final TextEditingController _bidController = TextEditingController();

  // Countdown: 2 h 14 m 20 s
  int _hours = 2;
  int _minutes = 14;
  int _seconds = 20;
  late Timer _timer;

  List<BidEntry> _bidHistory = const [
    BidEntry(username: 'user_xyz91', amount: 47500, timeAgo: '2 min ago', isLeading: true),
    BidEntry(username: 'priya_s', amount: 46000, timeAgo: '8 min ago'),
    BidEntry(username: 'arjun_k', amount: 45000, timeAgo: '15 min ago'),
  ];

  final List<ActiveAuction> _otherAuctions = const [
    ActiveAuction(
      title: 'Antique Brass Table Lamp',
      bids: 3,
      timeLeft: '5h 33m left',
      currentBid: 2200,
      icon: Icons.light,
    ),
    ActiveAuction(
      title: 'Vintage Wooden Clock',
      bids: 7,
      timeLeft: '1h 12m left',
      currentBid: 5500,
      icon: Icons.watch_later_outlined,
    ),
  ];

  // Bottom-nav index — mirrors home.dart convention (Auction = index 3)
  int get _navIndex => widget.selectedIndex?.value ?? 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else if (_minutes > 0) {
          _minutes--;
          _seconds = 59;
        } else if (_hours > 0) {
          _hours--;
          _minutes = 59;
          _seconds = 59;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _bidController.dispose();
    super.dispose();
  }

  // ── Bid logic ─────────────────────────────────
  void _placeBid() {
    final raw = _bidController.text.replaceAll(',', '').trim();
    final amount = double.tryParse(raw);
    final minimum = _currentBid + 500;

    if (amount == null || amount < minimum) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Minimum bid is ₹${_formatAmount(minimum)}'),
        ),
      );
      return;
    }

    setState(() {
      _currentBid = amount;
      _totalBids++;
      _bidHistory = [
        BidEntry(
          username: 'you',
          amount: amount,
          timeAgo: 'Just now',
          isLeading: true,
        ),
        ..._bidHistory.map((b) => BidEntry(
              username: b.username,
              amount: b.amount,
              timeAgo: b.timeAgo,
            )),
      ];
      _bidController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF22C55E),
        content: Text('Bid placed successfully!'),
      ),
    );
  }

  String _formatAmount(double v) =>
      v.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d)(?=(\d{2})+(?!\d))'),
            (m) => '${m[1]},',
          );

  // ── Nav helper ────────────────────────────────
  void _onNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BargainPage()),
        );
        return;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SellPage()),
        );
        return;
      case 3:
        if (widget.selectedIndex != null) {
          widget.selectedIndex!.value = index;
        }
        if (widget.pageController != null) {
          widget.pageController!.jumpToPage(index);
        }
        return;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MessagePage()),
        );
        return;
    }
  }

  // ── Build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildHeroHeader(),
                SliverToBoxAdapter(child: _buildBidCard()),
                SliverToBoxAdapter(child: _buildBidHistory()),
                SliverToBoxAdapter(child: _buildOtherAuctions()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  // ── Hero header ──────────────────────────────
  Widget _buildHeroHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor:const Color(0xFF1A56DB),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: _white, size: 18),
        onPressed: () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        },
      ),
      title: const Text(
        'Auction',
        style: TextStyle(
          color: _white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: 0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: _white),
              onPressed: () {},
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Camera hero image placeholder (deep blue gradient)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0D1B4B),  Color(0xFF1A56DB)],
                ),
              ),
              child: const Center(
                child: Icon(Icons.camera_alt_outlined,
                    size: 72, color: Color(0x44FFFFFF)),
              ),
            ),
            // Bottom overlay with item info
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [const Color(0xFF1A56DB), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LIVE badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: _white, size: 8),
                          SizedBox(width: 5),
                          Text(
                            'LIVE AUCTION',
                            style: TextStyle(
                              color: _white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Vintage Leica Camera M6',
                      style: TextStyle(
                        color: _white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Good · Delhi',
                      style: TextStyle(color: Color(0xAAFFFFFF), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bid card ─────────────────────────────────
  Widget _buildBidCard() {
    final minimum = _currentBid + 500;
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A56DB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current bid row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Bid',
                    style: TextStyle(color: Color(0xAAFFFFFF), fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs ${_formatAmount(_currentBid)}',
                    style: const TextStyle(
                      color: _white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '$_totalBids bids placed',
                    style: const TextStyle(
                        color: Color(0xAAFFFFFF), fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              // Countdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Ends In',
                    style:
                        TextStyle(color: Color(0xAAFFFFFF), fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _countdownBox(
                          _hours.toString().padLeft(2, '0'), 'H'),
                      const SizedBox(width: 4),
                      _countdownBox(
                          _minutes.toString().padLeft(2, '0'), 'M'),
                      const SizedBox(width: 4),
                      _countdownBox(
                          _seconds.toString().padLeft(2, '0'), 'S'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Bid input row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 41, 50, 91),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12, right: 4),
                        child: Text('Rs',
                            style: TextStyle(
                                color: Color(0xAAFFFFFF), fontSize: 16)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _bidController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: _white, fontSize: 14),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                'Min. Rs ${_formatAmount(minimum)}',
                            hintStyle: const TextStyle(
                                color: Color(0x66FFFFFF), fontSize: 13),
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _placeBid,
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: _orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'BID',
                    style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _countdownBox(String value, String label) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF1A56DB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  color: _white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14)),
          Text(label,
              style: const TextStyle(
                  color: Color(0xAAFFFFFF), fontSize: 9)),
        ],
      ),
    );
  }

  // ── Bid history ──────────────────────────────
  Widget _buildBidHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.trending_up, color: _orange, size: 18),
              SizedBox(width: 6),
              Text(
                'Bid History',
                style: TextStyle(
                  color: _textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._bidHistory.map((b) => _bidRow(b)),
        ],
      ),
    );
  }

  Widget _bidRow(BidEntry bid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Avatar dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: bid.isLeading ? _orange : _divider,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          // Username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bid.username,
                  style: TextStyle(
                    color: _textDark,
                    fontWeight: bid.isLeading
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Amount + time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs ${_formatAmount(bid.amount)}',
                style: const TextStyle(
                  color: Color(0xFF1A56DB),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                bid.timeAgo,
                style:
                    const TextStyle(color: _textGrey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Other auctions ───────────────────────────
  Widget _buildOtherAuctions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Other Active Auctions',
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          ..._otherAuctions.map((a) => _auctionCard(a)),
        ],
      ),
    );
  }

  Widget _auctionCard(ActiveAuction a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                color: Color(0xFF1A56DB),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: const TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${a.bids} bids · ${a.timeLeft}',
                  style: const TextStyle(
                      color: _textGrey, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  'Rs ${_formatAmount(a.currentBid)}',
                  style: const TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Bid button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening auction for ${a.title}'),
                ),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: _navy,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Bid',
                style: TextStyle(
                  color: _white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom nav ────────────────────────────────
  // Mirrors the style from the screenshot. Wire it to your home.dart's
  // PageController / selectedIndex notifier via the constructor params.
  Widget _buildBottomNav() {
    const items = [
      _NavItem(icon: Icons.home_outlined, label: 'Home'),
      _NavItem(icon: Icons.local_offer_outlined, label: 'Bargain'),
      _NavItem(icon: Icons.add_circle, label: '', isFab: true),
      _NavItem(icon: Icons.gavel_rounded, label: 'Auction'),
      _NavItem(icon: Icons.chat_bubble_outline, label: 'Chat'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: _white,
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -3)),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 4,
        top: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final item = items[i];
          final selected = _navIndex == i;

          if (item.isFab) {
            return GestureDetector(
              onTap: () => _onNavTap(i),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: _orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: _white, size: 26),
              ),
            );
          }

          return GestureDetector(
            onTap: () => _onNavTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  color: selected ? _navy : _textGrey,
                  size: 24,
                ),
                const SizedBox(height: 3),
                Text(
                  item.label,
                  style: TextStyle(
                    color: selected ? _navy : _textGrey,
                    fontSize: 11,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Nav item helper
// ─────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  final bool isFab;
  const _NavItem(
      {required this.icon, required this.label, this.isFab = false});
}

// ─────────────────────────────────────────────
//  HOW TO CONNECT TO home.dart
//
//  In your root widget (e.g. MainShell or wherever you build the
//  PageView + BottomNavigationBar), add two shared variables:
//
//    final PageController _pageController = PageController(initialPage: 0);
//    final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
//
//  Then pass them into every page including AuctionPage:
//
//    PageView(
//      controller: _pageController,
//      physics: const NeverScrollableScrollPhysics(),
//      children: [
//        HomePage(
//          pageController: _pageController,
//          selectedIndex: _selectedIndex,
//        ),
//        BargainPage(...),
//        SellPage(...),
//        AuctionPage(           // <── index 3
//          pageController: _pageController,
//          selectedIndex: _selectedIndex,
//        ),
//        ChatPage(...),
//      ],
//    )
//
//  The bottom nav inside AuctionPage calls _pageController.jumpToPage(index)
//  so tapping Home will animate back to HomePage — no code changes needed
//  in home.dart.
//
//  If your home.dart already owns the nav bar:
//    • Remove _buildBottomNav() from AuctionPage (or just hide it).
//    • Set selectedIndex to 3 when the user taps "Auction" in the parent nav.
// ─────────────────────────────────────────────