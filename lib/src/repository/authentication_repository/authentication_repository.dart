import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sign_language_2/src/features/authentication/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import '../../features/authentication/screens/main_page/main_page.dart';
import 'exceptions/signup_email_password_failure.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser; // Initialize immediately
  var verificationId = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => WelcomeScreen());
    } else {
      Get.offAll(() => Modelpage(
            cameras: const [],
          ));
    }
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credentials) async {
        await _auth.signInWithCredential(credentials);
      },
      codeSent: (verficationId, resentToken) {
        verificationId.value = verficationId;
      },
      codeAutoRetrievalTimeout: (verficationId) {
        verificationId.value = verficationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'The provided phone number is invalid');
        } else {
          Get.snackbar('Error', 'Verification failed: ${e.message}');
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      var credentials = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId.value, smsCode: otp));
      return credentials.user != null ? true : false;
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP code');
      return false;
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar(
        'Success',
        'Account created successfully!',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      // Navigation will be handled by firebaseUser listener in onReady
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      Get.snackbar(
        'Error',
        ex.message,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      throw ex;
    } catch (e) {
      var ex = SignUpWithEmailAndPasswordFailure();
      Get.snackbar(
        'Error',
        ex.message,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        'Success',
        'Welcome back!',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      // Navigation will be handled by firebaseUser listener in onReady
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Authentication failed';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        default:
          errorMessage = 'Authentication failed: ${e.message}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      throw errorMessage;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      throw 'An unexpected error occurred';
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.snackbar('Success', 'Logged out successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out');
    }
  }
}
