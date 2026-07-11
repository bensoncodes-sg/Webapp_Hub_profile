import 'package:flutter/material.dart';

import 'card_screen.dart';
import 'theme.dart';

void main() => runApp(const NfcCardApp());

class NfcCardApp extends StatelessWidget {
  const NfcCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Benson Phuah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: const CardScreen(),
    );
  }
}
