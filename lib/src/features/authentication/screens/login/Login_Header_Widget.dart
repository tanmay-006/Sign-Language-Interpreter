import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_language_2/src/constants/text_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color textDarkColor = Color(0xFF2C3639);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tSignIn,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textDarkColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Welcome back! Please sign in to continue",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: textDarkColor.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
