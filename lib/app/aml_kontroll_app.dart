import 'package:flutter/material.dart';

import '../features/dashboard/screens/app_home.dart';
import '../theme/app_colors.dart';

class AmlKontrollApp extends StatelessWidget {
  const AmlKontrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AML Kontrollrom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Arial',
        dividerColor: AppColors.line,
      ),
      home: const AppHome(),
    );
  }
}
