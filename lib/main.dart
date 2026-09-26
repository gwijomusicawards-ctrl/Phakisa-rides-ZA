import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PhakisaApp());
}

class PhakisaApp extends StatelessWidget {
  const PhakisaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phakisa Rides ZA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111111)),
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const RoleScreen(),
    );
  }
}
