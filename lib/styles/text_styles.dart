import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle heading1(BuildContext context) => GoogleFonts.poppins(
  fontSize: 32,
  fontWeight: FontWeight.w700,
  color: Theme.of(context).textTheme.headlineLarge?.color,
);

TextStyle secHead(BuildContext context) => GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Theme.of(context).textTheme.bodyMedium?.color,
);

TextStyle paraText(BuildContext context) => GoogleFonts.poppins(
  fontSize: 13,
  // fontWeight: FontWeight.w500,
  color: Theme.of(context).textTheme.bodyMedium?.color,
);

TextStyle navText(BuildContext context) => GoogleFonts.poppins(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Theme.of(context).textTheme.bodyMedium?.color,
);
