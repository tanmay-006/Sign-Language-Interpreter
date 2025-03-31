import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_language_2/src/features/authentication/screens/SignUp/signup_screen.dart';
import 'package:sign_language_2/src/features/authentication/screens/login/login_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen(),
  ));
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Updated color palette
    const Color primaryColor = Color(0xFF52796F);
    const Color secondaryColor = Color(0xFF84A98C);
    const Color lightColor = Color(0xFFCAD2C5);
    const Color textDarkColor = Color(0xFF2C3639);

    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sign_language,
                  size: 60,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                "SignifyMe",
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: textDarkColor,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Breaking barriers through sign language",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: textDarkColor.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(),

              // Banner image or illustration could go here
              // Image.asset('assets/images/welcome/welcome_illustration.png'),

              const Spacer(),

              // Sign up button
              buildButton(context, "Create Account", primaryColor, Colors.white,
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              }),

              const SizedBox(height: 16),

              // Sign in button
              buildButton(context, "Sign In", Colors.transparent, primaryColor,
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }, isBorder: true, borderColor: primaryColor),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Color bgColor,
      Color textColor, VoidCallback onTap,
      {bool isBorder = false, Color borderColor = Colors.transparent}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: isBorder
              ? BorderSide(color: borderColor, width: 1.5)
              : BorderSide.none,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            )),
      ),
    );
  }
}
