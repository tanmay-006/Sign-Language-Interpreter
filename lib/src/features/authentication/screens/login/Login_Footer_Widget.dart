import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_language_2/src/constants/images_strings.dart';
import 'package:sign_language_2/src/constants/text_strings.dart';
import 'package:sign_language_2/src/features/authentication/screens/SignUp/signup_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Updated color palette
    const Color primaryColor = Color(0xFF52796F);
    const Color secondaryColor = Color(0xFF84A98C);
    const Color lightColor = Color(0xFFCAD2C5);
    const Color textDarkColor = Color(0xFF2C3639);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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

        // Google Sign In Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(google, width: 24),
            ),
            onPressed: () {}, // TODO: Implement Google Sign-In
            label: Text(
              "Sign in with Google",
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

        // Sign Up Text
        RichText(
          text: TextSpan(
            text: donthaveanacc,
            style: GoogleFonts.poppins(
              color: textDarkColor.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: " $tSignUp",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(() => const SignUpScreen());
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
