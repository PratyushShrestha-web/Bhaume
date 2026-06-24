
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {//ui changes so statelful
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();//controls what is shown in screen
    
}
class _HomePageState extends State<Homepage>{
  int _selectedTab = 0; // for switching between tabs
  int _bottomNavIndex =0; //for bottom tabs


final List<Map<String, dynamic>> listings =[ //products stored in a map with key values, final 
//final is there to lock the variables
//content can still change
//array is used
//each item is in a map
//string is key type
//dynamic means value can be anything
   {
      'title': 'Sony WH-1000XM4 Headphones',
      'price': 'Rs.8,500',
      'originalPrice': 'Rs.15,000',
      'condition': 'Like New',
      'location': 'Jhapa',
      'tag': 'Buy Now',
      'tagColor': Color(0xFF22C55E),
      'actionLabel': 'Buy',
      
      'actionColor': Color(0xFF1A56DB),
      'imageColor': Color(0xFFFBBF24),
      'icon': Icons.headphones,
      'timer': null,
    },
    {
      'title': 'Vintage Leica Camera M6',
      'price': 'Rs.45,000',
      'originalPrice': null,
      'condition': 'Good',
      'location': 'Kathmandu',
      'tag': 'Auction',
      'tagColor': Color(0xFF8B5CF6),
      'actionLabel': 'Bid',
      'actionColor': Color(0xFF8B5CF6),
      'imageColor': Color(0xFF1F2937),
      'icon': Icons.camera_alt,
      'timer': '2h 14m',
    },
    {
      'title': 'IKEA Standing Desk (White)',
      'price': 'Rs.12,000',
      'originalPrice': null,
      'condition': 'Good',
      'location': 'Pokhara',
      'tag': 'Bargain',
      'tagColor': Color(0xFFF97316),
      'actionLabel': 'Offer',
      'actionColor': Color(0xFFF97316),
      'imageColor': Color(0xFFE5E7EB),
      'icon': Icons.desktop_windows,
      'timer': null,
    },
    {
      'title': 'Nike Air Jordan 1 Mid',
      'price': 'Rs.6,500',
      'originalPrice': null,
      'condition': 'New',
      'location': 'Dhankuta',
      'tag': 'Buy Now',
      'tagColor': Color(0xFF22C55E),
      'actionLabel': 'Buy',
      'actionColor': Color(0xFF1A56DB),
      'imageColor': Color(0xFFEF4444),
      'icon': Icons.sports_handball,
      'timer': null,
    },
  ];

  Color _tagColor(String tag) {
    switch (tag) {
      case 'Buy Now':
        return const Color(0xFF22C55E);
      case 'Auction':
        return const Color(0xFF8B5CF6);
      case 'Bargain':
        return const Color(0xFFF97316);
      default:
        return Colors.grey;
    }
  }
  //returns list of products
List<Map<String, dynamic>> get filteredListings{ //its a getter not a function
 if(_selectedTab == 0) return listings; //if user is on tab =0 it shows all the lsit of prodyuct

 final tags = ['Alls','Buy Now', 'Bargain','Auction']; //tag changes as tab changes
 final tag = tags[_selectedTab];//tag based on selected tab

 return listings.where((l) => l['tag'] == tag).toList();//it filters product using tag
}


@override
Widget build(BuildContext context){
  return Scaffold(//creates basic app screen
    backgroundColor: const Color (0xFFF3F4F6),//color 
    body: SafeArea(//away from phone edges
      child: Column(//arranges widgets vertically
        children: [
          _buildTopBar(),//custom bars
          _buildSearchBar(),
          _buildFilterTabs(),
          Expanded(child: SingleChildScrollView(//expands the space for scroll
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanner(),//displays the req thing
                _buildListingsHeader(),
                _buildGrid(),
                const SizedBox(height: 80),//adds extra space at the bottom so it doesnt cover it
              ],
            ),
          ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: _buildBottomNav(),//displays it
    floatingActionButton: _buildSellFAB(),//shows + button
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );

}
 Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Logo
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
                'Search products, categories...',
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

  Widget _buildFilterTabs() {
    final tabs = [
      {'label': 'All', 'icon': Icons.apps},
      {'label': 'Buy Now', 'icon': Icons.shopping_bag_outlined},
      {'label': 'Bargain', 'icon': Icons.local_offer_outlined},
      {'label': 'Auction', 'icon': Icons.gavel},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = _selectedTab == i;
          Color activeColor;
          switch (i) {
            case 1: activeColor = const Color(0xFF1A56DB); break;
            case 2: activeColor = const Color(0xFFF97316); break;
            case 3: activeColor = const Color(0xFF8B5CF6); break;
            default: activeColor = const Color(0xFF1A56DB);
          }
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: Container(
                margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: selected ? activeColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? activeColor : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabs[i]['icon'] as IconData,
                      size: 14,
                      color: selected ? Colors.white : const Color(0xFF374151),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tabs[i]['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A56DB), Color(0xFF3B82F6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Tag watermark
          Positioned(
            right: 16,
            top: 10,
            child: Icon(
              Icons.local_offer,
              size: 70,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New to BHAUME?',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const SizedBox(height: 2),
                const Text(
                  'SELL SMARTER.\nBUY BETTER.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LIST FOR FREE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Row(
        children: [
          Text(
            '${filteredListings.length} listings',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF111827),
            ),
          ),
          const Spacer(),
          const Text(
            'Sort',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF6B7280)),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final items = filteredListings;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, i) => _buildCard(items[i]),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    final tagColor = item['tagColor'] as Color;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  color: item['imageColor'] as Color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Center(
                  child: Icon(
                    item['icon'] as IconData,
                    size: 56,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ),
              // Tag badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['tag'] == 'Buy Now'
                            ? Icons.shopping_bag
                            : item['tag'] == 'Auction'
                                ? Icons.gavel
                                : Icons.local_offer,
                        color: Colors.white,
                        size: 10,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item['tag'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Heart icon
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 14, color: Color(0xFF6B7280)),
                ),
              ),
              // Timer badge
              if (item['timer'] != null)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time, color: Colors.white, size: 10),
                        const SizedBox(width: 3),
                        Text(
                          item['timer'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          // Info section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        item['price'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      if (item['originalPrice'] != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          item['originalPrice'] as String,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9CA3AF),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${item['condition']} · ${item['location']}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: item['actionColor'] as Color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item['actionLabel'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellFAB() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF97316),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF97316).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add, color: Colors.white, size: 22),
          Text(
            'Sell',
            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
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
          if (i == 2) return const SizedBox(width: 56); // FAB slot
          final selected = _bottomNavIndex == (i > 2 ? i - 1 : i);
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _bottomNavIndex = i > 2 ? i - 1 : i),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i]['icon'] as IconData,
                    size: 22,
                    color: selected
                        ? const Color(0xFF1A56DB)
                        : const Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    items[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: selected
                          ? const Color(0xFF1A56DB)
                          : const Color(0xFF9CA3AF),
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
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



