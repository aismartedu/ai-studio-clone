import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ai_provider.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AiProvider(),
      child: const AiStudioClone(),
    ),
  );
}

class AiStudioClone extends StatelessWidget {
  const AiStudioClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),
      home: const LoginScreen(),
    );
  }
}
