import 'package:flutter/material.dart';
import 'screens/mahasiswa_screen.dart';

void main() {
  runApp(const MahasiswaApp());
}

class MahasiswaApp extends StatelessWidget {
  const MahasiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajemen Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MahasiswaScreen(),
    );
  }
}