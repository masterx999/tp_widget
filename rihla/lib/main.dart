import 'package:flutter/material.dart';

import 'services/api_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(RihlaApp());
}

class RihlaApp extends StatelessWidget {
  RihlaApp({super.key, ApiService? apiService})
    : apiService = apiService ?? ApiService();

  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rihla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7C86)),
      ),
      home: HomeScreen(apiService: apiService),
    );
  }
}
