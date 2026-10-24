import 'package:flutter/material.dart';

/// Archivo central del diseño del sistema.
/// Contiene todos los tokens de diseño: colores, tipografía, espaciados, bordes, etc.
class AppDesign {
  AppDesign._();

  // Colores base
  static const Color navy = Color(0xFF0A1331);
  static const Color navyLight = Color(0xFF232A4F);
  static const Color blue = Color(0xFF286AAD);
  static const Color blueLight = Color(0xFF47AED3);
  static const Color coral = Color(0xFFEDC6B9);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Colores modo claro
  static const Color backgroundLight = Color(0xFFF4F0F8);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0A1331);
  static const Color textSecondaryLight = Color(0xFF77778B);
  static const Color borderLight = Color(0xFFE2DCEA);
  static const Color dividerLight = Color(0xFFE8E5F0);

  // Colores modo oscuro
  static const Color backgroundDark = Color(0xFF0F0F1E);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color surfaceVariantDark = Color(0xFF252542);
  static const Color textPrimaryDark = Color(0xFFE4E4E7);
  static const Color textSecondaryDark = Color(0xFFA1A1AA);
  static const Color borderDark = Color(0xFF3F3F5A);
  static const Color dividerDark = Color(0xFF2D2D44);

  // Espaciados
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  static const double spacingXxxl = 64.0;

  // Bordes redondeados
  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;
  static const double radiusCircular = 100.0;

  // Elevaciones
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 18.0;

  // Duraciones de animación
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Tipografía
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.1,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.0,
    height: 1.3,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
  );

  // Decoraciones comunes
  static BoxDecoration cardDecoration({bool isDark = false}) {
    return BoxDecoration(
      color: isDark ? surfaceDark : surfaceLight,
      borderRadius: BorderRadius.circular(radiusLg),
      border: Border.all(
        color: isDark ? borderDark : borderLight,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: (isDark ? Colors.black : navy).withValues(alpha: isDark ? 0.3 : 0.06),
          blurRadius: elevationXl,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration inputDecoration({bool isDark = false}) {
    return BoxDecoration(
      color: isDark ? surfaceVariantDark : surfaceLight,
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(
        color: isDark ? borderDark : borderLight,
        width: 1,
      ),
    );
  }

  static BoxDecoration buttonDecoration({
    required Color color,
    bool isDark = false,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radiusMd),
    );
  }

  // Sombras
  static List<BoxShadow> shadowSm({bool isDark = false}) => [
        BoxShadow(
          color: (isDark ? Colors.black : navy).withValues(alpha: isDark ? 0.4 : 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> shadowMd({bool isDark = false}) => [
        BoxShadow(
          color: (isDark ? Colors.black : navy).withValues(alpha: isDark ? 0.4 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> shadowLg({bool isDark = false}) => [
        BoxShadow(
          color: (isDark ? Colors.black : navy).withValues(alpha: isDark ? 0.5 : 0.08),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
}
