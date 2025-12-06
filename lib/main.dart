import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_2/providers/app_provider.dart';
import 'package:untitled_2/screens/social/splash_screen.dart';
import 'package:untitled_2/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..initialize(),
      child: MaterialApp(
        title: 'PolyglotAI',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
