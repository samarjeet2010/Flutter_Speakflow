import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/screens/home/home_dashboard.dart';
import 'package:untitled_2/screens/social/discover_screen.dart';
import 'package:untitled_2/screens/learning/exercises_screen.dart';
import 'package:untitled_2/screens/profile/profile_screen.dart';
import 'package:untitled_2/screens/ai/ai_chat_screen.dart';
import 'package:untitled_2/theme.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final screens = [
          const HomeDashboard(),
          const DiscoverScreen(),
          const ExercisesScreen(),
          const ProfileScreen(),
        ];

        return Scaffold(
          body: IndexedStack(
            index: provider.selectedBottomNavIndex,
            children: screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: provider.selectedBottomNavIndex,
            onDestinationSelected: provider.setBottomNavIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Discover',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: 'Exercises',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AIChatScreen()),
            ),
            child: const Icon(Icons.chat_bubble_outline),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
