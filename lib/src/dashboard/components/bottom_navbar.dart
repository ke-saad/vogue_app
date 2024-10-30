import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined, color: selectedIndex == 0 ? Colors.red : Colors.red.withOpacity(0.5)),
          label: 'Buy',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined, color: selectedIndex == 1 ? Colors.red : Colors.red.withOpacity(0.5)),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, color: selectedIndex == 2 ? Colors.red : Colors.red.withOpacity(0.5)),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    );
  }
}