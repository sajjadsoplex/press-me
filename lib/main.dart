import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/press_me_screen.dart';

void main() {
  runApp(const PressMeApp());
}

class PressMeApp extends StatelessWidget {
  const PressMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRESS ME',
      theme: AppTheme.darkTheme,
      home: const PressMeScreen(),
    );
  }
}