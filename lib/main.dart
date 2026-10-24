import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PuntoDeVentaApp());
}

class PuntoDeVentaApp extends StatefulWidget {
  const PuntoDeVentaApp({super.key});

  static PuntoDeVentaAppState of(BuildContext context) {
    final state = context.findAncestorStateOfType<PuntoDeVentaAppState>();
    assert(state != null, 'No PuntoDeVentaApp found in context');
    return state!;
  }

  @override
  State<PuntoDeVentaApp> createState() => PuntoDeVentaAppState();
}

class PuntoDeVentaAppState extends State<PuntoDeVentaApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Gestión de Inventario DEVS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: const SplashScreen(),
    );
  }
}
