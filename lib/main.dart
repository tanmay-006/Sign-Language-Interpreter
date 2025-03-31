import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_language_2/firebase_options.dart';
import 'package:sign_language_2/src/features/authentication/screens/welcome/welcome.dart';
import 'package:sign_language_2/src/repository/authentication_repository/authentication_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
          ),brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false, // Optional: Removes debug banner
      home: WelcomeScreen(),
    );
  }
}
