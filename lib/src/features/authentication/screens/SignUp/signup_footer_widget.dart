import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_language_2/src/constants/images_strings.dart';
import 'package:sign_language_2/src/constants/text_strings.dart';
import 'package:sign_language_2/src/features/authentication/screens/login/login_screen.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Natural color palette
    const Color primaryColor = Color(0xFF4A6D7C);
    const Color secondaryColor = Color(0xFF8BA888);
    const Color textDarkColor = Color(0xFF2C3639);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OR",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),

        /// **Google Sign-Up Button**
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {}, // TODO: Implement Google Sign-Up
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(google, width: 24),
            ),
            label: Text(
              "Sign up with Google",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textDarkColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),

        /// **Already Have an Account?**
        RichText(
          text: TextSpan(
            text: alreadyacc,
            style: GoogleFonts.poppins(
              color: textDarkColor.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: " Sign In",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(() => const LoginScreen());
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
