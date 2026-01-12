import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A0F30),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const StarLifeApp());
}

/// Main application widget
class StarLifeApp extends StatelessWidget {
  const StarLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Life',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
