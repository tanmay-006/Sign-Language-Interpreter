import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../constants/color.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../Profile_page/profile_page.dart';
import '../../controllers/profileController.dart';
import '../../model/user_model.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _image;
  final picker = ImagePicker();
  final profileController = Get.put(ProfileController());

  // Function to Pick Image
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to Open Social Media Links
  Future<void> _openURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not launch $url"),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  // Function to Handle Logout
  void _logout() {
    Get.defaultDialog(
      title: "Sign Out",
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2E3033),
      ),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      titlePadding: const EdgeInsets.only(top: 20, bottom: 8),
      radius: 8,
      content: const Text(
        "Are you sure you want to sign out?",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 14,
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFF6B7280),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text("Cancel"),
      ),
      confirm: TextButton(
        onPressed: () {
          AuthenticationRepository.instance.logout();
          Get.back();
        },
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFFDC3545),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text("Sign Out"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3033),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.angle_left_solid,
              color: Color(0xFF2E3033)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<UserModel>(
        future: profileController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: tPrimaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade400,
                    size: 50,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading data: ${snapshot.error}",
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Picture with Upload Option
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: tPrimaryColor.withOpacity(0.2),
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.grey[100],
                                backgroundImage: _image != null
                                    ? FileImage(_image!) as ImageProvider
                                    : const AssetImage(
                                        "assets/images/profile.png"),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: tPrimaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    LineAwesomeIcons.camera_solid,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userData.fullname,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3033),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        if (userData.phoneNo.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              userData.phoneNo,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account Settings Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 12),
                          child: Text(
                            "ACCOUNT SETTINGS",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        _buildAccountButton(
                          LineAwesomeIcons.user,
                          "Profile",
                          "Manage your personal information",
                          () => Get.to(() => const ProfileScreen()),
                        ),
                        _buildAccountButton(
                          LineAwesomeIcons.envelope,
                          "Email Address",
                          "Update your email address",
                          () {},
                        ),
                        _buildAccountButton(
                          LineAwesomeIcons.file_download_solid,
                          "Downloads",
                          "Access your downloaded content",
                          () {},
                        ),
                        _buildAccountButton(
                          Icons
                              .lock_outline, // Using Flutter built-in icon instead
                          "Password & Security",
                          "Update your security settings",
                          () {},
                        ),

                        const SizedBox(height: 28),

                        // Logout Button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: OutlinedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(
                              Icons
                                  .logout_rounded, // Using Flutter built-in icon instead
                              color: Color(0xFFDC3545),
                              size: 18,
                            ),
                            label: const Text(
                              "Sign Out",
                              style: TextStyle(
                                color: Color(0xFFDC3545),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                  color:
                                      const Color(0xFFDC3545).withOpacity(0.5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Connect with us
                  const Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 16),
                    child: Text(
                      "CONNECT WITH US",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  // Social Media Links
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon("assets/images/instagram.png",
                            "https://www.instagram.com"),
                        const SizedBox(width: 24),
                        _buildSocialIcon("assets/images/facebook.png",
                            "https://www.facebook.com"),
                        const SizedBox(width: 24),
                        _buildSocialIcon("assets/images/twitter.png",
                            "https://www.twitter.com"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // No user data found
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_off_outlined,
                    color: Color(0xFF6B7280),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No user data found",
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please log in again or create an account",
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => AuthenticationRepository.instance.logout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Go to Login"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  /// **Reusable Widget for Account Buttons**
  Widget _buildAccountButton(
      IconData icon, String title, String subtitle, VoidCallback onPressed) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(color: const Color(0xFFE5E7EB)),
      ),
      color: Colors.white,
      child: ListTile(
        onTap: onPressed,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: tPrimaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: tPrimaryColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2E3033),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        trailing: const Icon(
          LineAwesomeIcons.angle_right_solid,
          size: 16,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  /// **Reusable Widget for Social Media Icons**
  Widget _buildSocialIcon(String assetPath, String url) {
    return InkWell(
      onTap: () => _openURL(url),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Image.asset(assetPath, width: 22, height: 22),
      ),
    );
  }
}
