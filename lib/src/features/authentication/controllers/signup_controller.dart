import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_language_2/src/repository/user_repository/user_repository.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../model/user_model.dart';

class SignUpContoller extends GetxController {
  static SignUpContoller get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();
  final phoneNo = TextEditingController();
  final userRepo = Get.put(UserRepository());
  final isLoading = false.obs;

  // Add the hidePassword observable for password visibility
  final hidePassword = true.obs;

  Future<void> registerUser(String email, String password) async {
    isLoading.value = true;
    try {
      await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);
    } catch (error) {
      // Error handling is now done in AuthenticationRepository
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser(UserModel user) async {
    isLoading.value = true;
    try {
      String userEmail = user.email ?? '';
      String userPassword = user.password ?? '';

      // First create the user in Firebase Authentication
      await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(userEmail, userPassword);

      // Then store additional user data in Firestore or other DB
      await userRepo.createUser(user);
    } catch (error) {
      // Error is already handled in AuthenticationRepository
    } finally {
      isLoading.value = false;
    }
  }

  void phoneAuthentication(String phoneNo) {
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }
}
