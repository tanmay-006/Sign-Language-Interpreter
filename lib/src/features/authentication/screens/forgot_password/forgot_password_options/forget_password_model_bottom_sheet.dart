import 'package:flutter/material.dart';
import 'package:sign_language_2/src/constants/text_strings.dart';
import 'package:sign_language_2/src/features/authentication/screens/forgot_password/forget_pwassword_mail/forget_password_mail.dart';
import 'package:sign_language_2/src/features/authentication/screens/forgot_password/forgot_password_options/forgot_password_btn_Widget.dart';

import '../forgot_password_otp/otp_screen.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              tforgetpasswordtitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.black, // Ensure text color is black
              ),
            ),
            const SizedBox(height: 5),
            // Subtitle
            Text(
              tforgetpasswordsubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black, // Ensure text color is black
              ),
            ),
            const SizedBox(height: 20),

            // Email Reset Option
            ForgetPasswordBtnWidget(
              btnIcon: Icons.mail_outline_rounded,
              title: "E-mail",
              subTitle: tresetviaemail,
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgetPasswordMail()),
                );
              },
            ),
            const SizedBox(height: 20),

            // Phone Reset Option
            ForgetPasswordBtnWidget(
              btnIcon: Icons.mobile_friendly_rounded,
              title: "Phone no",
              subTitle: tresetviaphone,
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OTPScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
