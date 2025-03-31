import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_language_2/src/constants/text_strings.dart';
import 'package:sign_language_2/src/features/authentication/screens/forgot_password/forgot_password_options/forget_password_model_bottom_sheet.dart';
import 'package:sign_language_2/src/repository/authentication_repository/authentication_repository.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  // Natural color palette
  static const Color primaryColor = Color(0xFF4A6D7C);
  static const Color secondaryColor = Color(0xFF8BA888);
  static const Color lightColor = Color(0xFFF0F4F3);
  static const Color accentColor = Color(0xFFD8B49C);
  static const Color textDarkColor = Color(0xFF2C3639);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          _buildTextField(
            controller: emailController,
            icon: Icons.email_outlined,
            label: mail,
            hint: email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password Field
          _buildTextField(
            controller: passwordController,
            icon: Icons.lock_outline,
            label: pass,
            hint: password,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          // Forgot Password Button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ForgetPasswordScreen.buildShowModalBottomSheet(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 0),
              ),
              child: Text(
                forgot,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Sign In Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          await AuthenticationRepository.instance
                              .loginWithEmailAndPassword(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            e.toString(),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withOpacity(0.1),
                            colorText: Colors.red,
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      "Sign In",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _isObscured : false,
      validator: validator,
      style: GoogleFonts.poppins(
        color: textDarkColor,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        prefixIcon: Icon(icon, color: primaryColor, size: 22),
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.poppins(color: primaryColor.withOpacity(0.8)),
        hintStyle: GoogleFonts.poppins(color: Colors.black38),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: primaryColor,
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
