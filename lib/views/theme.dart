import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appThemeData = ThemeData(
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    displayLarge: GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  ),
);
