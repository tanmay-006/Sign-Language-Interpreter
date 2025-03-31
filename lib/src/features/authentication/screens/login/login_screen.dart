import 'package:flutter/material.dart';
import 'package:sign_language_2/src/features/authentication/screens/login/Login_Footer_Widget.dart';
import 'package:sign_language_2/src/features/authentication/screens/login/Login_Header_Widget.dart';
import 'package:sign_language_2/src/features/authentication/screens/login/Login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                const LoginHeaderWidget(),
                const SizedBox(height: 40),
                const LoginForm(),
                const SizedBox(height: 30),
                const LoginFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
