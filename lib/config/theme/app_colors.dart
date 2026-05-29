import 'package:flutter/material.dart';

class AppColors {
  // Primary TNPSC-themed palette
  static const Color primaryBlue = Color(0xFF1A237E);
  static const Color primaryIndigo = Color(0xFF283593);
  static const Color accentGold = Color(0xFFFFB300);
  static const Color accentAmber = Color(0xFFFFC107);
  
  // Gradient colors
  static const Color gradientStart = Color(0xFF1A237E);
  static const Color gradientMiddle = Color(0xFF3949AB);
  static const Color gradientEnd = Color(0xFF5C6BC0);
  
  // Dark theme
  static const Color darkBg = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF1C2333);
  static const Color darkBorder = Color(0xFF30363D);
  
  // Light theme
  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  
  // Status colors
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFAB00);
  static const Color info = Color(0xFF448AFF);
  
  // Category colors
  static const Color aptitudeColor = Color(0xFF6C63FF);
  static const Color reasoningColor = Color(0xFFFF6584);
  static const Color verbalColor = Color(0xFF00BFA6);
  static const Color currentAffairsColor = Color(0xFFFF9100);
  static const Color mockTestColor = Color(0xFF7C4DFF);
  static const Color generalStudiesColor = Color(0xFF00B0FF);
  
  // Text colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDarkSecondary = Color(0xFF8B949E);
  
  // Glassmorphism
  static const Color glassWhite = Color(0x33FFFFFF);
  static const Color glassDark = Color(0x33000000);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C853), Color(0xFF00E676)],
  );
  
  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C2333), Color(0xFF252D3D)],
  );
}
