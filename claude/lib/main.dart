import 'package:flutter/material.dart';
import 'package:sorteio/home.dart';

void main() {
  runApp(const InstagramRaffleApp());
}

class InstagramRaffleApp extends StatelessWidget {
  const InstagramRaffleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorteio Instagram',
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      home: const RaffleHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
