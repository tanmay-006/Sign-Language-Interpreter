import 'package:get/get.dart';
import 'package:sign_language_2/src/repository/user_repository/user_repository.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';
import '../model/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  Future<UserModel> getUserData() async {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      try {
        // First, try to fetch the user by email
        final user = await _userRepo.getUserDetailsByEmail(email);
        return user;
      } catch (e) {
        print("Error fetching user by email: $e");
        // Fallback: Fetch all users and find the match
        final allUsers = await _userRepo.allUsers();
        final user = allUsers.firstWhere(
              (user) => user.email == email,
          orElse: () => throw Exception("User not found"),
        );
        final fullname = user.fullname ?? '';
        final phoneNo = user.phoneNo ?? '';
        final password = user.password ?? '';
        return _userRepo.getUserDetails(email, fullname, phoneNo, password);
      }
    } else {
      Get.snackbar("Error", "Login to continue");
      throw Exception("User not authenticated");
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    return await _userRepo.allUsers();
  }

  Future<void> updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }
}


