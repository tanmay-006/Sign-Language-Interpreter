import 'package:get/get.dart';
import 'package:sign_language_2/src/repository/authentication_repository/authentication_repository.dart';
import '../screens/main_page/main_page.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  // Future<void> verifyOTP(String otp) async {
  //   try {
  //     print('Verifying OTP: $otp'); // Debug print
  //     var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
  //     print('OTP Verification Result: $isVerified'); // Debug print
  //     if (isVerified) {
  //       Get.offAll(modelpage(cameras: [],));
  //     } else {
  //       Get.back();
  //     }
  //   } catch (e) {
  //     print('OTP Verification Error: $e'); // Log the error
  //     Get.back(); // Navigate back in case of an error
  //   }
  // }


  void verifyOTP(String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified? Get.offAll(Modelpage) :Get.back();
  }

}