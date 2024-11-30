import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kyn_2/features/auth/controller/auth_controller.dart';
import 'package:kyn_2/core/theme/theme.dart';
import 'package:kyn_2/features/explore/explore_screen.dart';
import 'package:kyn_2/features/maps/map_screen.dart';
import 'package:kyn_2/features/settings/screens/settings.dart';
import 'package:kyn_2/features/events/home/screens/home_screen_hot.dart';

class Navigation extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const Navigation(),
      );
  const Navigation({super.key});

  @override
  ConsumerState<Navigation> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider); // Watching the theme
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: theme.indicatorColor, // Sets the indicator color
        backgroundColor:
            theme.scaffoldBackgroundColor, // Custom background color
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.explore),
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.event_available_rounded),
            icon: Icon(Icons.event),
            label: 'Posts',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.map_sharp),
            icon: Icon(Icons.map_outlined),
            label: 'Maps',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          HomePage(),
          WhatshotHomeScreen(),
          MapScreen(),
          Settings(),
        ],
      ),
    );
  }
}
