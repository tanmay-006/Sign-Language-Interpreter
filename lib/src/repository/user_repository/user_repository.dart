import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_language_2/src/features/authentication/model/user_model.dart';

import '../authentication_repository/authentication_repository.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson())
        .whenComplete(
          () => Get.snackbar(
          "Success",
          "Your account has been created.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(1.0),
          colorText: Colors.white),
    ).catchError((error, stackTrace) {
      Get.snackbar(
          "Error",
          "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(1.0),
          colorText: Colors.white);
      print(error.toString());
    });
  }

  Future<UserModel> getUserDetailsByEmail(String email) async {
    final snapshot = await _db.collection("Users")
        .where("Email", isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      print("Fetched user data: $userData");
      return userData;
    } else {
      print("No user found with the provided email.");
      throw Exception("User not found");
    }
  }
  Future<UserModel> getUserDetails(String email, String fullname, String phoneNo, String password) async {
    print("Querying with email: $email, fullname: $fullname, phoneNo: $phoneNo, password: $password");
    final snapshot = await _db.collection("Users")
        .where("Email", isEqualTo: email)
        .where("Fullname", isEqualTo: fullname)
        .where("Phoneno", isEqualTo: phoneNo)
        .where("Password", isEqualTo: password)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      print("Fetched user data: $userData");
      return userData;
    } else {
      print("No user found with the provided details.");
      throw Exception("User not found");
    }
  }



  Future<List<UserModel>> allUsers() async {
    final snapshot = await _db.collection("Users").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("Users").doc(user.id).update(user.toJson());
  }
}
