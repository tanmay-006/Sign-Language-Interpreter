import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sign_language_2/src/features/authentication/model/user_model.dart';
import '../../../../constants/color.dart';
import '../../../../constants/textsize.dart';
import '../../controllers/profileController.dart';
// import 'package:intl/intl.dart'; // For formatting date/time

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid, color: Colors.black),
        ),
        title: Text("Edit Profile",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // Increased padding
          child: FutureBuilder<UserModel>(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data!;

                  // Controllers for editing fields
                  final fullnameController = TextEditingController(text: userData.fullname);
                  final emailController = TextEditingController(text: userData.email);
                  final phoneController = TextEditingController(text: userData.phoneNo);
                  final passwordController = TextEditingController(text: userData.password);

                  // Formatting the joined date
                  // String formattedDate = userData.joinedAt != null
                  //     ? DateFormat('yyyy-MM-dd HH:mm:ss').format(userData.joinedAt!)
                  //     : "Unknown";

                  return Column(
                    children: [
                      // Profile Image
                      Center(
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage("assets/images/profile.png"),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: tPrimaryColor,
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(LineAwesomeIcons.camera_solid, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Form with increased width
                      SizedBox(
                        width: double.infinity, // Form takes full width
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildTextField("Full Name", LineAwesomeIcons.user, fullnameController),
                              buildTextField("Email", LineAwesomeIcons.envelope, emailController),
                              buildTextField("Phone No", LineAwesomeIcons.phone_solid, phoneController),
                              buildTextField("Password", Icons.lock, passwordController, obscureText: true),

                              const SizedBox(height: tformheight),

                              // Save Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tPrimaryColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: () async {},
                                  child: const Text("Save Changes", style: TextStyle(fontSize: 16, color: Colors.white)),
                                ),
                              ),
                              const SizedBox(height: tformheight),

                              // Joined Date & Delete Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Joined At: ", //$formattedDate
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.withOpacity(0.1), // Light green background
                                      foregroundColor: Colors.green, // Text color green
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: const Text("Delete",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString(), style: const TextStyle(color: Colors.red)));
                } else {
                  return const Center(child: Text("Something went wrong", style: TextStyle(color: Colors.red)));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget buildTextField(String label, IconData icon, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: double.infinity, // Ensures the text field is full width
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black), // Input text color
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black), // Label text color changed to black
            prefixIcon: Icon(icon, color: Colors.black), // Icon color changed to black
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
