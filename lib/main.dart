import 'package:flutter/material.dart';

import 'ui/screens/gempa_screen.dart';
import 'ui/widgets/app_colors.dart';

void main() => runApp(const GempaApp());

class GempaApp extends StatelessWidget {
  const GempaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantau Gempa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.biru,
        scaffoldBackgroundColor: AppColors.mint,
      ),
      home: const GempaScreen(),
    );
  }
}
