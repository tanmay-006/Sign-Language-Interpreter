
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  final String? id;
  final String fullname;
  final String email;
  final String phoneNo;
  final String password;

  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.fullname,
    required this.phoneNo,

});
  // factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   final data = snapshot.data() as Map<String, dynamic>;
  //   return UserModel(
  //     fullname: data['Fullname'] ?? '',
  //     email: data['Email'] ?? '',
  //     phoneNo: data['Phoneno'] ?? '',
  //     password: data['Password'] ?? '',
  //   );
  // }

  toJson(){
    return{
      "Fullname":fullname,
      "Email":email,
      "Phoneno.":phoneNo,
      "Password":password,
    };
  }
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
      return UserModel(
      id: document.id,
      email: data["Email"] ?? "",
      fullname: data["Fullname"]?? "",
      password: data["Password"]?? "",
      phoneNo: data["Phoneno"]?? "",
    );
  }

}