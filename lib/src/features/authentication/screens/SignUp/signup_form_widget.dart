import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_language_2/src/constants/text_strings.dart';

import '../../controllers/signup_controller.dart';
import '../../model/user_model.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpContoller());
    final formkey = GlobalKey<FormState>();

    // Natural color palette
    const Color primaryColor = Color(0xFF4A6D7C);
    const Color secondaryColor = Color(0xFF8BA888);
    const Color lightColor = Color(0xFFF0F4F3);
    const Color accentColor = Color(0xFFD8B49C);
    const Color textDarkColor = Color(0xFF2C3639);

    return Form(
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **Name Field**
          _buildTextField(
            controller: controller.fullname,
            icon: Icons.person_outline_rounded,
            label: name,
            hintText: "Enter your name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          /// **Email Field**
          _buildTextField(
            controller: controller.email,
            icon: Icons.email_outlined,
            label: email,
            hintText: "Enter your email",
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

          /// **Phone Number Field**
          _buildTextField(
            controller: controller.phoneNo,
            icon: Icons.phone,
            label: phoneno,
            hintText: "Enter your phone number",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!GetUtils.isPhoneNumber(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          /// **Password Field**
          Obx(() => TextFormField(
                style: GoogleFonts.poppins(
                  color: textDarkColor,
                  fontSize: 15,
                ),
                obscureText: controller.hidePassword.value,
                controller: controller.password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: primaryColor, size: 22),
                  labelText: password,
                  labelStyle:
                      GoogleFonts.poppins(color: primaryColor.withOpacity(0.8)),
                  hintText: "Enter your password",
                  hintStyle: GoogleFonts.poppins(color: Colors.black38),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: primaryColor,
                      size: 22,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: primaryColor, width: 1.5),
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
              )),
          const SizedBox(height: 30),

          /// **Sign Up Button**
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (formkey.currentState!.validate()) {
                            final user = UserModel(
                              email: controller.email.text.trim(),
                              password: controller.password.text.trim(),
                              fullname: controller.fullname.text.trim(),
                              phoneNo: controller.phoneNo.text.trim(),
                            );

                            await controller.createUser(user);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        )
                      : Text(
                          "Create Account",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                )),
          ),
        ],
      ),
    );
  }

  /// **Reusable TextField Builder**
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    // Natural color palette
    const Color primaryColor = Color(0xFF4A6D7C);
    const Color textDarkColor = Color(0xFF2C3639);

    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(
        color: textDarkColor,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        prefixIcon: Icon(icon, color: primaryColor, size: 22),
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: primaryColor.withOpacity(0.8)),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.black38),
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
      validator: validator,
    );
  }
}
