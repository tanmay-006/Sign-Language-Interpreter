import 'package:flutter/material.dart';
import 'package:sign_language_2/src/constants/text_strings.dart';
import 'package:sign_language_2/src/features/authentication/screens/forgot_password/forget_pwassword_mail/forgot_password_mail_screen.dart';

class ForgetPasswordMail extends StatelessWidget {
  const ForgetPasswordMail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          color: Colors.white,
          child: Column( // ✅ Removed `const`
            children: [
              const SizedBox(height: 40),

              const ForgotPasswordMailScreen( // ✅ Removed `const`
                image: 'assets/images/google/forgotpasswordimage.png',
                title: 'Forgot Password',
                heightbetween: 30.0,
                crossAxisAlignment: CrossAxisAlignment.center,
                subTitle: tforgetpasswordsubtitle,
              ),

              const SizedBox(height: 20),

              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        
                        labelText: "E-mail",
                        hintText: "Enter your E-mail",
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: (){},
                        child: const Text("Next")
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
