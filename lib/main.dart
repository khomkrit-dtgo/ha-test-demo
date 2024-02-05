import 'package:flutter/material.dart';
import 'package:home_assistant_test_tool/config_screen.dart';
import 'package:home_assistant_test_tool/home_screen.dart';

/// Flutter code sample for [NavigationBar].

void main() => runApp(const HomeAssistantTestTool());

class HomeAssistantTestTool extends StatelessWidget {
  const HomeAssistantTestTool({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  int currentPageIndex = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const ConfigScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications_sharp),
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.notifications_outlined),
            ),
            label: 'Config',
          ),
        ],
      ),
      body: screens[currentPageIndex],
    );
  }
}
