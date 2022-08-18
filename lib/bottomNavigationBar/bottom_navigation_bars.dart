import 'package:demo_test/bottomNavigationBar/tab_item.dart';

import 'app.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key, 
    required this.onSelectTab,
    required this.tabs,
  }) : super(key: key);
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: tabs
          .map(
            (e) => _buildItem(
              index: e.getIndex(),
              icon: e.icon,
              tabName: e.tabName,
            ),
          )
          .toList(),
      onTap: (index) => onSelectTab(
        index,
      ),
    );
  }

  BottomNavigationBarItem _buildItem(
      {int index=0, IconData? icon, String tabName=""}) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _tabColor(index: index),
      ),
      label: tabName,
     
    );
  }

  Color _tabColor({required int index}) {
    return AppState.currentTab == index ? Colors.cyan : Colors.grey;
  }
}