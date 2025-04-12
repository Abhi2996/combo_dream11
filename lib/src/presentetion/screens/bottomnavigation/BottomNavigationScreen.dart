import 'package:combo_dream11/src/presentetion/screens/dashboard/dashboard_screen.dart';
import 'package:combo_dream11/src/presentetion/screens/player_list_screen/player_list_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const BottomNavigationScreen(),
    );
  }
}

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.cyanAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.monitor), label: 'Monitor'),
          NavigationDestination(
            // icon:
            //     Badge(label: Text('3'), child: Icon(Icons.notifications_sharp)),
            icon: Icon(Icons.notifications_sharp),
            label: 'Notifications',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body:
          <Widget>[
            // Home page
            const DashboardScreen(),
            const PlayerListPage(),
            // // Notifications page
            DashboardScreen(),
            DashboardScreen(),
            // // Messages page
          ][currentPageIndex],
    );
  }
}

// Home page widget
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Center(
          child: Text('Home page', style: theme.textTheme.titleLarge),
        ),
      ),
    );
  }
}
