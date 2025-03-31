import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_language_2/src/constants/textsize.dart';
import 'package:sign_language_2/src/features/authentication/controllers/otp_controller.dart';
import '../../../../../constants/text_strings.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = Get.put(OTPController());
    String? otp; // Changed to nullable String
    return Scaffold(
      body: SizedBox.expand(
        // 🟢 Ensures full-screen coverage
        child: Container(
          color: Colors.white, // Background color for entire screen
          padding: const EdgeInsets.all(tDefaultSize),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize:
                  MainAxisSize.min, // 🟢 Prevents unnecessary expansion
              children: [
                const SizedBox(height: 40.0),
                Text(
                  tOtptitle,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 60.0, // Reduced from 80.0 for better fit
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  tOtpsubtitle.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 40.0),
                const Text(
                  "$tOtpMessage support@coding.com",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40.0),
                OtpTextField(
                    numberOfFields: 6,
                    fillColor: Colors.black.withOpacity(0.1),
                    filled: true,
                    onSubmit: (code) {
                      otp = code;
                      OTPController.instance.verifyOTP(code);
                    }),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (otp != null && otp!.isNotEmpty) {
                        otpController.verifyOTP(
                            otp!); // Add null assertion operator here as well
                      } else {
                        // Show a snackbar or message to user that OTP is required
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter OTP code')),
                        );
                      }
                    },
                    child: const Text("Next"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
