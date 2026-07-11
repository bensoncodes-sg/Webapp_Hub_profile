import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The "Nexus Minimalist" palette from the original design board.
class AppColors {
  AppColors._();

  static const bg = Color(0xFF0A0A0B); // Primary #0A0A0B
  static const backdrop = Color(0xFF17171A); // desktop page behind the phone frame
  static const surface = Color(0xFF141416); // card fill
  static const surfaceAlt = Color(0xFF161618); // Secondary #161618
  static const surfaceDeep = Color(0xFF0F0F11); // nested rows
  static const border = Color(0xFF1E1E22);
  static const borderStrong = Color(0xFF26262A);
  static const ring = Color(0xFF2A2A2E);

  static const accent = Color(0xFF2CCB7C); // Tertiary #2CCB7C
  static const accentInk = Color(0xFF05130D); // text on accent
  static const accentBgTint = Color(0xFF10201A);
  static const accentBorderTint = Color(0xFF1C3A2E);

  static const textPrimary = Color(0xFFF4F4F5);
  static const textSecondary = Color(0xFFB4B4BC);
  static const textMuted = Color(0xFF8A8A93);
  static const textFaint = Color(0xFF5A5A63);
  static const iconStrong = Color(0xFFD4D4DA);
}

/// Hanken Grotesk — the body/display face from the design system.
TextStyle sans({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color color = AppColors.textPrimary,
  double? letterSpacing,
  double? height,
}) {
  return GoogleFonts.hankenGrotesk(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );
}

/// JetBrains Mono — the technical/monospace accents.
TextStyle mono({
  double size = 12,
  FontWeight weight = FontWeight.w400,
  Color color = AppColors.textMuted,
  double? letterSpacing,
}) {
  return GoogleFonts.jetBrainsMono(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
  );
}
