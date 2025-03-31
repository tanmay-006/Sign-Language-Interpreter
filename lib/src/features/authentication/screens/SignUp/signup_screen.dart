import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_language_2/src/constants/text_strings.dart';
import 'package:sign_language_2/src/features/authentication/screens/SignUp/signup_form_widget.dart';
import 'package:sign_language_2/src/features/authentication/screens/SignUp/signup_footer_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Updated color palette
    const Color primaryColor = Color(0xFF52796F);
    const Color secondaryColor = Color(0xFF84A98C);
    const Color lightColor = Color(0xFFCAD2C5);
    const Color textDarkColor = Color(0xFF2C3639);

    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textDarkColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  tSignUp,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textDarkColor,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  "Create an account to get started",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: textDarkColor.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),

                // Form
                const SignUpFormWidget(),
                const SizedBox(height: 30),

                // Footer
                const SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
