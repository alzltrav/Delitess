import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const AppNavBar({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    return BottomNavigationBar(
      currentIndex: activeIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          activeIcon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
      ],
    );
  }
}