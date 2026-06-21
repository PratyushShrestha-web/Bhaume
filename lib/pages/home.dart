
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

 final tags = ['All','Buy Now', 'Bargain','Auction']; //tag changes as tab changes
 final tag = tags[_selectedTab];//tag based on selected tab

 return listings.where((l) => l['tag'] == tag).toList();//it filters product using tag
}


@override
Widget build(BuildContext context){
  return Scaffold(
    body: Center(
      child: Text("Home Page"),
    ),
  );
}
}





