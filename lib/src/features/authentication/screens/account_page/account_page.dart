import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../constants/color.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../Profile_page/profile_page.dart';

// Natural color palette for the account page
class AccountColors {
  static const Color primaryColor = tPrimaryColor;
  static const Color secondaryColor = tSecondaryColor;
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF2E3033);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color errorColor = Color(0xFFDC3545);
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _image;
  final picker = ImagePicker();

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
          backgroundColor: AccountColors.errorColor,
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
        color: AccountColors.textPrimaryColor,
      ),
      backgroundColor: AccountColors.cardColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      titlePadding: const EdgeInsets.only(top: 20, bottom: 8),
      radius: 8,
      content: const Text(
        "Are you sure you want to sign out?",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AccountColors.textSecondaryColor,
          fontSize: 14,
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(
          foregroundColor: AccountColors.textSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text("Cancel"),
      ),
      confirm: TextButton(
        onPressed: () {
          AuthenticationRepository.instance.logout();
          Get.back(); // Close the dialog
        },
        style: TextButton.styleFrom(
          foregroundColor: AccountColors.errorColor,
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
      backgroundColor: AccountColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AccountColors.textPrimaryColor,
            fontSize: 18,
          ),
        ),
        backgroundColor: AccountColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.angle_left,
              color: AccountColors.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: AccountColors.cardColor,
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
                            color: AccountColors.primaryColor.withOpacity(0.2),
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey[100],
                          backgroundImage: _image != null
                              ? FileImage(_image!) as ImageProvider
                              : const AssetImage("assets/images/profile.png"),
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
                              color: AccountColors.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AccountColors.cardColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              LineAwesomeIcons.camera,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "John Doe",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AccountColors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "john.doe@example.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: AccountColors.textSecondaryColor,
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
                        color: AccountColors.textSecondaryColor,
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
                    LineAwesomeIcons.download,
                    "Downloads",
                    "Access your downloaded content",
                    () {},
                  ),
                  _buildAccountButton(
                    LineAwesomeIcons.lock,
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
                        LineAwesomeIcons.alternate_sign_out,
                        color: AccountColors.errorColor,
                        size: 18,
                      ),
                      label: const Text(
                        "Sign Out",
                        style: TextStyle(
                          color: AccountColors.errorColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                            color: AccountColors.errorColor.withOpacity(0.5)),
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
                  color: AccountColors.textSecondaryColor,
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
                  _buildSocialIcon(
                      "assets/images/facebook.png", "https://www.facebook.com"),
                  const SizedBox(width: 24),
                  _buildSocialIcon(
                      "assets/images/twitter.png", "https://www.twitter.com"),
                ],
              ),
            ),
          ],
        ),
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
        side: BorderSide(color: AccountColors.dividerColor),
      ),
      color: AccountColors.cardColor,
      child: ListTile(
        onTap: onPressed,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AccountColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AccountColors.primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AccountColors.textPrimaryColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AccountColors.textSecondaryColor,
            ),
          ),
        ),
        trailing: const Icon(
          LineAwesomeIcons.angle_right,
          size: 16,
          color: AccountColors.textSecondaryColor,
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
          color: AccountColors.cardColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: AccountColors.dividerColor,
            width: 1,
          ),
        ),
        child: Image.asset(assetPath, width: 22, height: 22),
      ),
    );
  }
}
