import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get heading1 => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  
  static TextStyle get heading2 => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );
  
  static TextStyle get heading3 => GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  
  static TextStyle get subtitle => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  
  static TextStyle get body => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  
  static TextStyle get caption => GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  
  static TextStyle get button => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  static TextStyle get chipText => GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  
  static TextStyle get statNumber => GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
}
