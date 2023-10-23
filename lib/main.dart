import 'package:flutter/material.dart';

import 'package:ip4u/home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP4U',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'IP4U'),
    );
  }
}
